---
layout: post
title: python元编程原理
date: 2023-07-05 10:53:26
tags: python编程语言
---

本文是backtrader框架的元编程理论基础。

读者需对python有一定基础，对类有基本理解。

# 计算机语言通识

掌握通识，加深理解，先大概理解，不必苛求精确，用到时再说。

**计算机编程语言的本质是什么？**

直接给答案：是人和计算沟通的媒介手段。

你把计算机想象成外国人，操着你不懂的语言，它也不懂你说的语言。

双方为了沟通顺畅，需要做什么？翻译对吧。

这个负责翻译的角色是个软件，是人开发的，叫编译器。

编译器主要做一件事情，把人类编写的代码翻译成机器能懂的语言（叫机器码）。




# Python的执行过程

当我们在控制端执行一下指令时，会经历些什么过程？

```bash
python xx.py
```

首先python命令会读取.py文件，按照python的语法规则，识别出python语句内容，生成可执行的中间形式代码（python字节码）， 然后由pyton的解释器执行这些语句。注意这是大概流程，说复杂了会比较复杂，但是真没必要。

python的语法规则决定了.py文件的如何被解释。

**python的代码是一边翻译一边执行的。**

负责翻译的程序，在代码执行的时候一边读文件，一边翻译，一边执行。这个程序被叫做`翻译器`。

由于代码被`翻译器`处理过，所以翻译的过程是可以“搞点手段”的。

而这个手段，其实就可以理解为python元编程的逻辑基础。

我们要了解的就是这个手段的规则，即python的翻译器能识别操作代码的代码怎么玩。


下面我们来解释一下类相关的规则。


# 类的创建

类，是python解释器执行和调用其内部申明的方法，分别是`__new__`和`__init__`。

`__new__`是在类实例化创建时被调用的，先有类。

`__init__`是在类实例化完成后被调用来完成实例内部属性值的初始化。

`__call__`是类被()语法调用的时候调用的，直接给类加上被调用的能力。A()，就会执行类中`__call__`的代码。


python思想中，一切皆对象，类也是对象。类的创建过程，就是对象的创建过程。

所以，就形成了对象间的关系：

- 父子关系：子类是一种父类
- 类型实例关系：一个对象（实例）是另一个对象（类型）的具体实现。

为了标明类的关系，python中的类，有两个特殊的方法，分别是`__bases__`和`__class__`。

 `__class__`表示这个对象是谁创建的。

`__bases__` 表示一个类的父类是谁。可能有点绕，看下面例子。

```python
class A(object):
    pass
class B(A):
    pass

print(A.__class__) # <type 'type'>
print(B.__class__) # <type 'type'>
print(A.__bases__) # (<type 'object'>,)
print(B.__bases__) # (<class '__main__.A'>,)
# 实例
a=A()
b=B()
print(a.__class__) # <class '__main__.A'>
print(b.__class__) # <class '__main__.B'>
# 实例创建者的创建者
print(a.__class__.__class__) # <type 'type'>
```

这里直接给结论：

- type为对象的顶点，所有对象(当然也包概括类）都创建自type。
- object为类继承的顶点，所有类都继承自object。
- 实例的创建者是类，类的创建者是type。

用户自定义类，是type类的__call__（类被实例化的时候会被调用）运算符的重载。

当我们定义一个类，实际被转成了以下形式：

```text
yourclass = type(classname, superclasses, attributedict) # type类被实例化了会调用__call__方法
```

上面代码隐式的（自动）被执行为：

```text
type.__new__(typeclass, classname, superclasses, attributedict)
type.__init__(class, classname, superclasses, attributedict)
```

下面代码说明以上结论：

```python
class MyClass:
    data = 88

instance = MyClass()
print(MyClass, instance)
# Out:<class '__main__.MyClass'> <__main__.MyClass object at 0x0000026F3D8ED210>

MyClass = type('MyClass', (), {'data': 1})
instance = MyClass()
print(MyClass, instance)
# Out:<class '__main__.MyClass'> <__main__.MyClass object at 0x0000026F3D8ED2D0>

print(instance.data)
# Out: 88

```

上面代码中，我们自定义了一个类，然后实例化了一个对象。然后我们使用type类，来创建一个类，然后实例化了一个对象。
可以看出，两个对象的属性值是一样的。

现在有个问题，如果我们想自己定义类的创建过程，该怎么做呢？

这时候python规定在定义类的时候，给一个`metaclass`类属性定义一个值，就可以告诉python解释器，这个类创建的时候，想要自定义由哪个类的'__call__'来完成。

下面代码说明以上规则：

```python
class MyMeta(type):
    def __new__(cls, *args, **kwargs):
        print('===>MyMeta.__new__')
        return super().__new__(cls, *args, **kwargs)

    def __init__(self, classname, superclasses, attributedict):
        print(self.__class__)
        print(self.__base__)
        super().__init__(classname, superclasses, attributedict)
        print('===>MyMeta.__init__ Finished')
        print(self.__name__)
        print(attributedict)
        print(self.tag)

    def __call__(self, *args, **kwargs):
        print('===>MyMeta.__call__')
        obj = self.__new__(self, *args, **kwargs)
        self.__init__(self, *args, **kwargs)
        return obj


class Foo(object, metaclass=MyMeta):
    tag = '!Foo'

    def __new__(cls, *args, **kwargs):
        print('===>Foo.__new__')
        return super().__new__(cls)

    def __init__(self, name):
        print('===>Foo.__init__')
        self.name = name
        print("I am " + self.__name__)


print('test start')
foo = Foo('test')
print('test end')

# Out:
# ===>MyMeta.__new__
# <class '__main__.MyMeta'>
# <class 'object'>
# ===>MyMeta.__init__ Finished
# Foo
# {'__module__': '__main__', '__qualname__': 'Foo', 'tag': '!Foo', '__new__': <function Foo.__new__ at 0x000001D10B971DA0>, '__init__': <function Foo.__init__ at 0x000001D10B971E40>, '__classcell__': <cell at 0x000001D10B977D00: MyMeta object at 0x000001D10BAA34C0>}
# !Foo
# test start
# ===>MyMeta.__call__
# ===>Foo.__new__
# ===>Foo.__init__
# I am Foo
# test end
```

上面代码中，我们定义了一个用于创建类的MyMeta类，然后在Foo类中，使用`metaclass=MyMeta`来指定`MyMeta`来创建`Foo`类。

有意思的是MyMeta的__new__和__init__方法，先打印了内容，这说明创建类的类（这里是`MyMeta`)本身需要先被type创建，然后才会调用__call__去生成Foo。

综上，所谓元编程，其实就是利用了python语言的执行原理，内部定义的类，都是由type类创建的，所以我们可以自己定义一个类，来创建类，从而实现元编程。

既然，创建类可以自定义，那么创建对象也可以自定义。

类和对象都可以自己定义了，那么你想怎么操控它们，就怎么操控。是的，如果你懂了，就是在这3个方法里夹带私货。

# python注解

如果说类的生成是通过一定的方式告知解释器来实现自己想要的手段，

那么注解，就是有了类以后，方法调用上耍的手段了，这其实也是解释器提供的机制。

它们的相同点，都是在程序的代码到机器码转义的过程中，偷偷的带进去一些私活。

注解在网上有很多公开资料。下面大概介绍下**套路**。

Python的注解（Annotation）是一种在函数、类、方法、模块等对象上添加元数据的机制。它可以在代码中以特殊的语法进行声明，并将注解信息作为对象的属性存储起来。

注解的语法是在被注解的对象的上方使用`@`符号加上注解名，例如：

```python
@my_annotation
def my_function():
    pass
```

注解本身是一个可调用的对象（通常是一个函数），它接收被注解对象作为参数，并返回一个新的对象来替代原始对象。这个过程被称为注解的装饰（Decoration）。

使用注解的方法有多种，可以通过装饰器（Decorator）将注解应用到函数、类、方法等对象上，也可以直接调用注解函数来对对象进行注解。

下面是一个简单的示例，演示如何定义和使用一个注解：

```python
def my_annotation(func):
    def wrapper(*args, **kwargs):
        print("Before function execution")
        result = func(*args, **kwargs)
        print("After function execution")
        return result
    return wrapper

@my_annotation
def my_function():
    print("Inside my_function")

my_function()
```

运行上述代码，输出结果为：

```
Before function execution
Inside my_function
After function execution
```

在这个示例中，`my_annotation`是一个注解函数，它接收一个函数作为参数，并返回一个新的函数来替代原始函数。新函数在执行前后会打印一些信息。

通过使用`@my_annotation`装饰器将注解应用到`my_function`上，实际上相当于执行了`my_function = my_annotation(my_function)`，即将`my_function`替换为经过注解装饰后的新函数。

除了使用装饰器外，还可以直接调用注解函数来对对象进行注解，例如：

```python
def my_annotation(obj):
    obj.some_property = 42
    return obj

class MyClass:
    pass

my_instance = MyClass()
my_instance = my_annotation(my_instance)
print(my_instance.some_property)  # 输出 42
```

在这个示例中，`my_annotation`函数直接调用，将一个实例对象进行注解，添加了一个名为`some_property`的属性。

注解机制是通过装饰器和注解函数来实现的，它可以在函数、类、方法等对象上添加元数据，并且可以通过装饰器或直接调用注解函数来应用注解。使用注解可以为对象添加额外的属性或行为，从而实现更灵活的代码逻辑。

一句话总结：注解就是把被注解的函数、方法当作参数塞到注解里面，在注解体里完成被注解方法的调用。然后，你想干嘛就干嘛。

backtrader中使用的最多几个注解：

- `@classmethod`  静态方法，直接调用
- `@property` 将类的方法绑定为属性，当然注解通过访问属性，就可以调用函数，函数体里要干嘛你说了算。看码就懂：

```python
class Circle:
    def __init__(self, radius):
        self.radius = radius
    
    @property
    def area(self):
        return 3.14 * self.radius**2

    @property
    def circumference(self):
        return 2 * 3.14 * self.radius

circle = Circle(5)
print(circle.area)  # 输出 78.5
print(circle.circumference)  # 输出 31.400000000000002
```

- `@ibregister` 用处见下，给被注解函数加塞了一个属性

```python
# Decorator to mark methods to register with ib.opt
def ibregister(f):
    f._ibregister = True
    return f

```

# 结合Backtrader源码

## 为了兼容

首先说烧脑的一个点，它之所以烧脑是因为backtrader为了兼容python2和python3，是模仿`six`库包下的一个方法写的。

```python
# This is from Armin Ronacher from Flash simplified later by six 这里说了我是抄的。。
def with_metaclass(meta, *bases):
    """Create a base class with a metaclass."""
    # This requires a bit of explanation: the basic idea is to make a dummy
    # metaclass for one level of class instantiation that replaces itself with
    # the actual metaclass.
    class metaclass(meta):
        def __new__(cls, name, this_bases, d):
            return meta(name, bases, d)
            
    return type.__new__(metaclass, str('temporary_class'), (), {})
```

我简单说下这个方法的作用，主要通过自定义的该方法，倒一手，让python2的元编程语法和python3元编程语法可以和谐共处（backtrader执行融入到对应环境而不会出语法错误）。

上面的方法，通过返回一个统一的`metaclass`临时类，完成了2和3需要的`meta`类中转，所以它是`temporary_class`。

所以源码中我们看到`with_metaclass`方法就等于看到这个类。

`class BrokerBase(with_metaclass(MetaBroker, object))`  == `class BrokerBase(MetaBroker)`

## 元编程示例

为了简化对backtrader中元编程理解复杂度，下面示例，仅结合图示的几个类展示说明如何`元编程`。
![在这里插入图片描述](https://img-blog.csdnimg.cn/de6ce15958dd4f5286fceee51e47aae5.png)

### MetaBase

MetaBase类主要的元类，它就干了一件事，定义了一些列的动作，这些动作在`__call__`方法中按照顺序执行。

而这些动作的业务意义，交给子类来。给子类充分的自由，去扩展和定义类行为。

看源码看我加的备注：

```python
class MetaBase(type):
	# 类初始化前干点什么
    def doprenew(cls, *args, **kwargs):
        return cls, args, kwargs
	# 类初始化时干点什么
    def donew(cls, *args, **kwargs):
        _obj = cls.__new__(cls, *args, **kwargs)
        return _obj, args, kwargs
	# 类的实例初始化前干点什么
    def dopreinit(cls, _obj, *args, **kwargs):
        return _obj, args, kwargs
	# 类的实例初始化时干点什么
    def doinit(cls, _obj, *args, **kwargs):
        _obj.__init__(*args, **kwargs)
        return _obj, args, kwargs
	# 类的实例初始化后干点什么
    def dopostinit(cls, _obj, *args, **kwargs):
        return _obj, args, kwargs
	# 看这里，__call__方法里做了手脚，插进去好几个方法（对业务有干系），按序执行。
    def __call__(cls, *args, **kwargs):
        cls, args, kwargs = cls.doprenew(*args, **kwargs)
        _obj, args, kwargs = cls.donew(*args, **kwargs)
        _obj, args, kwargs = cls.dopreinit(_obj, *args, **kwargs)
        _obj, args, kwargs = cls.doinit(_obj, *args, **kwargs)
        _obj, args, kwargs = cls.dopostinit(_obj, *args, **kwargs)
        return _obj
```

### MetaParams

`MetaParams`是`MetaBase`子类，先自己定义`__new__`的行为，然后重写了`MetaBase`的`donew`方法。这里忽悠上面说的

“*给子类充分的自由，去扩展和定义类行为*”。

方法里具体干嘛了，此处不细说，大概解决包引用、参数的问题，一头进去容易迷失。留个印象即可。

```python
class MetaParams(MetaBase):
    def __new__(meta, name, bases, dct):
        # Remove params from class definition to avoid inheritance
        # (and hence "repetition")
        newparams = dct.pop('params', ())

        packs = 'packages'
        newpackages = tuple(dct.pop(packs, ()))  # remove before creation

        fpacks = 'frompackages'
        fnewpackages = tuple(dct.pop(fpacks, ()))  # remove before creation

        # Create the new class - this pulls predefined "params"
        cls = super(MetaParams, meta).__new__(meta, name, bases, dct)

        # Pulls the param class out of it - default is the empty class
        params = getattr(cls, 'params', AutoInfoClass)

        # Pulls the packages class out of it - default is the empty class
        packages = tuple(getattr(cls, packs, ()))
        fpackages = tuple(getattr(cls, fpacks, ()))

        # get extra (to the right) base classes which have a param attribute
        morebasesparams = [x.params for x in bases[1:] if hasattr(x, 'params')]

        # Get extra packages, add them to the packages and put all in the class
        for y in [x.packages for x in bases[1:] if hasattr(x, packs)]:
            packages += tuple(y)

        for y in [x.frompackages for x in bases[1:] if hasattr(x, fpacks)]:
            fpackages += tuple(y)

        cls.packages = packages + newpackages
        cls.frompackages = fpackages + fnewpackages

        # Subclass and store the newly derived params class
        cls.params = params._derive(name, newparams, morebasesparams)

        return cls

    def donew(cls, *args, **kwargs):
        clsmod = sys.modules[cls.__module__]
        # import specified packages
        for p in cls.packages:
            if isinstance(p, (tuple, list)):
                p, palias = p
            else:
                palias = p

            pmod = __import__(p)

            plevels = p.split('.')
            if p == palias and len(plevels) > 1:  # 'os.path' not aliased
                setattr(clsmod, pmod.__name__, pmod)  # set 'os' in module

            else:  # aliased and/or dots
                for plevel in plevels[1:]:  # recurse down the mod
                    pmod = getattr(pmod, plevel)

                setattr(clsmod, palias, pmod)

        # import from specified packages - the 2nd part is a string or iterable
        for p, frompackage in cls.frompackages:
            if isinstance(frompackage, string_types):
                frompackage = (frompackage,)  # make it a tuple

            for fp in frompackage:
                if isinstance(fp, (tuple, list)):
                    fp, falias = fp
                else:
                    fp, falias = fp, fp  # assumed is string

                # complain "not string" without fp (unicode vs bytes)
                pmod = __import__(p, fromlist=[str(fp)])
                pattr = getattr(pmod, fp)
                setattr(clsmod, falias, pattr)
                for basecls in cls.__bases__:
                    setattr(sys.modules[basecls.__module__], falias, pattr)

        # Create params and set the values from the kwargs
        params = cls.params()
        for pname, pdef in cls.params._getitems():
            setattr(params, pname, kwargs.pop(pname, pdef))

        # Create the object and set the params in place
        _obj, args, kwargs = super(MetaParams, cls).donew(*args, **kwargs)
        _obj.params = params
        _obj.p = params  # shorter alias

        # Parameter values have now been set before __init__
        return _obj, args, kwargs
```

### MetaBroker

子类，自己的`__init__`中添加了`translations `

```python
class MetaBroker(MetaParams):
    def __init__(cls, name, bases, dct):
        '''
        Class has already been created ... fill missing methods if needed be
        '''
        # Initialize the class
        super(MetaBroker, cls).__init__(name, bases, dct)
        translations = {
            'get_cash': 'getcash',
            'get_value': 'getvalue',
        }

        for attr, trans in translations.items():
            if not hasattr(cls, attr):
                setattr(cls, name, getattr(cls, trans))
```

## python类继承

子类继承父类，就是一个贴狗皮膏药的过程。

下面是backtrader中文官方文档拷贝过来的，偷个懒。


我用一句话总结：没有的用父类，否则用自己的，父类相同的用最后的。方法子类可以直接用父类的，也可以自己写覆盖父类。

- 支持多重继承

```python
class A(bt.Indicator):
    params = dict(a=1, b=2)
class B(bt.Indicator):
    params = dict(b=3, c=4)
class C(A, B):
    pass
print(C().params.a)  # 1
print(C().params.b)  # 3
print(C().params.c)  # 4
```

- 来自基类的参数被继承

```python
class A(bt.Indicator):
    params = dict(a=1, b=2)
class B(A):
    params = dict(b=3, c=4)
class C(B):
    pass
print(C().params.a)  # 1
print(C().params.b)  # 3
print(C().params.c)  # 4
```

- 如果多个基类定义相同的参数，则使用继承列表中最后一个类的默认值

```python
class A(bt.Indicator):
    params = dict(a=1, b=2)
class B(A):
    params = dict(b=3, c=4)
class C(A, B):
    pass
print(C().params.a)  # 1
print(C().params.b)  # 3
print(C().params.c)  # 4
```

- 如果在子类中重新定义相同的参数，则新的默认值将接管基类的默认值

```python
class A(bt.Indicator):
    params = dict(a=1, b=2)
class B(A):
    params = dict(b=3, c=4)
class C(A):
    params = dict(a=5)
print(C().params.a)  # 5
print(C().params.b)  # 2
```

下面是线的继承代码示例：

```python
class MyIndicator(bt.Indicator):
    lines = ('line1', 'line2')

class MySubIndicator(MyIndicator):
    lines = ('line2','line3')
```

在上面的示例中，MySubIndicator 继承了 MyIndicator 的线 line1 ,覆盖了父类的line2，并添加了一个新的线 line3。

懂得了继承机制，就会更容易理解backtrader的源码。
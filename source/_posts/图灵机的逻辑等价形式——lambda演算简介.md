---
title: 图灵机的逻辑等价形式——lambda演算简介
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 计算机科学基础

date: 2018-07-28 17:07:31
---
# 译者述

才疏学浅，非数学专业，翻译尽量尊重原文，如有纰漏，海涵。

# 论文摘要

这篇论文是一篇简短易懂的lambda演算介绍。λ-calculus（lambda演算）是Alonzo Church开创，最初是作为研究数学函数的可计算性的相关属性的工具，随着它的流行，其逐渐成为函数编程语言家族强有力的理论基础。这篇简介展示了利用lambda演算如何构建算数和逻辑的数学计算，以及如何定义递归函数（尽管lambda演算子中的函数是匿名的，因此它们不能被显示引用，我们仍然可以定义递归函数）。

# 1 定义Definition

lambda演算子可以说是世界上最小的通用编程语言。lambda演算子由一个单一转换规则(变量替换，通常被叫做β-conversion，β变换)和一个单一函数定义系统构成。它在1930年代被Alonzo Church作为一个方法引入有效计算能力的概念的形式化中。lambda演算子是通用的，是因为任意可计算函数可以使用此形式表达和求值。因此它等价于图灵机（这也是为什么我费劲翻译原文的原因）。尽管如此，lambda演算子强调的是符号变换规则的使用，却并不关心实际机器是如何实现这些规则的。这是一个更接近软件而不是硬件的方法。

lambda演算子的核心概念是“表达式”（“expression”）。一个“名字”，也被叫做“变量”，是一个标示符，它可以是任意字母a, b, c… 一个表达式可能只是一个名字或者可能是一个函数（function）。函数使用希腊字母λ来来表示函数变量的名字。函数体（body）指定变量名如何排列。身份函数（The identity function），例如：字符串(λx.x）可以代表一个身份函数，字符串中的“λx”告诉我们函数的变量是“x”，“x”是被函数体不做任何改变的返回了。

函数可以被其他的函数使用。比如，函数A被用在了函数B中，可以写为“AB”的形式。注意在本文中，大写的字母被专门用来表示**函数**。实际上，Lambda演算中任何元素都可是函数，就连数字或者逻辑值都使用可以相互作用的函数来表示，它们是通过符号的字符串转换成另一种符号的字符串达到目的的。所以Lambda演算中没有类型一说，任何函数可以作用于其他函数。开发者的责任是保证计算指令的合理性。

表达式被第归的定义如下：
```js 
< expression > := < name >|< function >|< application >
< function > := λ < name > . < expression >
< application > := < expression >< expression >

译文形式
<表达式> := <标识符>|<函数>|<应用>       
<函数> := λ<标识符> . <表达式>
<应用> := <表达式><表达式>
译者注：应用(application )即给函数一个(实际)参数进行求值
```

表达式可以使用括号来包裹以达到清晰表示的目的，比如“E”为一个表达式，"(E)“是等效的（译者加了引号）。另外，这门语言中仅有的两个关键字是"λ “和”.”。为了避免将带括号的表达式混淆，我们约定：函数应用从左边开始关联（左结合），也就是下方的组合表达式：

E 1E 2E 3 . . . E n  可以被下面连续表达式所表示：  (...((E 1E 2)E 3) . . . E n)

从 λ表达式的定义可见，一种优雅的函数表现形式是之前出现过的的字符串，带括号或者不带括号：

λx.x ≡ (λx.x)

<!-- more -->
当表达式A和表达式B表达相同意义时，我们使用恒等号“A≡B”来表示。上面已介绍过，“λ"右侧的字符是函数的标识符。而”."后边的表达式是函数体的定义。

函数可以被用在表达式中，下面是这种方式的一个应用（ application）：
(λx.x)y  上边的应用是身份函数使用在了标识符（译者注：没有type一说，不存在变量一说，原文用的 variable）y上。括号的使用避免了混淆。函数应用是以替换函数体内参数x的值(在这个例子里是y正在被处理)的方式被求值，图例1（Figure 1）红线部分展示了函数如何使变量“y”被抽象化（原文“absorbed”），绿色部分则展示了y如何替代了x。它的结果是表达式缩减的，用→箭头指示了，终值为y。

![在这里插入图片描述](https://windanchaos.github.io/images/dn.net-20181006220940506-watermark-2-text-aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dpbmRhbmNoYW9z-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)

由于我们也不能总是借助如图例1一样的图片，我们使用[y/x]的符号来表示在函数体内，所有x被y替换。例如，可以书写为：
(λx.x)y → [y/x]x → y

函数内的变量名并不代表符号的任何实际的意义，仅仅是占位符，被用来表示函数运行过程中参数如何被编排。所以以下的字符串代表的是同一个函数：

(λz.z) ≡ (λy.y) ≡ (λt.t) ≡ (λu.u)  这种纯粹的字母替换方式也被叫做 α-变换(α-reduction)。

## 1.1 自由和约束变量Free and bound variables

如果我们拥有λ表达式的的管道图（直观的），我们并不用过多考虑变量的名称。就如本章节的内容一样，使用了字母作为符号的λ演算，要避免字母的重复，需要我们小心谨慎从处理。
在λ演算中，所有的名字都是本地定义的（和大多数编程语言一样）。在函数"λx.x"中，我们说x自它出现在函数体中就被前置的λx约束了。与之对应的，一个没有被约束的变量叫做自由变量（“free variable”，编者注：没有定性的，既可以是函数、也可以是应用、也可以是表达式），在表达式:
(λx.x)(λy.yx)  左侧第一个表达式中的x被约束于第一个λ。第二个表达式中，y则被第二个λ约束，它里面的x则是自由的。需要特别注意的是第二个表达式中的x是独立的，和第一个表达式中的x没有任何关系。图例2中，可以很容易看出函数应用的管道图

![在这里插入图片描述](https://windanchaos.github.io/images/dn.net-20181006230526624-watermark-2-text-aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dpbmRhbmNoYW9z-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)
图例2中，我们看到第一行中的符号表达式如何被演绎成一种循环，即表达式中的约束变量如何被移动到新的函数体中。第一个函数“消费”了第二个函数。第二个函数的符号x和余下的表达式没有关联，它是在函数定义中自由变量。
形式上的，我们说变量在表达式中是自由变量，通常满足以下条件之一即可：

```js 
• <name> is free in <name>.
(Example: a is free in a).
• <name> is free in λ<name1 >. <exp> if the identifier <name>!=<name1 >
and <name> is free in <exp>.
(Example: y is free in λx.y).
• <name> is free in E1E2 if <name> is free in E1 or if it is free in E2.
(Example: x is free in (λx.x)x).
```

变量在表达式中是约束变量，通常满足以下条件之一即可：

```js 
• <name> is bound in λ <name1 >. <exp> if the identifier <name>=<name1 >
or if <name> is bound in <exp>.
(Example: x is bound in (λy.(λx.x))).
• <name> is bound in E1E2 if <name> is bound in E1 or if it is bound
in E2.
(Example: x is bound in (λx.x)x).
```

## 1.2替换Substitutions

刚开始接触λ演算，λ演算中让人疑惑的是我们并没有给函数命名。任何时候我们想要使用一个函数，我们只是写下完整的函数定义，接着开始求值。为了简化符号，我们将使用大写字母、数字和其他以写符号来作为某些函数的代名词（表征）。比如，身份函数能够使用字母"I"来简写（λx.x）。
身份函数使用自身则是一个应用：
II ≡ (λx.x)(λx.x)

上面表达式中，第一个括号内的函数体中的x和第二个括号中的函数体的x是没有联系的，为了强调它们的差异，我们也可以将上面的表达式重写，使用以下表达式表示：

II ≡ (λx.x)(λz.z)  身份函数作用于自己的值域，也就是再次成为I：  [(λz.z)/x]x → λz.z ≡ I,

![在这里插入图片描述](https://windanchaos.github.io/images/dn.net-20181007174924596-watermark-2-text-aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dpbmRhbmNoYW9z-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)
我们执行替换时，要注意避免将自由变量混淆成为约束变量。表达式中包含一个约束变量y，但在函数体外还有一个自由变量y，不应该混淆它们。简要处理将一个y，替换（Alpha转换）为下面形式：

(λx.(λt.xt))y  得到表达式：  (λt.yt)  虽然形式上完全不同却是一个正确的结果。 因此，如果函数 λy. < exp >被运用到E，我们就用E替换掉< exp >中的所有的参数y。如果替换x可能导致E中的自由变量x被转换成约束变量，就在替换前重命名函数中的约束变量y。例如表达式：  (λx.(λy.(x(λx.xy)))) y  我们让第一个x和y关联：  (λy.(x(λx.xy)))  只有第一个x是自由变量，可以被替换。替换前，我们必须重命名变量y以避免和约束变量混淆，于是为：  [y/x] (λt.(x(λx.xt))) → (λt(y(λx.xt)))  （译者注：[y/x]已经定义为：表示x将被y替换）

译者加以下内容[1]以辅助理解：

**Alpha转换**
Alpha是一个重命名操作; 基本上就是说，变量的名称是不重要的：给定Lambda演算中的任意表达式，我们可以修改函数参数的名称，只要我们同时修改函数体内所有对它的自由引用。
所以 —— 例如，如果有这样一个表达式：
lambda x . if (= x 0) then 1 else x ^ 2
我们可以用Alpha转换，将x变成y（写作alpha[x / y]），于是我们有：
lambda y . if (= y 0) then 1 else y ^ 2
 
**Beta规约**
Beta基本上是说，如果你有一个函数应用，你可以对这个函数体中和对应函数标识符相关的部分做替换，替换方法是把标识符用参数值替换。这听起来很费解，但是它用起来却很容易。
假设我们有一个函数应用表达式：“ (lambda x . x + 1) 3 “。所谓Beta规约就是，我们可以通过替换函数体（即“x + 1”）来实现函数应用，用数值“3”取代引用的参数“x”。于是Beta规约的结果就是“3 + 1”。
一个稍微复杂的例子：(lambda y . (lambda x . x + y)) q。 这是一个挺有意思的表达式，因为应用这个Lambda表达式的结果是另一个Lambda表达式：也就是说，它是一个创建函数的函数。这时候的Beta规约，需要用标识符“q”替换所有的引用参数“y”。所以，其结果是“ lambda x . x + q “。
再给一个让你更不爽的例子：“ (lambda x y. x y) (lambda z . z /* z) 3 “。这是一个有两个参数的函数，它(的功能是)把第一个参数应用到第二个参数上。当我们运算时，我们替换第一个函数体中的参数“x”为“lambda z . z /* z “；然后我们用“3”替换参数“y”，得到：“ (lambda z . z /* z) 3 “。 再执行Beta规约，有“3 /* 3”。
Beta规则的形式化写法为：
lambda x . B e = B[x := e] if free(e) subset free(B[x := e])
最后的条件“if free(e) subset free(B[x := e])”说明了为什么我们需要Alpha转换：**我们只有在不引起绑定标识符和自由标识符之间的任何冲突的情况下，才可以做Beta规约：如果标识符“z”在“e”中是自由的，那么我们就需要确保，Beta规约不会导致“z”变成绑定的。如果在“B”中绑定的变量和“e”中的自由变量产生命名冲突，我们就需要用Alpha转换来更改标识符名称，使之不同。**
例子更能明确这一点：假设我们有一个函数表达式，“ lambda z . (lambda x . x + z) “，现在，假设我们要应用它：
(lambda z . (lambda x . x + z)) (x + 2)
参数“(x + 2)”中，x是自由的。现在，假设我们不遵守规则直接做Beta规约。我们会得到：
lambda x . x + x + 2
原先在“x + 2”中自由的的变量现在被绑定了。再假设我们应用该函数：
(lambda x . x + x + 2) 3
通过Beta规约，我们会得到“3 + 3 + 2”。
如果我们按照应有的方式先采用Alpha转换，又该如何？
由 alpha[x/y] 有: (lambda z . (lambda y . y + z)) (x + 2)
由Beta规约： (lambda y . y + x + 2) 3
再由Beta规约： 3 + x + 2 。
“3 + x + 2”和“3 + 3 + 2”是非常不同的结果！

# 2 算数Arithmetic

编程语言应该具备制定算数计算的能力。在lambda演算中数字是从0开始的，并且以0的后继形式演算出其他数字（“successor of zero”），即“suc(zero)代表1，suc(suc(zero))代表2，以此类推。因为在lambda演算中，我们只能定义函数，所以数字可以以下方函数的方式被定义，0可以被定义为：
λs.(λz.z)  函数中有2个参数：s和z。简写为：  λsz.z  明显的在第一个变量s将在演算中被替换，接着是z（。使用这种符号形式，自然数可以如下定义：

0 ≡ λsz.z
1 ≡ λsz.s(z)
2 ≡ λsz.s(s(z))
3 ≡ λsz.s(s(s(z)))

译者加：
一个很好的理解办法是将“z”作为是对于零值的命名，而“s”作为后继函数的名称。因此，0是一个仅返回“0”值的函数；1是将后继函数运用到0上一次的函数；2则是将后继函数应用到零的后继上的函数，以此类推。[1]

译者加：
![来自wiki的图片](https://windanchaos.github.io/images/rg-api-rest_v1-media-math-render-svg-4234d6babd69a13a183ee913a1efd0c3264da618.png)

以这种方式定义数字的一个好处是，我们能够任意次数的应用一个函数f到一个参数。例如，我们想要应用函数一个带参a的函数f3次，它的值为：
3f a → (λsz.s(s(sz)))f a → f(f(f a)).
这种定义数字的方式提供了一种其他编程语言中类似“FOR i=1 to 3”的语言结构。数字0被应用于带参a的函数f，则它的值是
0f a ≡ (λsz.z)f a → a
等价于，将参数a应用于函数0次，返回的是未经改变的a原值。

本章节定义的函数，也可以定义为：
S ≡ λnab.a(nab)
虽然看起来不太合适，但确实起作用。比如，用0来应用在后继函数上的表达式为：
S0 ≡ (λnab.a(nab))0
该表达式中，我们将n替换为0，表达式为：
λab.a(0ab) → λab.a(b) ≡ 1
以此类推:2的值为：
S1 ≡ (λnab.a(nab))1 → λab.a(1ab) → λab.a(ab) ≡ 2

## 2.1 加法Addition

to do

## 2.2 乘法 Multiplication

to do

# 3 条件语句Conditionals

to do

## 3.1逻辑操作Logical operations

## 3.2一个逻辑测试A conditional test

## 3.3前驱函数The predecessor function

## 3.4等式和不等式Equality and inequalities

# 4递归Recursion

to do

# 5给读者习题Projects for the reader

[点击下载翻译的源文章](https://arxiv.org/pdf/1503.09060v1.pdf)

其他lambda演算有关的资源：

[1] [Good Math/Bad Math的Lambda演算系列的中文翻译](http://cgnail.github.io/academic/lambda-index/) （有墙需翻）
[实践中认识lambda演算](https://blog.csdn.net/houmou/article/details/49617331)

[https://blog.csdn.net/feosun/article/details/2110116](https://blog.csdn.net/feosun/article/details/2110116)

[http://www.blogjava.net/wxb_nudt/archive/2005/05/15/4311.aspx](http://www.blogjava.net/wxb_nudt/archive/2005/05/15/4311.aspx)

编程时函数通常可以有一个参数列表，逻辑学家 Haskell Curry证明可以将一个拥有多个参数的函数转化为只有一个参数的多个函数的连续调用，这一转化过程称为对拥有多个参数的函数的currying/柯里化。

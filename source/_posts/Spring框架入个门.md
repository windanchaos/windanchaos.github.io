---
title: Spring框架入个门
date: 2020-03-19 22:12:02
category:
	- 后端框架和技术
---



计划覆盖一些常见的框架，首选spring boot，在这之前先学习spring基础原理。大致了解后再进入spring boot。所以，spring去学习的时候不会过于纠结太深入的内容。大致了解原则，这篇内容就是这套逻辑下的笔记内容。看了2套视频，前后花了6天时间。

以下内容结合了个人理解整理而成，不保证描述完全准确。

# 初识Spring

面向接口编程、解耦。私有变量只申明，但不new对象，变量用它的接口。

Spring解决企业级开发的痛点，数不清的类之间的相互关系，委托给Spring来管理。用个术语：装配。

Bean实际上是Spring中负责加载具体业务对象的类。Spring提供了装配类对象实例的机制。这套机制是IOC\AOP的思想，对应的具体实现是DI（依赖注入）和java的注解实现的AOP和aspectJ实现的AOP。

在学习spring过程中，突发灵感，认识到计算机世界中，context是多么的重要。context在这里我表征软件执行的环境、输入条件、依赖等前置因素。所有的代码，都是在进程开始启动过程中，完成初始化、环境构造、代码执行这么一套流程的。大体，这是目前我所理解的软件的抽象。


Spring配置类注解作为入口，把类加载到运行时中（默认是单例模式，可控制），类和类之间的组合关系，实现相同接口的接口实现之间的如何区分。都提供了注解机制。

# 注入和装配的套路
入门级的套路：xml配置和注解基本上在自己可控源码的化效果是等价的。在第三方的源码上，利用xml方式。

Spring的在做注入时，秉着一条“傻瓜”原则，只要spring的容器中某类的实例只有一个，那么只要你告诉（配置xml和注解）spring
那么，就会自动去绑定。如果有多个，设定必要的标识（名称、顺序等）区分也就完成了绑定工作。
## 注解的套路
下面的注解是入门级的示意。
```java
#需要被Spring加载标识
@Component @Controller @Service @Repository

# 解决歧义（让引擎识别相同接口不同的实现对象，或者相同类的不同bean，靠名称或默认类名首字母小写）
@Autowired(required=true)
#相同接口的区分手段之一
@Qualifier
# java原生的区别手段
@Resource

# 引入外部类不方便使用Componet等时，可以加注解
# 被加了备注的方法，会自动去运行时环境中查找参数涉及的类的实例
@Bean 
```
<!-- more -->

## xml的套路
下面的内容是最基本的示意。
```
    <!--
    bean元素，描述需要spring管理的对象
    id:标示对象，在content中调用的key，获取对象
    -->
    <bean id="service" class="xmlconfigDemo.MessageService"></bean>
    <bean id="messagePrinter" class="xmlconfigDemo.MessagePrinter">
        <property name="service" ref="service"></property>
    </bean>
```
# IOC控制反转 和 DI
IOC(Inverse Of Controll)，控制反转。它是一种编程思想，对标OOP（面向对象）。

控制反转可以理解为，它要反转依赖关系的满足方式，由之前编码者自己创建依赖对象，变为由工厂提供。（主动变为被动，即反转），解决了具有依赖关系的组件之间的耦合。

具体表现：私有变量只申明，但不new对象，不new对象就做了解耦。变量用它的接口申明，实现了面向接口，面向抽象编程的思想。利用Spring的机制，在程序运行时候进行动态的绑定，这里的绑定可以理解为建立组合关系。

DI(dependency Injection)，依赖注入。

全新的依赖满足方式，体现在编码中就是全新的赋值方式。在工厂中为属性推送值。

IOC是思想，DI是具体的措施。
# 注入的方式
## set方式
核心，类的成员变量提供set方法。在xml文件当中进行配置。
例子中类，成员变量都有set方法。
```
    <bean id="didemo" class="diDemo.SetDI">
        <!-- 简单类型 基本类型-->
        <property name="id" value="4"/>
        <property name="gender" value="true"/>
        <property name="name" value="windanchaos"/>
        <!-- 用用类型 -->
        <property name="userDao" ref="userdao" />
        <property name="list" >
            <list>
                <value>gp01</value>
                <ref bean="userdao"/>
            </list>
        </property>
    </bean>
```
## 构造注入
借助构造方法来完成注入。
```
    <bean id="diset" class="diDemo.ConstructorDI">
        <constructor-arg index="0" type="boolean" value="false"></constructor-arg>
        <constructor-arg index="1" type="java.lang.Integer" value="1"></constructor-arg>
        <constructor-arg index="2" type="java.lang.String" value="hong"></constructor-arg>
    </bean>
```
## 自动注入
spring自动识别属性，并注入。
autoWired 两种方式，byType和byName。
# Bean
Bean是Spring中的名词，指代被控制反转的对象实例。
## 创建原理
利用反射实现,默认调用无参构造。

比如配置<bean id="diset" class="diDemo.ConstructorDI">
```
String classpath="diDemo.ConstructorDI";
Class class=Class.forName(classpath);
Constructor constructor=class.getConstructor;
ConstructorDI o=(ConstructorDI) contructor.newInstance();
```
## bean的创建模式（参数scope）
- 单例模式，启动就创建。
- 多例（原型prototype），调用才重新生成。

有状态则多例；无状态则单例。Spring中大部分是单例。
有状态会话bean：每个用户有自己特有的一个实例，在用户的生存期内，bean保持了用户的信息，即“有状态”；一旦用户灭亡（调用结束或实例结束），bean的生命期也告结束。即每个用户最初都会得到一个初始的bean。简单来说，有状态就是有数据存储功能。有状态对象(Stateful Bean)，就是有实例变量的对象 ，可以保存数据，是非线程安全的。

无状态会话bean：bean一旦实例化就被加进会话池中，各个用户都可以共用。即使用户已经消亡，bean的生命期也不一定结束，它可能依然存在于会话池中，供其他用户调用。由于没有特定的用户，那么也就不能保持某一用户的状态，所以叫无状态bean。但无状态会话bean   并非没有状态，如果它有自己的属性（变量），那么这些变量就会受到所有调用它的用户的影响，这是在实际应用中必须注意的。简单来说，无状态就是一次操作，不能保存数据。无状态对象(Stateless Bean)，就是没有实例变量的对象，不能保存数据，是不变类，是线程安全的。

## 工厂bean
复杂对象的注入机制。

FactoryBean：生产某一种的对象。

生命周期同常规的bean。如果用户通过getbean获取一个FactoryBean时，返回的不是工厂bean本身，而是其生产的对象。如果要获取工厂本身，需使用“&beanID”=="&mySqlSessionFactory"。

有三种实现方式：
- implement FactoryBean

- 静态

- 工厂方法

  
## bean的生命周期
单例bean：构造（工厂启动）->Set -> init -> 被调用 -> 跟随工厂关闭

多例bean：获取是才创建 -> set -> init -> 被使用 -> 不跟随工厂关闭而销毁

正是bean的生命周期分成很多阶段，因而可以在很多步骤中增加其他的行为。这也是AOP的一个切入点。

# AOP
AOP(Aspect-Oriented-Programming)，面向切面编程，是一种思想，有AOP联盟。AOP常见框架：spring-aop,aspectJ。

切面：Aspect，由**切入点**和**额外功能**（增强）组成。

作用：提供了新的编程角度，不再只考虑类、对象，可以考虑切面。切面和目标形成代理，解决项目中额外功能的冗余问题。

业务层中存在问题：两类逻辑=核心业务+额外功能，其中额外功能存在大量冗余代码，使得项目维护存在极大隐患。

构建时刻：在bean的后处置过程中，会讲基于bean定制的一个他的代理类（对象）返回。

为什么可以做AOP呢，因为bean的生命周期托管给了spring容器，那么在bean的生命周期中“做点手脚”是很容易的：

构造 -> 注入属性满足有依赖 ->  后处理器前置过程 -> 初始化 -> 后处理器后置过程 -> 返回 -> 销毁。

Spring的AOP结合了java JDK的方式和aspectJ框架两种方式。

前者 处理有接口的代理，后者处理类的代理。可设置强制使用aspectJ方式。


代理和AOP不能划等号，代理是AOP思想的一种方式。还有其他方式，比如Filter。

这里专门延伸写了另一篇笔记，其中就包含了java代理和spring的AOP例子：


https://blog.windanchaos.tech/2020/03/16/java%E5%8A%A8%E6%80%81%E4%BB%A3%E7%90%86/

## 常见的集中advice
advice是sprin中AOP的接口，需要增强（切入）的功能实现不同 的advice接口，配置成bean，再插入到切入点即可。

常用的几类advice接口（额外功能）：
- MethodBeforeAdvice
- AfterReturningAdvice
- methodInterceptor(环绕)
- ThrowsAdvice(核心功能抛出异常时的日志增强)

## 切入点表达式
切入点表达式的核心作用就是在生成代理过程中，告知spring哪些地方需要作为切入。一条切入点的配置就代表一类切入点，可精确可模糊。

看别人写的：

https://blog.csdn.net/Huangyuhua068/article/details/83348921

## AOP的底层细节
略。



以下内容目前学了但没有跟着敲代码。这一块的代码在之后学习电商代码时再补起来。

# Spring整合Mybatis
我没有专门学习过mybatis，这一块就先pass。
# Sprin整合Service及事务管理

# Srping的web容器集成



参考：
跟着这个视频学习和跟敲代码2天：

https://www.bilibili.com/video/av45541219

再来一遍的视频：

https://www.bilibili.com/video/av83878015




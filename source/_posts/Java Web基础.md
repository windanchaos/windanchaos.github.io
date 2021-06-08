---
title: Java Web基础
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Java编程语言

date: 2016-06-23 11:30:10
---
参考来源：[http://www.xuebuyuan.com/2153333.htm](http://www.xuebuyuan.com/2153333.htm)

**1.Action/Service/DAO简介：**

Action是管理业务（Service）调度和管理跳转的。

Service是管理具体的功能的。

Action只负责管理，而Service负责实施。

DAO只完成增删改查，虽然可以1-n，n-n，1-1关联，模糊、动态、子查询都可以。但是无论多么复杂的查询，dao只是封装增删改查。
至于增删查改如何去实现一个功能，dao是不管的。

总结这三者，通过例子来解释：

Action像是服务员，顾客点什么菜，菜上给几号桌，都是ta的职责；

Service是厨师，action送来的菜单上的菜全是ta做的；

Dao是厨房的小工，和原材料打交道的事情全是ta管。

相互关系是，小工(dao)的工作是要满足厨师(service)的要求，厨师要满足服务员(action)转达的客户（页面用户）的要求，服务员自然就是为客户服务喽。

现在最基本的分层方式，结合了SSH架构。Model层就是对应的数据库表的实体类。Dao层是使用了hibernate连接数据库、操作数据库（增删改查）。
Service层：引用对应的Dao数据库操作。Action层：引用对应的Service层，在这里结合Struts的配置文件，跳转到指定的页面，当然也能接受页面传递的请求数据，也可以做些计算处理。

以上的Hibernate,Struts，都需要注入到spring的配置文件中，Spring把这些联系起来，成为一个整体。

**2.三大框架Struts/Hibernate/Spring**

简单地说：

Struts——控制用的；

Hibernate——操作数据库的；

Spring——解耦用的。
<!-- more -->

详细地说：

Struts在SSH框架中起控制的作用，其核心是Controller，即ActionServlet，而ActionServlet的核心就是Struts-config.xml，主要控制逻辑关系的处理。

SSH框架的系统从职责上分为四层：表示层、业务逻辑层、数据持久层和域模块层，以帮助开发人员在短期内搭建结构清晰、可复用性好、维护方便的Web应用程序。其中使用Struts作为系统的整体基础架构，负责MVC的分离，在Struts框架的模型部分，控制业务跳转，利用Hibernate框架对持久层提供支持，Spring做管理，管理struts和hibernate。具体做法是：用面向对象的分析方法根据需求提出一些模型，将这些模型实现为基本的Java对象，然后编写基本的DAO(DataAccessObjects)接口，并给出Hibernate的DAO实现，采用Hibernate架构实现的DAO类来实现Java类与数据库之间的转换和访问，最后由Spring做管理，管理struts和hibernate。

系统的基本业务流程是：在表示层中，首先通过JSP页面实现交互界面，负责接收请求(Request)和传送响应(Response)，然后Struts根据配置文件(struts-config.xml)将ActionServlet接收到的Request委派给相应的Action处理。在业务层中，管理服务组件的SpringIoC容器负责向Action提供业务模型(Model)组件和该组件的协作对象数据处理(DAO)组件完成业务逻辑，并提供事务处理、缓冲池等容器组件以提升系统性能和保证数据的完整性。而在持久层中，则依赖于Hibernate的对象化映射和数据库交互，
处理DAO组件请求的数据，并返回处理结果。

Hibernate是数据持久化层，是一种新的对象、关系的映射工具，提供了从Java类到数据表的映射，也提供了数据查询和恢复等机制，大大减少数据访问的复杂度。把对
数据库的直接操作，转换为对持久对象的操作。

什么是解耦？（来源：知乎）
就是每个部分独立变化。举个简单的例子，画一个三角形和画一个文字，在DX和OpenGL下面用的是截然不同的方法（不仅仅是函数名不一样）。但是你哪一天你发现，
你爱用DX还是OpenGL，丝毫不影响你如何画三角形还是文字，爱画什么画什么，那么你画的东西跟你画的手段就解耦了。这个解耦的方法就是在中间插入一层interface。
孔子曰，软件的所有问题都可以通过增加一层interface来解决。你的团队越大，需求变化越快，你越要保证程序员之间的依赖关系越少，你的软件解耦的就越好，interface
就越多，关系就越复杂（跟乱不一样），应付变化就越容易，钱赚的就越多，越稳定。
作者：vczh
链接：[http://www.zhihu.com/question/20821697/answer/27422839](http://www.zhihu.com/question/20821697/answer/27422839)

Spring是一个轻量级的控制反转(IoC)和面向切面(AOP)的容器框架。面向接口的编程，由容器控制程序之间的依赖关系，而非传统实现中，由程序代码直接操控。这就是所谓
“控制反转”的概念所在：（依赖）控制权由应用代码中转到了外部容器，控制权的转移，是所谓反转。依赖注入，即组件之间的依赖关系由容器在运行期决定，形象地说，即由容
器动态地将某种依赖关系注入到组件之中，起到的主要作用是解耦。

Struts、Spring、Hibernate在各层的作用：

（1） Struts负责Web层：ActionFormBean接收网页中表单提交的数据，然后通过Action进行处理，再Forward到对应的网页。在Struts-config.xml中定义，ActionServlet会加载。

（2）Spring负责业务层管理，即Service（或Manager）。
Service为action提供统计的调用接口，封装持久层的DAO；
可以写一些自己的业务方法；
统一的Javabean管理方法；
声明式事务管理；
集成Hibernate。
（2） Hibernate，负责持久化层，完成对数据库的crud操作。提供OR/Mapping。它由一组.hbm.xml文件和POJO，是跟数据库中的表相对应的。然后定义DAO，这些是跟数据库打交道的类，它们会使用PO。

**3.框架业务逻辑分析：**

在Struts+Spring+Hibernate的系统中，

对象的调用流程是：JSP—Action—Service—DAO—Hibernate。

数据的流向是：ActionFormBean接受用户的数据，Action将数据从ActionFormBean中取出，封装成VO或PO，再调用业务层的Bean类，完成各种业务处理后再Forward。
而业务层Bean收到这个PO对象之后，会调用DAO接口方法，进行持久化操作。

SSH框架的优点：

Hibernate的最大好处就是根据数据库的表，反向生成实体类，并且还有关系在里面，还有就是它对数据的操作也很方便；

Spring，省去了在类里面new对象的过程，把这个调用与被调用的关系直接展示到了配置文件里，做任何操作都变得简单了。

简单流程举例说明：

程序框架搭建好，并且把各种jar包导入后，就开始进行业务逻辑分析——假设一个最基本的注册功能：页面有两个文本框，一个用户名(username)和一个密码(password)。以QQ注册网页说明，这里以昵称和密码为代表进行举例。

![这里写图片描述](/images/dn.net-20141111230225984.png)

首先是action层：它是负责在页面和程序之间传输数据的，还有作用是做页面跳转。页面由用户填写表单数据，点击提交按钮，页面的表单数据由Hibernate自动封装到该
页面表单所对应的ActionFrom（ActionFrom跟实体类不是一个东西，ActionFrom是页面有什么值，类里就写什么属性，是用来封装表单数据用的；而实体类是完全按照数据库的
字段生成的，实体类可以当做ActionFrom用，但ActionFrom绝对不可以当做实体类用），这样表单数据就以ActionFrom对象的形式在Action的点击“提交按钮”执行的那个
方法里存在了。这个时候需要做的就是把表单数据存入数据库中。此时，Action的功能告一段落，接着是把数据传入BIZ层。

BIZE层（业务逻辑层）：负责的是对数据的处理。如果没有数据处理任务的话，此层只做单纯的数据传递作用，而后又到了DAO层。

DAO层（数据库操作层）：负责对数据向数据库增删改查的操作。

在该注册的框架中，如果不使用Spring的话，每个层之间的数据传递都需要new一个调用该层数据的类的实例。而使用了Spring的话，需要做的就是把DAO层和BIZ层的
每个类都写一个接口类，接口类里写实现类的方法，在调用的时候不new对象，直接用对象点(.)方法就可以，别忘了对每个对象加上set/get方法。

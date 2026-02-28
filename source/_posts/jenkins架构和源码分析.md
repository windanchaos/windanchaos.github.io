---
title: jenkins架构和源码分析
date: 2020-03-09 17:00:42
category:
  - 持续集成

---



本文是结合写于2015年的博客[jenkins源码分析](https://blog.csdn.net/sogouauto/article/details/46507267
)获取脉络，结合自己的研究完成，较原文有所拓展和深入。

## jenkins框架
![architecture_jenkins](https://windanchaos.github.io/images/architecture_jenkins.png)



## jenkins的Model对象

jenkin(实际是传承Hudson的)Model对象jenkin平台的基石，它们hold住了某一个（job、project、executor、user、buildable item、test result）的数据和状态。


每个Model对象可以和多个views绑定，view使用了Jelly来渲染HTML和对象。

Model的可执行性是通过绑定Actions对象到Model。

Model如是描述对象存在时，是通过绑定Descriptor对象到Model。

每个Model对象和一个URL对象绑定。
Stapler通过类似JSF表达式的方式来解决URL和Model Object的绑定问题。Stapler同时处理一个model和URL，然后根据object计算URL，一直重复这个动作，直到命中某个静态资源、可执行方法、视图（jsp、jelly、groovy等）。

命中可执行方法举例：
```
Scenario: browser sends "POST /project/jaxb/testResult HTTP/1.1"

evaluate(<root object>, "/project/jaxb/testResult")
-> evaluate(<root object>.getProject("jaxb"), "/testResult")
-> evaluate(<jaxb project object>, "/testResult")
-> evaluate(<jaxb project object>.getTestResult())
```
命中视图举例：
```
org.jvnet.hudson.project.testResul -> /org/jvnet/hudson/project/testResult/index.jelly

命中之后，response.forward(this,"/org/jvnet/hudson/project/testResult/index.jelly",request)
```
## jenkins用了stapler
<!-- more -->

stapler放在model后是因为两者关系密切；

官网自然是一手信息，自己看比我倒了一次的还是要准确很多：

http://stapler.kohsuke.org/what-is.html

java后台类的web系统，前端请求的url是jsp，路径需要和后台具体执行的类建立一个映射关系，想一想jsp到servlet，想一想spring里的@RequestMapping，简单说stapler也是这么一个框架。利用反射原理，通过将url设计成层级的树结构，解决和具体应用之间的映射关系。
官网图：
![image](http://stapler.kohsuke.org/stapler.png)

那用stapler自然是它解决了一定的痛点，据官网介绍，它解决了jsp在映射时层级只是在servlet顶层而导致的用起来不够自由。用一个邮箱管理的例子，下面三个url顾名思义。

```
/servlets/SummarizeList?listName=announce
/servlets/SearchList?listName=announce
/servlets/MailingListEdit?list=announce
```

传统servlet/JSP会阻碍你在java代码中安装树的层级结构来生成类结构，你不得不带上包含请求参数的一整段的url来做映射。在应用规模和逻辑逐渐复杂起来的化，维护工作暴增。因为它的url和对象的映射是一坨……专业的说，url内部层级和类的层次没有映射关系，是url整体对一个类或方法。

stapler就解决这个痛点。当jsp被执行，可以通过it获取它的目标对象，或者当执行方法的url被调用，它直接会在目标对象上调用对应方法，而省去很多枯燥的代码工作。如果没有明白细看上图。

对于我目前不求甚解的解读态度来说，具体怎么用还是深了点，如需推荐自己看官网，知道即可，真的需要再找出来特别深入：

http://stapler.kohsuke.org/getting-started.html

## jenkins的Services

Services是jenkins中Model 对象的可执行状态。

executor 负责执行services。



## execution执行引擎
### 执行架构
master/slave的执行架构这个网上说的就比较多了。这里就不废话太多。直接引图：
![image](https://img-blog.csdnimg.cn/2019021411330350.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIwNjAwMzM=,size_16,color_FFFFFF,t_70)

主要组成部分：
- master
- slave 计算机，提供执行环境
- executor 实际执行的线程
- label 标识slave的具备什么capabilities
### 构建模块
- Execution Service 实际在master或slave上执行的对象
- Queueing 队列，job的调度逻辑
- Job Type 定义job的类型和执行类型
- Load Balance 负责调度job到正确的组件
- Project 定义构建项目![execution_jenkins](https://windanchaos.github.io/images/execution_jenkins.png)

### job提交
触发job的方式：
- 用户动作
- Trigger触发器
- 上游job触发
- REST API 调用

job是被放到job queue中，由load balance确定在哪里执行，接执行引擎从队列中取出job，开始构建动作。
### 调度逻辑
job的各类状态是通过队列来维护的，维护动作发生在：
- 当新的job被确定
- 当executo完成执行，可以接受新的job
job被提交后，在执行引擎取出队列前，还会经过以步骤，就是调度逻辑了（类似于进程的若干状态）。

- 等待列表，还未构建，等待队列唤醒
- 受阻队列，可以被构建但由于某种原因被阻碍
- 可被构建队列，随时准备被构建，就等着excutor过来了
- 受阻队列 获取了excutor资源，但是由于某种原因pending了
- 执行态job 
### excutor的执行逻辑
- excutor是在系统启动后就启动了。

- 类似线程池的管理机制，会自我检测excutor数量，增加和删除。

- 执行队列维护

- 可以被动获取可执行态的job，并执行；

- 可进入sleep状态并等待唤醒的信号；

  ![excution_All_jenkins](https://windanchaos.github.io/images/excution_All_jenkins.png)

### 构建步骤
看图不说话

![Selection_006](https://windanchaos.github.io/images/Selection_006.png)


## jelly
jelly干一件事，把xml转换成可执行的代码。这让我想起我之前用过另一个工具类，把string转成可执行代码，叫commons-jexl3。他们都是apache开源项目。

http://commons.apache.org/proper/commons-jelly/

apache官网发出警告，“Warning: low development activity
”

所以就不纠结了，按照搜狗那篇文章写的，jenkins用它处理界面（含插件的界面）。

## Xstream
http://x-stream.github.io/index.html

干一件事，XML和对象的序列化类和反序列化。这个类库我在hudson的代码库库里看到了。

Xstrea通常可以被用来：
- 数据传输
- 持久化
- 配置
- 单元测试

jenkins用来做持久化。

从最新的发布版本是2018年10月份。

## Remoting Architecture
这个框架解决了master和slave之间的调度和通信问题。

Hudson和jenkins的关系比较复杂，jenkins是从Hudson分离出来的新项，因而架构源Hudson。

这里要说下Hudson Remoting Architecture的基石是java的JNLP。

[oracle官方查看JNLP](https://docs.oracle.com/javase/tutorial/deployment/deploymentInDepth/jnlp.html)

[百科查看JNLP](https://baike.baidu.com/item/JNLP)

基本套路，是master-slave建立TCP链接后，通Channel通信，这个过程中有对象的序列化和反序列化。个人对这块挺有兴趣，如果有时间，我可能去研究一下具体是实现。本文细节就不纠结了。

推荐这篇博客：

https://blog.csdn.net/qq_33873431/article/details/80348675

## Plugin Architecture
插件化是jenkins高扩展特性的最终实现者，大部分功能特性都由插件承担，个人觉得正是jenkins生态内众多，目前2000多的插件，才让jenkins如此火，因为你总能在插件中寻得满足你的那一个，如果没有，你可以自造。

插件机制的三大基本组件：
- Plugin Manager
- Update Center and Update Site
- Plugin Wrapper（包装） & Plugin Strategy（策略）

插件的定义：本质是扩展名被修改成了.hpi的可执行jar包，jar包中有ja资源配置文件Manifest。而这个ja包的入口是继承了一个叫做“Plugin”的类。为了适应stapler框架的URL树机制，插件名定义等于文件名。

 如果URL是：<Hudson-server-root>/plugin/plugin-name

 插件名即：plugin-name.hpi

安全机制，每个plugin都由自己的类加载器。

那下面无意查到的Hudson的文档，择兴简读。

https://javadoc.jenkins-ci.org
## 试着写下jenkins的加载过程（不可信）
底层用的是servlet一套，所以它的生命周期是遵守servlet的生命周期的。
- Web App Context初始化
- 单例化的初始化jenkins模型对象
- 初始化若干jenkins的服务。
- 不同类别task被Task Builder加载。
- Reactor（响应器）初始化；
- 线程池执行响应器Reactor

找到了war启动入口：
```
  <listener>
    <!-- Must be before WebAppMain in order to initialize the context before the first use of this class. -->
    <listener-class>jenkins.util.SystemProperties$Listener</listener-class>
  </listener>
  <listener>
    <listener-class>hudson.WebAppMain</listener-class>
  </listener>
  <listener>
    <listener-class>jenkins.JenkinsHttpSessionListener</listener-class>
  </listener>
```
找到jenkins初始化的类入口：
https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/jenkins/model/Jenkins.java

860行左右开始。。。。复杂了，暂时这样。


## jenkins官方还没有怎么写的框架介绍
官方把开发相关的框架搭出来了，看了下很多都等待更新。

涵盖了jenkins所有架构、初始化、扩展、模型、请求处理、安全、持久化、调度、界面、Forms、国际和本地化、分布式、jenkin的控制台、测试、插件开发、Blue Ocean、构建和debug、开发环境，如此强大的文档，我们就耐心等待和期待更新了。

https://jenkins.io/doc/developer/architecture/
## jenkins江湖

https://blog.csdn.net/hello_worldee/article/details/76485594

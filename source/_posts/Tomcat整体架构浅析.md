---
title: Tomcat整体架构浅析
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 后端框架和技术

date: 2018-09-18 10:31:20
---
转自：[https://blog.csdn.net/cx520forever/article/details/52743166](https://blog.csdn.net/cx520forever/article/details/52743166)
tomcat详解搭配着看：[https://www.cnblogs.com/kismetv/p/7228274.html](https://www.cnblogs.com/kismetv/p/7228274.html)

comment：本文基于Tomcat7.0.68

# 1.整体结构

架构图：
![这里写图片描述](/images/.net-uploads-201206-05-1338887929_7279.JPG.png)

## 1.1各组件解释：

从顶层开始：

一般情况下我们并不需要配置多个Service,conf/server.xml默认配置了一个“Catalina”的

```js 
<Service>
```
。
**Tomcat将Engine，Host，Context，Wrapper统一抽象成Container。**
Connector接受到请求后，会将请求交给Container，Container处理完了之后将结果返回给Connector
下面看Container的结构：
![这里写图片描述](/images/nblogs.com-blog-665375-201601-665375-20160119184849437-2014392220-.png)

![这里写图片描述](/images/-upload-picture-pic-124649-3f5d0ac0-1c40-3c78-9bed-e990f41e3b84.jpg.png)
Standard/*XXXX/*是组件接口的默认实现类。

Tomcat 还有其它组件，如安全组件 security、logger、session、naming 等其它组件。这些组件共同为 Connector 和 Container 提供必要的服务。

## 1.2组件的生命线Lifecycle

Tomcat中很多组件具有生命周期,如初始化、启动、关闭，这些组件的生命周期具有共性，因此Tomcat中将其抽象为接口Lifecycle，来控制组件的生命周期，它通过 **事件机制** 实现各个容器间的内部通讯。
Lifecycle接口的方法：
![这里写图片描述](/images/dn.net-20161006125439657.png)
继承关系图：
![这里写图片描述](/images/dn.net-20161006124601442.png)
StandardServer，StandardService，Connector和上面4个容器等很多组件都实现了Lifecycle，组件实现这个接口就可以统一被拥有它的组件控制了，这样一层一层的直到一个 **最高级的组件** 就可以控制 Tomcat 中所有组件的生命周期，这个最高的组件就是 **
```js 
Server
```
**。

# 2.启动流程

在bin目录下执行了./startup.sh 或者执行 ./catalina.bat start命令时,实际调用了Bootstrap启动类的main方法，并传递了start参数。
Bootstrap/#main方法的启动流程：
参考[http://blog.csdn.net/Zerohuan/article/details/50752635/#t6](http://blog.csdn.net/Zerohuan/article/details/50752635#t6)
附上别人总结的一张启动时序图：
![这里写图片描述](/images/dn.net-20150327153152547-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvYzkyOTgzMzYyM2x2Y2hh-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-Center.png)
补充如下：

* 关于Connector初始化和启动的更多细节，可参考本人另一篇blog [http://blog.csdn.net/cx520forever/article/details/52198050](http://blog.csdn.net/cx520forever/article/details/52198050)

# 3.pipeline valve机制

## 3.1名词解释

## 3.2总体分析

四个基本容器对象里面都有一个pipeline及valve模块，是容器类必须具有的模块，对象生成时set该属性。Pipeline就像是每个容器的逻辑总线。在pipeline上按照配置的顺序，加载各个valve。通过pipeline完成各个valve之间的调用，各个valve实现具体的应用逻辑。
tomcat组件图：
![tomcat组件图](/images/dn.net-20161006212818345.png)
从上图中看到，在Connector接收到一次连接并转化成HttpServletRequest请求对象后，**请求传递如下**：
Connector–>Engine的Pipeline的ValveA中–>Engine Valve–>Host Pipeline的Error Report Valve和Host Value–>Context Valve–>Wrapper Valve中，在这里会经过一个过滤器链（Filter Chain）–>Servlet中。
Servlet处理完成后一步步返回，最后Connector拿到response。

## 3.3接口及默认实现

接口中定义的方法:
![接口中定义的方法](/images/dn.net-20161007001421097.png)
一个pipeline包含多个Valve，这些阀共分为两类，一类叫基础阀（通过getBasic、setBasic方法调用），一类是普通阀（通过addValve、removeValve调用）。管道都是包含在容器中，所以有getContainer和setContainer方法。一个管道一般有一个基础阀（通过setBasic添加），可以有0到多个普通阀（通过addValve添加）。
isAsyncSupported：当管道中的所有阀门都支持异步时返回ture，否则返回false
该接口的标准实现是：**
```js 
org.apache.catalina.core.StandardPipeline
```
**
Engine、Host、Context及Wrapper的pipeline属性都继承自父类ContainerBase。

接口方法:
![这里写图片描述](/images/dn.net-20161007002724932.png)
重点关注setNext、getNext、invoke这三个方法，通过setNext设置该阀的下一阀，通过getNext返回该阀的下一个阀的引用，invoke方法则执行该阀内部自定义的请求处理代码。
ValveBase：是Valve接口的基本实现
四大容器类r都有各自缺省的标准valve实现。它们分别是

![这里写图片描述](/images/dn.net-20161007003208809.png)

Valve实现了具体业务逻辑单元。可以定制化valve（实现特定接口），然后配置在server.xml里。每层容器都可以配置相应的valve，当只在其作用域内有效。例如engine容器里的valve只对其包含的所有host里的应用有效。
配置举例：
```js 
<Engine name="Catalina" defaultHost="localhost">  
  <Valve className="MyValve0"/>  
  <Valve className="MyValve1"/>  
  <Valve className="MyValve2"/>  
   ……  
  <Host name="localhost"  appBase="webapps">  
  </Host>  
</Engine>
```

当在server.xml文件中配置了一个定制化valve时，会调用pipeline对象的addValve方法，将valve以链表方式组织起来，代码如下;

```js 
@Override
    public void addValve(Valve valve) {

        // Validate that we can add this Valve
        if (valve instanceof Contained)
            ((Contained) valve).setContainer(this.container);

        // Start the new component if necessary
        if (getState().isAvailable()) {
            if (valve instanceof Lifecycle) {
                try {
                    ((Lifecycle) valve).start();
                } catch (LifecycleException e) {
                    log.error("StandardPipeline.addValve: start: ", e);
                }
            }
        }

        // Add this Valve to the set associated with this Pipeline
        //将配置的valve添加到链表中，并且每个容器的标准valve在链表的尾端 
        if (first == null) {
            first = valve;
            valve.setNext(basic);
        } else {
            Valve current = first;
            while (current != null) {
                if (current.getNext() == basic) {
                    current.setNext(valve);
                    valve.setNext(basic);
                    break;
                }
                current = current.getNext();
            }
        }

        container.fireContainerEvent(Container.ADD_VALVE_EVENT, valve);
    }
```

valve按照容器作用域的配置顺序来组织valve，每个valve都设置了指向下一个valve的next引用。同时，每个容器缺省的标准valve都存在于valve链表尾端，最后被调用。
Pipeline内部维护first和basic两个阀，其它相关阀通过getNext来获取。

**标准valve的调用逻辑图：**
![这里写图片描述](/images/dn.net-20161007004829253.png)
从StandardEngineValve开始， **所有的基础阀的实现最后都会调用其下一级容器，所有的普通阀都会执行

```js 
getNext().invoke(request, response);
```
**，一直到StandardWrapperValve，完成请求处理过程。因为Wrapper是对一个Servlet的包装，所以它的基础阀内部调用的过滤器链的doFilter方法和Servlet的service方法。
上述机制保证了请求传递到servlet去处理。

当采用tomcat默认初始配置时，Valve链如下：
![这里写图片描述](/images/dn.net-20161007005430411.png)
这些阀门Valve通过invoke方法彼此串联起来，最终构成的执行顺序十分类似于一个管道。

# 4.Tomcat中的设计模式

## 4.1模板方法模式

**把通用的骨架步骤抽象到父类中，子类去实现特定的某些步骤。**
举例：
如LifecycleBase类中init和start方法，其中的nitInternal和startInternal方法是抽象方法，所有容易都直接或间接继承了LifecycleBase，在初始化和启动时被每个容器会调用其init和start方法，这些抽象方法都是在子类中实现的。

## 4.2责任链模式

## 4.3观察者模式

Tomcat通过LifecycleListener对组件生命周期组件Lifecycle进行监听，各个组件在其生命期中会有各种行为，而这些行为都会触发相应的事件，Tomcat就是通过侦听这些事件达到对这些行为进行扩展的目的。在看组件的init和start过程中会看到大量如：

```js 
fireLifecycleEvent(CONFIGURE_START_EVENT, null);
```
这样的代码，这就是对某一类型事件的触发，如果你想在其中加入自己的行为，就只用注册相应类型的事件即可。
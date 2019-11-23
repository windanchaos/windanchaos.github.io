---
title: ［JavaWeb基础］jsp
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Java编程语言

date: 2017-10-20 00:16:01
---
以下内容整理编辑参考：
[http://www.runoob.com](http://www.runoob.com)

# 什么是jsp

JSP全称Java Server Pages，是一种动态网页开发技术。它使用JSP标签在HTML网页中插入Java代码。而识别它的方式，是以<%开头以%>结束的标签。

JSP通过网页表单获取用户输入数据、访问数据库及其他数据源，动态地创建网页。

JSP标签有多种功能，比如访问数据库、记录用户选择信息、访问JavaBeans组件等，还可以在不同的网页中传递控制信息和共享信息。

# jsp的处理流程和生命周期

![处理流程](/images/om-wp-content-uploads-2014-01-jsp-processing.jpg.png)

就像其他普通的网页一样，您的浏览器发送一个 HTTP 请求给服务器。
Web 服务器识别出这是一个对 JSP 网页的请求，并且将该请求传递给 JSP 引擎。通过使用 URL或者 .jsp 文件来完成。
JSP 引擎从磁盘中载入 JSP 文件，然后将它们转化为 Servlet。这种转化只是简单地将所有模板文本改用 println() 语句，并且将所有的 JSP 元素转化成 Java 代码。
JSP 引擎将 Servlet 编译成可执行类，并且将原始请求传递给 Servlet 引擎。
Web 服务器的某组件将会调用 Servlet 引擎，然后载入并执行 Servlet 类。在执行过程中，Servlet 产生 HTML 格式的输出并将其内嵌于 HTTP response 中上交给 Web 服务器。
Web 服务器以静态 HTML 网页的形式将 HTTP response 返回到您的浏览器中。
最终，Web 浏览器处理 HTTP response 中动态产生的HTML网页，就好像在处理静态网页一样。

![生命周期](/images/om-wp-content-uploads-2014-01-jsp_life_cycle.jpg.png)
```js 
编译阶段：

servlet容器编译servlet源文件，生成servlet类
初始化阶段：

加载与JSP对应的servlet类，创建其实例，并调用它的初始化方法
执行阶段：

调用与JSP对应的servlet实例的服务方法
销毁阶段：

调用与JSP对应的servlet实例的销毁方法，然后销毁servlet实例
```

# JSP作用和Servlet分工

```js 
* Servlet：
> 缺点：不适合设置html响应体，需要大量的response.getWriter().print("<html>")
> 优点：动态资源，可以编程。
* html：
> 缺点：html是静态页面，不能包含动态信息
> 优点：不用为输出html标签而发愁
* jsp(java server pages)：
> 优点：在原有html的基础上添加java脚本，构成jsp页面。

* JSP：
> 作为请求发起页面，例如显示表单、超链接。
> 作为请求结束页面，例如显示数据。
* Servlet：
> 作为请求中处理数据的环节。
```

![这里写图片描述](/images/dn.net-20160817155819901-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQv-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-Center.png)
参考：[http://blog.csdn.net/qq_25827845/article/details/52231724](http://blog.csdn.net/qq_25827845/article/details/52231724)

# JSP 语法

## 脚本程序

脚本程序可以包含任意量的Java语句、变量、方法或表达式，只要它们在脚本语言中是有效的。

脚本程序的语法格式：
```js 
<% 代码片段 %>
```

## JSP声明

一个声明语句可以声明一个或多个变量、方法，供后面的Java代码使用。在JSP文件中，您必须先声明这些变量和方法然后才能使用它们。

JSP声明的语法格式：
```js 
<%! declaration; [ declaration; ]+ ... %>
```

## JSP表达式

一个JSP表达式中包含的脚本语言表达式，先被转化成String，然后插入到表达式出现的地方。

由于表达式的值会被转化成String，所以您可以在一个文本行中使用表达式而不用去管它是否是HTML标签。

表达式元素中可以包含任何符合Java语言规范的表达式，但是不能使用分号来结束表达式。

JSP表达式的语法格式：
```js 
<%= 表达式 %>
```

## JSP注释

```js 
<%-- 该部分注释在网页中不会被显示--%>
```
 **语法** 描述 <%– 注释 –%> JSP注释，注释内容不会被发送至浏览器甚至不会被编译 <!– 注释 –> HTML注释，通过浏览器查看网页源代码时可以看见注释内容 <\% 代表静态 <%常量 %\> 代表静态 %> 常量 \’ 在属性中使用的单引号 \” 在属性中使用的双引号

## JSP指令

JSP指令用来设置与整个JSP页面相关的属性。

JSP指令语法格式：
```js 
<%@ directive attribute="value" %>
```
 **指令** **描述** <%@ page … %> 定义页面的依赖属性，比如脚本语言、error页面、缓存需求等等 <%@ include … %> 包含其他文件 <%@ taglib … %> 引入标签库的定义，可以是自定义标签

## JSP行为

JSP行为标签使用XML语法结构来控制servlet引擎。它能够动态插入一个文件，重用JavaBean组件，引导用户去另一个页面，为Java插件产生相关的HTML等等。

行为标签只有一种语法格式，它严格遵守XML标准：
```js 
<jsp:action_name attribute="value" />
```

行为标签基本上是一些预先就定义好的函数，下表罗列出了一些可用的JSP行为标签：

**语法** **描述** jsp:include 用于在当前页面中包含静态或动态资源 jsp:useBean 寻找和初始化一个JavaBean组件 jsp:setProperty 设置 JavaBean组件的值 jsp:getProperty 将 JavaBean组件的值插入到 output中 jsp:forward 从一个JSP文件向另一个文件传递一个包含用户请求的request对象 jsp:plugin 用于在生成的HTML页面中包含Applet和JavaBean对象 jsp:element 动态创建一个XML元素 jsp:attribute 定义动态创建的XML元素的属性 jsp:body 定义动态创建的XML元素的主体 jsp:text 用于封装模板数据

## JSP内置对象

**对象** **描述** request **HttpServletRequest**类的实例 response **HttpServletResponse**类的实例 out **PrintWriter**类的实例，用于把结果输出至网页上 session **HttpSession**类的实例 application **ServletContext**类的实例，与应用上下文有关 config **ServletConfig**类的实例 pageContext **PageContext**类的实例，提供对JSP页面所有对象以及命名空间的访问 page 类似于Java类中的this关键字 Exception **Exception**类的对象，代表发生错误的JSP页面中对应的异常对象

# JSP 标准标签库（JSTL）

JSP标准标签库（JSTL）是一个JSP标签集合，它封装了JSP应用的通用核心功能。

JSTL支持通用的、结构化的任务，比如迭代，条件判断，XML文档操作，国际化标签，SQL标签。 除了这些，它还提供了一个框架来使用集成JSTL的自定义标签。

核心标签是最常用的JSTL标签。引用核心标签库的语法如下：
```js 
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
```
 标签 描述 用于在JSP中显示数据，就像<%= … > 用于保存数据 用于删除数据 用来处理产生错误的异常状况，并且将错误信息储存起来 与我们在一般程序中用的if一样 本身只当做<c:when>和<c:otherwise>的父标签 <c:choose>的子标签，用来判断条件是否成立 <c:choose>的子标签，接在<c:when>标签后，当<c:when>标签判断为false时被执行 检索一个绝对或相对 URL，然后将其内容暴露给页面 基础迭代标签，接受多种集合类型 根据指定的分隔符来分隔内容并迭代输出 用来给包含或重定向的页面传递参数 重定向至一个新的URL. 使用可选的查询参数来创造一个URL

其他若干标签，参考[http://www.runoob.com/jsp/jsp-jstl.html](http://www.runoob.com/jsp/jsp-jstl.html)
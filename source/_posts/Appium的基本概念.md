---
title: Appium的基本概念
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-05-19 00:10:11
---
# 一、appium是什么？

Appium 是一个自动化测试开源、跨平台工具。它允许测试人员在不同的平台（iOS，Android）使用同一套API来写自动化测试脚本，这样大大增加了 iOS 和 Android 测试套件间代码的复用性。支持 iOS 平台和 Android 平台上的原生应用，web 应用和混合应用。
所谓的“移动原生应用”是指那些用 iOS 或者 Android SDK 写的应用。
所谓的“移动 web 应用”是指使用移动浏览器访问的应用（Appium 支持 iOS 上的 Safari 和 Android 上的 Chrome）。
所谓的“混合应用”是指原生代码封装网页视图——原生代码和 web 内容交互。比如，像 Phonegap，可以帮助开发者使用网页技术开发应用，然后用原生代码封装，这些就是混合应用。

# 二、Appium的基本原理

## 基础依赖

Appium 真正的工作引擎是第三方自动化框架。使用以下的第三方框架：
**- iOS: 苹果的 UIAutomation**
**- Android 4.2+: Google’s UiAutomator**
- Android 2.3+: Google’s Instrumentation. (Instrumentation由单独的项目Selendroid提供支持 )
- Selenium WebDriver等第三方包，[点此参考java依赖包](https://search.maven.org/remotecontent?filepath=io/appium/java-client/5.0.0-BETA8/java-client-5.0.0-BETA8.pom)

## C/S 架构

Appium使用客户端-服务端的架构，它 的核心是一个 web 服务器，它提供了一套 REST 的接口， 指定了客户端到服务端的协议。 (JSON Wire Protocol)。
我们可以使用任何语言来编写客户端，向服务端发送恰当的 HTTP 请求。它收到客户端的连接，监听到命令，接着在移动设备上执行这些命令，然后将执行结果放在 HTTP响应中返还给客户端。事实上，这种客户端/服务端的架构给予了许多的可能性：比如我们可以使用任何实现了该客户端的语言来写我们的测试代码。比如我们可以把服务端放在不同 的机器上。比如我们可以只写测试代码，然后使用像 Sauce Labs 这样的云服务来解释命令。

## Session

自动化始终围绕一个session进行，客户端初始化一个seesion（会话）来与服务端交互，不同的语言有不同的实现方式，但是他们最终都是发送为一个POST请求给服务端，请求中包含一个JSON对象，被称作“desired capabilities”。此时，服务端就会开启一个自动化的 session，然后返回一个 session ID，session ID将会被用户发送后续的命令。

## Desired Capabilities

Desired capabilities 是一些键值对的集合 (比如，一个 map 或者 hash），客户端将这些键值对发给服务端，告诉服务端我们想要怎么测试。比如，我们可以把platformName capability 设置为 iOS，告诉 Appium 服务端，我们想要一个iOS 的 session，而不是一个 Android 的。我们也可以设置 safariAllowPopups capability 为 true，确保在 Safari 自动化 session 中，我们可以使用 javascript 来打开新窗口。参见 capabilities 文档，查看完整的 capabilities 列表。

## Appium Server

Appium server 是用 Node.js 写的。我们可以用源码编译或者从 NPM 直接安装。

## Appium客户端

Appium 客户端端有很多语言库 Java, Ruby, Python, PHP, JavaScript 和 C/#，这些库都实现了 Appium 对 WebDriver 协议的扩展。当使用 Appium 的时候，你只需使用这些库代替常规的 WebDriver 库就可以了。 你可以从[这里](http://appium.io/slate/cn/master/#appium-clients.cn.md)看到所有的库的列表。
<!-- more -->

# Appium的组成和安装

如上所述构成Appium主要有三个部分：
- Appium Server
- Appium Clients
- Appium-Desktop

## Appium Server

先解决若干环境依赖（安装nodejs和npm）后执行：
```js 
npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm install -g appium
```

## Appium Clients

我研究的是java如何使用，最直接的方法是：
[下载jar包](https://search.maven.org/remotecontent?filepath=io/appium/java-client/5.0.0-BETA8/java-client-5.0.0-BETA8.jar)，当然它还依赖若干的包，所以要一并的下载。其他语言的原理也是类似。
所以，使用maven来引用包吧。pom.xml
```js 
<dependency>
            <groupId>org.testng</groupId>
            <artifactId>testng</artifactId>
            <version>6.11</version>
        </dependency>
        <dependency>
            <groupId>org.seleniumhq.selenium</groupId>
            <artifactId>selenium-java</artifactId>
            <version>3.4.0</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.8.0</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.httpcomponents</groupId>
            <artifactId>httpclient</artifactId>
            <version>4.5.3</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>cglib</groupId>
            <artifactId>cglib</artifactId>
            <version>3.2.5</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>commons-validator</groupId>
            <artifactId>commons-validator</artifactId>
            <version>1.6</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-lang3</artifactId>
            <version>3.5</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.5</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>4.3.8.RELEASE</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <version>1.8.10</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.openpnp</groupId>
            <artifactId>opencv</artifactId>
            <version>3.2.0-1</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.hamcrest</groupId>
            <artifactId>hamcrest-all</artifactId>
            <version>1.3</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>io.appium</groupId>
            <artifactId>java-client</artifactId>
            <version>5.0.0-BETA8</version>
        </dependency>
```

## Appium-Desktop

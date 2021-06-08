---
title: jenkins后台执行shell命令
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 测试的框架和技术

date: 2017-09-09 18:28:56
---
参考官网：
[https://wiki.jenkins.io/display/JENKINS/ProcessTreeKiller](https://wiki.jenkins.io/display/JENKINS/ProcessTreeKiller)

原理：启动的时候给命令，让jenkins不终结自己的进程衍生的进程。
```js 
java -Dhudson.util.ProcessTree.disable=true -jar jenkins.war
```

还有一种办法直接在**shell（要后台执行命令前）**加入：

```js 
BUILD_ID=dontKillMe
```

举例：

```js 
BUILD_ID=dontKillMe nohup java -Xms246m -Xmx500m -jar ?????.jar > log.log &
```

下面是jenkins执行前和后的日志对比

执行前：
```js 
+ echo ???? deploy finished'
???? deploy finished
+ nohup java -Xms246m -Xmx500m -jar ????.jar
```

执行后

```js 
+ echo ???? deploy finished'
???? deploy finished
+ BUILD_ID=dontKillMe
+ nohup java -Xms246m -Xmx500m -jar ????.jar
```
<!-- more -->

然后进程就可以在服务器上看到了。

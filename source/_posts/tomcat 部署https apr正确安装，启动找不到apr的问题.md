---
title: tomcat 部署https apr正确安装，启动找不到apr的问题
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2018-02-02 11:30:13
---
问题解决可以参考：[http://blog.csdn.net/felix_yujing/article/details/52385890](http://blog.csdn.net/felix_yujing/article/details/52385890)
也可以参考官网：[http://tomcat.apache.org/native-doc/](http://tomcat.apache.org/native-doc/)

但是，我这个启动始终不对。一开始以为是安装有问题，尝试了几次，安装明显没有什么差错。
仔细看日志会发现，tomcat在启动过程中会去/usr/lib64等目录下去找apr，但是找不到。虽然source /etc/profile，但是明显报错的tomcat并没有去你设置的目录下面去找它所需要的库文件，明显这个source并未生效。

原理猜测：
以上操作，是root和普通用户在切换操作发生的。
/etc/profile在系统账户管理的原理上来说，需要用户登录才会生效。
su命令切换不是等于登录（这个是猜测，没有查看到权威说法，亲测猜测是对的）。所以tomcat启动的时候就不会去/usr/local/apr/lib目录下去找.so文件([动态链接库](https://www.cnblogs.com/wangnengwu/p/7760606.html))。

解决办法：
1、装完apr，主动退出ssh连接，重新用普通账户连接。
或者在普通账户下执行：
```js 
source /etc/profile
```

2、把需要的文件拷贝到需要的目录，执行

```js 
cp /usr/local/apr/lib/libtcnative-1.* /usr/lib64/
```

我这个，几乎是全网回答最直接的了。毕竟是我亲测！
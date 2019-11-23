---
title: Systemd 添加tomcat服务，开机启动，支持apr
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 持续集成

date: 2019-08-27 16:29:53
---
问题描述：
我们的tomcat启动了apr启动https端口，我设置了systemd的tomcat.service的文件，使用systemctl start tomcat，始终无法识别apr的环境变量。研究了一会后解决。
先贴tomcat.service最终设置，只需加一行配置即可。
```js 
[Unit]
Description=java tomcat project
After=syslog.target network.target

[Service]
Type=forking
User=user
Group=user
EnvironmentFile=/opt/apache-tomcat/bin/config
ExecStart=/opt/apache-tomcat/bin/startup.sh
ExecReload=
ExecStop=/arthas/servers/apache-tomcat-8.5.4-80/bin/shutdown.sh
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

**关键点：**

EnvironmentFile=/opt/apache-tomcat/bin/config 的设置。
文件内容如下，是启动tomcat的环境变量：
```js 
LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH
```

原理：
1、/etc/profile或者/etc/security/limit.d这些文件中配置的环境变量仅对通过pam登录的用户生效，而systemd是不读这些配置的，所以这就造成登录到终端时查看环境变量和手动启动应用都一切正常，但是systemd无法正常启动应用。
2、EnvironmentFile：该字段指定软件自己的环境参数。

参考：
https://blog.csdn.net/lizao2/article/details/81030380
https://www.cnblogs.com/jhxxb/p/10654554.html
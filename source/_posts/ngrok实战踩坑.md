---
title: ngrok实战踩坑
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2018-01-19 14:50:55
---
使用ngrok的场景：内网服务发布到外网，服务的内网穿透。
具体如何操作的网上很多文章，这里就不赘述。
可以参考：
[一分钟实现内网穿透（ngrok服务器搭建）](http://blog.csdn.net/zhangguo5/article/details/77848658?utm_source=5ibc.net&utm_medium=referral%E2%80%8B)
[自搭Ngrok实现树莓派内网穿透
](https://www.jianshu.com/p/91f01e30a9b0)

# 整个流程

# 有坑的地方

## 编译安装的文件是哪些

首先找到安装的目录，我的是/usr/local/src/ngrok/
那么编译完的可执行文件就在/usr/local/src/ngrok/bin

证书在：
/usr/local/src/ngrok/assets/server/tls
/usr/local/src/ngrok/assets/client/tls
可执行文件+证书，拷贝到一起，就是一套完成的客户端和服务端了。

## 后台运行

ngrok 用 & 不能后台运行
这就要使用screen这个命令
首先安装screen
apt-get install screen
之后运行
screen -S 任意名字（例如：keepngork）
然后运行ngrok启动命令
最后按快捷键
ctrl+A+D
既可以保持ngrok后台运行
[http://wdxtub.com/2016/04/16/thin-csapp-1/](http://wdxtub.com/2016/04/16/thin-csapp-1/)

## ngrok客户端无法注册到服务端

<!-- more -->
服务端可以查看到客户端的链接日志，但是auth提示有问题，是因为在编译的时候带了认证则客户端机器，客户端执行文件同级目录，把生成的几个认证文件拷贝过去即可。

## 域名关系处理

ngrok的服务端，启动带的域名如果为
```js 
SCREEN -S keepngrok
./ngrokd -domain=domain.com.cn
```

域名映射到外网固定IP的配置就为：

@.domain.com.cn

就是说只要没有特别说明，所有可能的domain.com.cn都访问这台服务器。

那么，客户端的访问地址就：abc.domain.com.c
某客户端的配置：
```js 
server_addr: "domain.com.cn:4443"
trust_host_root_certs: false
tunnels:
  http:
    subdomain: "abc"
    proto:
      http: "9003"
```

---
title: git换行符冲突CRLF、LF的解决方案
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2019-08-09 14:51:32
---
git在维护版本库的时候统一使用的是LF，这样就可以保证文件跨平台的时候保持一致。
在Linux下默认的换行符也是LF，那也就不存在什么问题。
在Windows下默认的换行符是CRLF，那么我们需要保证在文件提交到版本库的时候文件的换行符是LF，通常来说有两种方法：
```js 
# 在工作区使用CRLF，使用git commit提交的时候git帮你把所有的CRLF转换为LF。
git config --global core.autocrlf true
# 在工作区使用LF
git config --global core.autocrlf input
# 避免文件中有混用换行符
git config --global core.safecrlf true
```

以上措施如果都不管用，尤其是莫名其妙的，git刚刚clone的代码库就存在图片换行符的问题，比如我的。
![刚clone的代码库就存在换行符导致的问题](/images/20190809144730689.jpg-x-oss-process=image-watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dpbmRhbmNoYW9z,size_16,color_FFFFFF,t_70.png)
那么你可以试试——————————————————————————升级你的git，是的，所有设置方案都试过后，这一招彻底解决。

这里下载：[https://github.com/git/git/releases?after=v2.21.0-rc1](https://github.com/git/git/releases?after=v2.21.0-rc1)
```js 
# centos自带Git，7.x版本自带git 1.8.3.1，安装新版本之前需要使用卸载。
yum remove -y git
# 依赖
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel  gcc perl-ExtUtils-MakeMaker
wget https://github.com/git/git/archive/v2.20.0.tar.gz
tar xzf v2.20.0.tar.gz
cd git-2.22.0
make prefix=/usr/local/git all
make prefix=/usr/local/git install
# 创建软连接
ln -s  /usr/local/git/bin/git /usr/bin/git
git --version
```
---
title: ubuntu 安装pygit2
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 测试的框架和技术

date: 2017-01-11 16:42:44
---
参考：[http://www.pygit2.org/install.html](http://www.pygit2.org/install.html)

依赖包：
Python 2.7, 3.2+ or PyPy 2.6+ (including the development headers)
Libgit2 v0.25.x
cffi 1.0+
six
tox (optional)

安装依赖包：
```js 
sudo apt-get install libssh2-1-dev
sudo apt-get install libgit2-dev
sudo apt-get install python-tox python-cffi python-six
```

安装：

```js 
wget https://github.com/libgit2/libgit2/archive/v0.25.0.tar.gz
tar xzf v0.25.0.tar.gz
cd libgit2-0.25.0/
cmake .
make
sudo make install
```

cmake .的时候会告诉你缺啥啥，缺啥装啥。
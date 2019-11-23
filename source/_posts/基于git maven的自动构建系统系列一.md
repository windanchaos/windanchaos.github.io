---
title: 基于git maven的自动构建系统系列一
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2016-11-03 22:02:41
---
# 前言

受《[分布式自动化版本发布系统](http://wenku.baidu.com/link?url=yfoL8R4aoZb5b56nqYOjW7sEvYxExTaLyRovWFcD3slJoym1P7qKpdcuzelEU52J4jpp_eGWa5rtMGwJhkkrQ5YA8ilmM16GoTBP8F-48NC)》启发，决定对我们公司现有的shell脚本发版进行升级。业余时间研究，主要达到以下目的：

前二个做完，可以了解python的一些基本语法数据类型，把更新记录写入到数据库便于日常查看。
第三个，续用当前测试环境发布代码的shell脚本。

# python3.5 and mysql5.7

## mysql5.7 install

参考：[官网安装方法](http://dev.mysql.com/downloads/repo/apt/)。
首先：下载[MySQL APT Repository](http://dev.mysql.com/get/mysql-apt-config_0.8.0-1_all.deb)。参考[链接](http://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/)的方法，设置MySQL APT Repository。
```js 
sudo dpkg -i mysql-apt-config_0.8.0-1_all.deb
sudo apt-get update
sudo apt-get install mysql-server
```

*第一个命令需要选择自己将要安装的mysql版本。*
启动mysql
安装mysql workbench。

## Connector/Python install

参考：[官方网站](https://dev.mysql.com/doc/connector-python/en/connector-python-installation.html)

## 基本的python数据库操作

以下操作完成了对git log记录数据库。不足之处在于，没有找到pygit2的方法去追加git 日志，先跳过去了。
大部分代码参考：[pygit2官网document](http://www.pygit2.org/objects.html)

```js 
import time,datetime
import config as config
from pygit2 import Repository
from pygit2 import GIT_SORT_NONE,GIT_SORT_TOPOLOGICAL, GIT_SORT_REVERSE,GIT_SORT_TIME
import mysql.connector

cnx = mysql.connector.connect(**config)
#存储日志的列表[[logA],[logB]...[logN]]
argslog=[]
cursor = cnx.cursor()
repo = Repository('homeOfyourGit/.git')
for commit in repo.walk(repo.head.target,GIT_SORT_TOPOLOGICAL | GIT_SORT_REVERSE):
    #logA..N
    logtmp=[]
    logtmp.append(commit.tree.id.hex)
    logtmp.append(commit.message)
    logtmp.append(datetime.datetime.utcfromtimestamp(commit.author.time))
    logtmp.append(commit.author.name)
    print(logtmp)
    argslog.append(logtmp)

add_log="INSERT INTO gitlog.gitlog (nvalue,comments,date,Author) VALUES (%s,%s,%s,%s)"
cursor.executemany(add_log, argslog)
cursor.close()
cnx.commit()
cnx.close()
```

更新数据涉及到一个增量更新git的log日志问题，pygit2中没有找到类似的api。所以考虑有时间作为新旧数据判断依据。
这里面的难点（对于小白的我来说），是如何比较时间。开始直接比较：
/#下面 datetimelog 是tuple类型的
dataNewtime= datetimelog
/#commit.author.time是long型自然是无法比较的，发现这个是使用了commit.author.time - dataNewtime，编译器提示发现类型不正确。

正确代码：
```js 
import time,datetime

import config as config
from pygit2 import Repository
from pygit2 import GIT_SORT_NONE,GIT_SORT_TOPOLOGICAL, GIT_SORT_REVERSE,GIT_SORT_TIME
import mysql.connector

cnx = mysql.connector.connect(user='root',password='????',host='127.0.0.1',database='gitlog')
argslog=[]
cursor = cnx.cursor()
cursor.execute("SELECT UNIX_TIMESTAMP(date) FROM gitlog.gitlog order by gitlog.date desc limit 1")
for (datetimelog) in cursor:
    #既然是数组，取数组第一个值
    dataNewtime= datetimelog[0]

repo = Repository('/home/chaosbom/git/ArhasMK/.git')

for commit in repo.walk(repo.head.target,GIT_SORT_TOPOLOGICAL | GIT_SORT_REVERSE):
    #时间比数据库里的新则更新进去
    if(commit.author.time > dataNewtime):
        logtmp=[]
        logtmp.append(commit.tree.id.hex)
        logtmp.append(commit.message)
        logtmp.append(datetime.datetime.utcfromtimestamp(commit.author.time))
        logtmp.append(commit.author.name)
        print(logtmp)
        argslog.append(logtmp)
        log=(commit.tree.id.hex,commit.message,datetime.datetime.utcfromtimestamp(commit.author.time).strftime("%Y-%m-%d %H:%M:%S"),commit.author.name)
        add_log="INSERT INTO gitlog.gitlog (nvalue,comments,date,Author) VALUES (%s,%s,%s,%s)"
        cursor.executemany(add_log, argslog)
cursor.close()
cnx.commit()
cnx.close()
```

测试后，新增记录被更新到数据库，当然记录很简单，解决的时候百度了很多次。

# python调用shell

在百度中看了数篇关于python调用shell的入门文章。推荐使用Python subprocess模块。
[Python subprocess模块学习总结](http://www.jb51.net/article/48086.htm)

python调用shell命令易如反掌，现在需要考虑的是如何使python调用的脚本联动起来。

# 题外话

## python在ubuntu下的编译器

本次实验使用了：

## python连接mysql使用config

未解决，使用的时候类型不匹配错误。

## 计划和实际

写这篇文章的时候是希望使用python来自动处理目前公司的发版流程，基于实际考虑，我编写的shell脚本已经足够应付发版工作，再深究下去并不是非常必要，目前发版的不足回头总结再弥补也来得及。那么问题来了，用python去实现的必要性？首先明确一点，我使用python的目的是学习和研究。其次，目前对于web系统的了解程度还不够深入，没有真正的学习过一个web框架。所以还是要做一个发布的系统出来。这个内容留到下一篇文章再继续了。
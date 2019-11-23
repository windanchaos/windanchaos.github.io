---
title: pygit2、mysql.connector更新git的日志数据
author: windanchaos
tags: 
       - FromCSDN

category: 
       - MySQL数据库

date: 2017-01-13 01:23:17
---
由于最近拓展视野，发现了splinter和 Hp Utf 两个东西，很想去学习，基于django的自动发版系统又不能半途而非（实属自我约束，不能太没有恒心）。故而，更新日志的就不用django的web方式了，因为我尝试了很久，python本来就不熟悉，困难那是重重的，直接上python提供的mysql接口更新git的log日志。以下是代码：
```js 
import time,datetime

#import config as config
from pygit2 import Repository
from pygit2 import GIT_SORT_NONE,GIT_SORT_TOPOLOGICAL, GIT_SORT_REVERSE,GIT_SORT_TIME
import mysql.connector

# noinspection PyArgumentList
cnx = mysql.connector.connect(user='root',password='我的密码吧告诉你',host='127.0.0.1',database='gitlog')
argslog=[]
cursor = cnx.cursor()
cursor.execute("SELECT UNIX_TIMESTAMP(commit_date) FROM gitlog.gitlog_commits order by id desc limit 1")

dataNewtime=1357006210
for (datetimelog) in cursor:
    if (datetimelog[0]!=''):
        dataNewtime= datetimelog[0]
idnum=0
for (i) in cursor:
    idnum=i[0]

repo = Repository('/home/chaosbom/git/ArhasMK/.git')

for commit in repo.walk(repo.head.target,GIT_SORT_TOPOLOGICAL | GIT_SORT_REVERSE):

    if(commit.author.time > dataNewtime):
        #print (commit.author.time, dataNewtime, commit.author.time > dataNewtime, commit.author.time - dataNewtime)
        logtmp=[]
        idnum += 1
        logtmp.append(idnum)
        logtmp.append(commit.author.name)
        logtmp.append(commit.message)
        logtmp.append('')
        logtmp.append(commit.tree.id.hex)
        logtmp.append(datetime.datetime.utcfromtimestamp(commit.author.time).strftime("%Y-%m-%d %H:%M:%S"))
        print(logtmp)
        argslog.append(logtmp)
        #log=(commit.author.name,commit.message,commit.tree.id.hex,datetime.datetime.utcfromtimestamp(commit.author.time).strftime("%Y-%m-%d %H:%M:%S"))
##以下两句放在for循环中的时候，会增加海量的数据。是由于argslog的不断变大，递增处理。
##但是如果直接在for循环中传递logtmp给cursor，又包参数不足的错误。此处留个大大的疑问。
add_log="INSERT INTO gitlog.gitlog_commits (id,author,message,commitsFile,nvalue,commit_date) VALUES (%s,%s,%s,%s,%s,%s)"
cursor.executemany(add_log, argslog)
cursor.close()
cnx.commit()
cnx.close()
```

在mysqlworkbench里执行了下统计：

```js 
SELECT count(author) FROM gitlog.gitlog_commits;
```

得到：’4438’条记录
---
title: 基于git maven的自动构建系统系列二
author: windanchaos
tags: 
       - FromCSDN

category: 
       - python编程语言

date: 2016-11-24 23:44:36
---
这篇文章的主要目的是记录使用python来编写公司发版系统的想法、过程。

# 一、构思

## 主要特征

该系统拥有web界面
代码发布功能：可以在web中实现各个webent单独发布、整体发布
git历史查看功能：查看git提交历史、查看每次提交修改文件。所以需要定时自动更新日志。
两次发布版本差异对比功能

## 实践能力

一个python的web框架
python调度操作git、maven、执行脚本
python写入和读取数据库
python/git版本对比

# 二、计划

1、寻找一款python的web框架。定为django。
2、学习并实践该框架
3、设计系统的MVC
4、各个功能编码实现和测试

# 三、执行

## django的安装

安装的方法丰富多彩，很简单。参考github上[django/django](https://github.com/django/django)
或者参考官方网站的安装办法。

## django的学习

主要参考官网的翻译资料：[http://python.usyiyi.cn/translate/django_182/index.html](http://python.usyiyi.cn/translate/django_182/index.html)
这里从文章发出到现在（2017/1/8），持续有40多天，期间断断续续的看，断断续续的边学边练习里面的例子。插播了很多其他事情，尤其是一些无聊的手机游戏，双休要跟老婆见面，时间蛮少了，坚持下来确实有点苦难，还好基础看完了。继续加油！下面硬着头皮继续下一个阶段的学习实践。

<!-- more -->
## 发版系统的原型

1. 编译完成后，shell代码要将编译结果发布到tomcat容器中，容器路径在server.xml中配置了。其实这个地方理论上来将是没有必要的，个人认为，编译阶段就可以定义好编译的路径。研究下maven，把现在的shell流程简化。参考：[http://blog.csdn.net/rj042/article/details/6834557](http://blog.csdn.net/rj042/article/details/6834557)。后发现pom.xml修改会影响研发的windows下编译发布路径，维持现状。

## 编码阶段

在我的django工程目录下新建自己的网站：
```js 
#新建项目
django-admin startproject mydemo
```
 
```js 
#新建网站
cd mydemo
python3.5 manage.py startapp gitlog
```

执行完
chaosbom@chaosbomPC:~/PycharmProjects/mydemo$ tree
.
├── gitlog
│ ├── admin.py
│ ├── apps.py
│ ├── **init**.py
│ ├── migrations
│ │ └── **init**.py
│ ├── models.py
│ ├── tests.py
│ └── views.py
├── manage.py
└── mydemo
├── **init**.py
├── **pycache**
│ ├── **init**.cpython-35.pyc
│ └── settings.cpython-35.pyc
├── settings.py
├── urls.py
└── wsgi.py

编辑gitlog/model.py
```js 
from django.db import models
# Create your models here.

#maven编译使用的配置表
class Profiles(models.Model):
    P= models.CharField(max_length=20)
    add_date = models.DateTimeField('date published')


#管理webents的表，记录webent上次发版的时间以及上次发版使用的配置
class Webents(models.Model):
    name= models.CharField(max_length=50)
    lastPubStatus=models.ForeignKey(Profiles,default=1)
    lastPubDate=models.DateTimeField('date published')
    add_date = models.DateTimeField('date published')


#author提交人，message提交备注，commitsFile修改文件，git提交的nvalue唯一号
class Commits(models.Model):
    author= models.CharField(max_length=20)
    message = models.CharField(max_length=200)
    commitsFile = models.CharField(max_length=2000)
    nvalue=models.CharField(max_length=2000)
    commit_date = models.DateTimeField()
```

编辑mydemo/settings.py：该Django 项目的设置/配置。至于它如何运作的，此处略。仅修改以下对应内容。

```js 
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'gitlog',
]

DATABASES = {
    # 'default': {
    #     'ENGINE': 'django.db.backends.sqlite3',
    #     'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    # }
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '你的mysql数据库名称',
        'USER': 'root',
        'PASSWORD': '你的密码',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
```

接着让模型自动在数据库中生成表:

```js 
python3.5 manage.py check
python3.5 manage.py makemigrations gitlog
python3.5 manage.py migrate
```

登陆数据库查看，已经能够看到模型对应的数据库。

初始化数据库：
使用python的脚本来更新。
```js 
from __future__ import print_function
from datetime import date, datetime, timedelta
import mysql.connector

cnx = mysql.connector.connect(user='root',password='yb198697', database='gitlog')
cursor = cnx.cursor()

tomorrow = datetime.now().date() + timedelta(days=1)
today=datetime.now().date()+ timedelta(days=0)

profiles=['product','st' ,'stKa' ,'st-https' ,'nowx']
add_profile=("INSERT INTO gitlog_profiles "
               "(P, add_date) "
               "VALUES (%s, %s)")

for profile in profiles:
    data_profiles=(profile, today)
    cursor.execute(add_profile,data_profiles)


webents=['mk-aggregator' ,'mk-img-webent' ,'mk-wm-msger' ,'mk-app-webent' ,'mk-job-webent' ,'mk-openApi' ,'mk-wm-webent' ,
         'mk-yum-webent' ,'mk-imgr-webent' ,'mk-passport' ,'mk-sn-webent' ,'mk-intf-webent' ,'mk-imgr-rpc' ,'mk-yum-rpc' ,
         'mk-mdata-rpc']
add_webent=("INSERT INTO gitlog_webents "
               "(name, lastPubStatus_id,lastPubDate,add_date) "
               "VALUES (%s, %s, %s, %s)")


for webent in webents:
    data_webents=(webent,37, tomorrow,tomorrow)
    cursor.execute(add_webent,data_webents)


# Make sure data is committed to the database
cnx.commit()

cursor.close()
cnx.close()
```

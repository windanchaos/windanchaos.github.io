---
title: Django 学习，异常解决记录
author: windanchaos
tags: 
       - FromCSDN

category: 
       - python编程语言

date: 2017-01-13 00:23:11
---
1、Django throws django.core.exceptions.AppRegistryNotReady: Models aren’t loaded yet
或者报错：
django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
```js 
import django 
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "PROJECT_NAME.settings")
    django.setup()
    from APP_NAME.models import *
```

**PROJECT_NAME**，是自己django项目名

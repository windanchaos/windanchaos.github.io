---
title: eclipse class file editor source not found
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Java编程语言

date: 2017-04-18 16:11:28
---
使用maven构建的依赖库，selenium 要查看源代码，提示source not found。主要是因为maven下依赖库的时候，没有下载源代码，class无法解析出来。
直接右击项目，选择run as —》 maven Build，在Goals中输入：dependency:sources
![这里写图片描述](/images/dn.net-20170418160512924-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)
然后就自动下载库对应的源代码~~完美解决！

---
title: LoadRunner录制微信方法探索
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 测试的框架和技术

date: 2017-01-12 13:47:28
---
单位的应用是微信商城，若使用LD对商城进行性能测试，微信的鉴权是个大问题，除了让研发去掉鉴权的代码来测试外，LD自身提供的特性也可以达到录制的目的。下面简单介绍录制的方法和思路。

方法一：fiddler代理+手机代理录制

方法二：fiddler代理+微信开发者助手录制。

都需要fiddler中Tools—>Fiddler Options—>connections—>勾选“Allow remote computers to connect”，重启fiddler。
然后录制。
---
title: crontab 在GUI环境下执行webdriver
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2018-09-29 20:46:32
---
Linux下，大部分的问题都跟环境有关。
crontab也不例外。
我的需求：crontab定时执行脚本，依据条件启动webdriver(selenium)去浏览器上做一些操作，而且是周期性的。我使用的是splinter框架驱动业务。

需要解决：
1、系统具备gui运行的环境。
```js 
yum install -y libXfont xorg-x11-fonts*
```

2、sh脚本中在环境变量中增加

```js 
export DISPLAY=:0
```

3、执行脚本中增加模拟，我的是python

```js 
from pyvirtualdisplay import Display
display = Display(visible=0, size=(800, 800))  
display.start()

业务代码……
```

4、下载和安装浏览器及webderveir的驱动。
centos添加源

```js 
vi /etc/yum.repos.d/google.repo
```

添加如下内容

```js 
[google]
<!-- more -->
name=Google-x86_64
baseurl=http://dl.google.com/linux/rpm/stable/x86_64
enabled=1
gpgcheck=0
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
```

webderveir的略。

我的代码示例，有删减，留下的都是解决问题的核心代码：

脚本
```js 
#!/bin/bash
export DISPLAY=:0
source /etc/profile
....
python /home/user/weixin_open_ip.py
```

weixin_open_ip.py

```js 
# -*- coding: utf-8 -*-
...
from pyvirtualdisplay import Display

def changIP(ip):
  	....
	browser.quit()
if __name__ == '__main__':
    display = Display(visible=0, size=(800, 800))
    display.start()
    .....
    changIP(new_ip)
```

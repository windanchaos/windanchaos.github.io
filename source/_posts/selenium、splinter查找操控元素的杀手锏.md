---
title: selenium、splinter查找操控元素的杀手锏
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-02-09 18:06:41
---
# 1、使用xpath

使用splinter中无法获取到弹出框的元素，因为后台使用的div做的弹出框（看起来是javascript+css做出来的，不是浏览器原生的alert）。无意中发现chrome浏览器可以拷贝元素的xpath，于是就搞定了。
方法如图：
![这里写图片描述](http://image.windanchaos.tech/blog/dn.net-20170209174710573-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)
选中元素，在开发者工具中的elements下会有选中区域，右键即可。

接着使用：
```js 
browser.is_element_present_by_xpath('//*[@id="addSkuWindow"]/div/div/fieldset[1]/div/div/span/span/input')
```

# 2使用js操作元素

# 3使用jquery操控元素

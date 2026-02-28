---
title: Splinter使用中遇到的问题集锦
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-02-17 01:35:58
---
# 已经解决

1、selenium.common.exceptions.ElementNotVisibleException: Message: element not visible
2、selenium.common.exceptions.InvalidElementStateException: Message: invalid element state: Element is not currently interactable and may not be manipulated
出现以上两种异常的原理：
1、元素还没加载出来就操作，通常是alert框，解决办法time.sleep(1)，时间自己调试。
2、元素你看得到，但是代码要操作的元素是跟随鼠标变更样式的，或者其他条件实时变更的，导致代码不能“看见”。这种情况就需要通过js操作dom元素来适应场景。
我测试页面有一个input，在鼠标不操作是时候样式如下：
```js 
<input id="batch_quto" value="0" data-role="numerictextbox" role="spinbutton" style="display: none;" class="k-input" type="text" aria-valuemin="0" aria-valuenow="0" aria-disabled="false" aria-readonly="false">
```

当鼠标点击输入框，样式变为：

```js 
<input id="batch_quto" value="0" data-role="numerictextbox" role="spinbutton" style="display: inline-block;" class="k-input" type="text" aria-valuemin="0" aria-valuenow="0" aria-disabled="false" aria-readonly="false">
```

二者的区别：

```js 
style="display: none;"
style="display: inline-block;"
```

display 属性设置元素如何显示。所以无论是通过xpath、id来定位元素都无法用代码输入文本到input。
解决方法，使用splinter的js执行方法操作该input 的style属性，而要在你操作的若干个div嵌套中发现你操作的元素才是真正的难点：

```js 
# 以下4行代码耗费我3天的时间实验验证得出
browser.evaluate_script('document.getElementById("batch_quto").style="display: inline-block; visibility: visible;"')
browser.evaluate_script('document.getElementById("batch_quto").contentEditable = true')
browser.find_by_id('batch_quto').fill("120")
# 还原样式以免影响其他显示
browser.evaluate_script('document.getElementById("batch_quto").style="display: none; visibility: visible;"')
```

<!-- more -->
3、Message: unknown error: Element 。。。 is not clickable at point。。。
如果确认能找到元素，那么time.sleep(1)。
如果细心的你发现要点击的元素在浏览器底部位置，那么真的是被什么元素给遮挡了。所以可以：

```js 
# js操控浏览器滚动
browser.evaluate_script('window.scrollTo(0,800)')
# jquery操控浏览器的空间滚动，这里简单学习下jquery就懂了，回头我会把基础贴出来
browser.evaluate_script('$(".mk-product-body").scrollTop(500)')
# 模糊查询并操作
browser.evaluate_script('$("input[id^=\'logisticsWeight\']").first().val("500")')
browser.evaluate_script('$("input[class=\'k-formatted-value noEdit k-input\']").first().click()')
browser.evaluate_script('$("input[id^=\'logisticsWeight\'").last().val("1500")')
browser.evaluate_script('$("input[class=\'k-formatted-value noEdit k-input\']").last().click()')
```

执行操作太快，要手动等待。想修改splinter定义的方法，但是只读。。。解决思路很简单，github上clone一份splinter的源码，修改源码click事件，加一个sleep，再通过源码安装splinter即可。

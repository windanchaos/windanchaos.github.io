---
title: Selenium 1.0的历史及工作原理
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-04-13 21:56:37
---
本文引至：[http://blog.csdn.net/zzzmmmkkk/article/details/9274781](http://blog.csdn.net/zzzmmmkkk/article/details/9274781)

当你看到这篇文章时一定会诧异，2.0都广泛使用了，为何还要了解1.0的内容呢？1.0的确已经慢慢的成为历史，那我们就先通过历史来认识一下selenium的发展吧。

Jason Huggins在2004年发起了Selenium项目，当时他在ThoughtWorks公司开发内部的时间和费用（Time and Expenses）系统，该应用使用了大量的[JavaScript](http://lib.csdn.net/base/javascript "JavaScript知识库")。虽然IE在当时是主流浏览器，但是ThoughtWorks还使用一些其他浏览器（特别是Mozilla系列），当员工在自己的浏览器中无法正常运行T&E系统时就会提交bug。当时的开源工具要么关注单一浏览器（通常是IE），要么是模拟浏览器（如HttpUnit），而购买商业工具授权的成本会耗尽这个小型内部项目的有限预算，所以它们都不太可行。

幸运的是，所有被[测试](http://lib.csdn.net/base/softwaretest "软件测试知识库")的浏览器都支持Javascript。Jason和他所在的团队有理由采用Javascript编写一种测试工具来验证应用的行为。他们受到FIT(Framework for Integrated Test）的启发，使用基于表格的语法替代了原始的Javascript，这种做法支持那些编程经验有限的人在HTML文件中使用关键字驱动的方式来编写测试。该工具，最初称为“Selenium”，后来称为“Selenium Core”，在2004年基于Apache 2授权发布。

Selenium的表格格式类似于FIT的ActionFixture。表格的每一行分为三列。第一列给出了要执行的命令名称，第二列通常包含元素标记符，第三列包含一个可选值。例如，如下格式表示了如何在名称为“q”的元素中输入字符串“Selenium”：

type name=q Selenium

因为Selenium过去使用纯JavaScript编写，它的最初设计要求开发人员把准备测试的应用和Selenium Core、测试脚本部署到同一台服务器上以避免触犯浏览器的安全规则和JavaScript沙箱策略。在实际开发中，这种要求并不总是可行。更糟的是，虽然开发人员的IDE能够帮助他们快速处理代码和浏览庞大的代码库，但是没有针对HTML的相关工具。人们很快意识到维护一个中等规模的测试集是笨拙而痛苦的过程。

为了解决这个问题和其他问题，他们编写了HTTP代理，这样所有的HTTP请求都会被Selenium截获。使用代理可以绕过“同源”规则（浏览器不支持Javascript调用任何当前页面所在服务器以外的其他任何东西）的许多限制，从而缓解了首要弱点。这种设计使得采用多种语言编写Selenium成为可能：它们只需把HTTP请求发送到特定URL。连接方法基于Selenium Core的表格语法严格建模，称之为“Selenese”。因为语言绑定在远程控制浏览器，所以该工具称为“Selenium Remote Control”或者“Selenium RC”。

就在Selenium处于开发阶段的同时，另一款浏览

器自动化框架WebDriver也正在ThoughtWorks公司的酝酿之中。Selenium2.0之webdriver的介绍请期待下一篇文章。

上面介绍中其实也提到了1.0的概况，下图就是它的流程。

![](https://windanchaos.github.io/images/dn.net-20140227220501421-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvenp6bW1ta2tr-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)

1. 测试用例通过Http请求建立与 selenium-RC server 的连接

2. Selenium RC Server 驱动一个浏览器，把Selenium Core加载入浏览器页面当中，并把浏览器的代理设置为Selenium Server的Http Proxy

3. 执行用例向Selenium Server发送Http请求，Selenium Server对请求进行解析，然后通过Http Proxy发送JS命令通知Selenium Core执行操作浏览器的动作并注入 JS 代码

4.Selenium Core执行接受到的指令并操作

5. 当浏览器收到新的请求时，发送http请求

6. Selenium Server接收到浏览器发送的Http请求后，自己重组Http请求，获取对应的页面

7. Selenium Server中的Http Proxy把接受到的页面返回给浏览器。
<!-- more -->

**同源策略**，它是由Netscape提出的一个著名的安全策略，现在所有的可支持javascript的浏览器都会使用这个策略。所谓**同源**，就是指域名、协议、端口相同。所以，打开一个baidu的网页只能执行baidu下的JavaScript脚本，而另外一个tab是google，baidu下的JavaScript则不能执行，从而防止对本网页的非法篡改。

那么Selenium RC通过http代理的方式很好的解决了同源策略并欺骗了浏览器。

下一篇文章介绍2.0即selenium webdriver的发展，敬请期待。

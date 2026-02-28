---
title: Appium 微信 webview 的自动化技术
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-04-17 14:06:33
---
目录 
```js 
<blockquote>
```

最近好多人问微信webview自动化的事情, 碰巧我也在追微信webview的自动化和性能分析方法.
先发出来一点我的进展给大家参考下. 此方法用于android平台, iOS请自行解决

## 微信的设置

用微信打开debugx5.qq.com, 这是个微信的x5内核调试页面. 你可以在任何聊天窗口内输入这个网址. 并打开它.
勾选”是否打开TBS内核Inspector调试功能”
[](https://testerhome.com/uploads/photo/2016/63f8f2bbae83af9e4894c308ddc01a45.png)
![](https://windanchaos.github.io/images/com-uploads-photo-2016-63f8f2bbae83af9e4894c308ddc01a45-.png)

## 使用ChromeDriver编写测试用例

首先安装ChromeDriver
从官方下载或者从你的appium的安装路径里面找chromedriver. 在appium的执行日志里面其实也会打印chromedriver的路径的
然后在电脑上启动它, 设置好端口
```js 
chromedriver --url-base=wd/hub --port=8000
```

可以使用selenium或者appium的客户端去编写测试用例.
如下是我的scalatest的测试用例. 大家可以自己用其他的语言实现

```js 
test("test chromedriver weixin") {
  val options = new ChromeOptions()
  options.setExperimentalOption("androidPackage", "com.tencent.mm")
  options.setExperimentalOption("androidUseRunningApp", true)
  options.setExperimentalOption("androidActivity", ".plugin.webview.ui.tools.WebViewUI")
  options.setExperimentalOption("androidProcess", "com.tencent.mm:tools")
  val capability = DesiredCapabilities.chrome()
  capability.setCapability(ChromeOptions.CAPABILITY, options)
  val url = "http://127.0.0.1:8000/wd/hub"
<!-- more -->
  val driver = new AndroidDriver[WebElement](new URL(url), capability)
  driver.get("https://testerhome.com/topics/6954")
  println(driver.getPageSource)
  driver.quit()
}
```

## 使用appium编写测试用例

有人会经常问为什么android上appium不能自动化微信webview, 其实是可以的. 主要是目前的appium有个bug导致的.
在appium中context的切换时, 没有带上一个关键的androidProcess配置导致的.
他会导致appium识别webview的时候, 把com.tencent.mm:tools的webview识别成com.tencent.mm的webview. 从而导致context切换失败.

正确的用appium测试微信h5的方法如下
```js 
test("test weixin h5") {
  val capability = new DesiredCapabilities()
  capability.setCapability("app", "")
  capability.setCapability("appPackage", "com.tencent.mm")
  capability.setCapability("appActivity", ".ui.LauncherUI")
  capability.setCapability("deviceName", "emulator-5554")
  capability.setCapability("fastReset", "false")
  capability.setCapability("fullReset", "false")
  capability.setCapability("noReset", "true")
  //capability.setCapability("unicodeKeyboard", "true")
  //capability.setCapability("resetKeyboard", "true")

  //关键是加上这段
  val options = new ChromeOptions()
  options.setExperimentalOption("androidProcess", "com.tencent.mm:tools")
  capability.setCapability(ChromeOptions.CAPABILITY, options)

  val url = "http://127.0.0.1:4723/wd/hub"
  val driver = new AndroidDriver[WebElement](new URL(url), capability)
  println(driver.getPageSource)
  driver.findElementByXPath("//*[@text='我']").click
  driver.findElementByXPath("//*[@text='收藏']").click
  driver.findElementByXPath("//*[contains(@text, '美团外卖')]").click
  println(driver.getPageSource)
  println(driver.getContextHandles)
  driver.context("WEBVIEW_com.tencent.mm:tools")
  println(driver.getPageSource)
}
```

最关键的就是这句

```js 
val options = new ChromeOptions()
options.setExperimentalOption("androidProcess", "com.tencent.mm:tools")
capability.setCapability(ChromeOptions.CAPABILITY, options)
```

## 后记

之前测试加上ChromeOptions配置的时候没有成功, 我以为是appium不支持ChromeOptions, 就给appium-android-driver提交了一个PR
后来jlipps提醒了我一下
[](https://testerhome.com/uploads/photo/2017/01a3284a711aa6e67bfafe26ab3934c0.png)
![](https://windanchaos.github.io/images/com--uploads-photo-2017-01a3284a711aa6e67bfafe26ab3934c0-.png)

我就又追查了几遍, 最后发现是我本地安装appium时候加上的http_proxy环境变量干扰了ChromeDriver的执行.
Appium其实是支持ChromeOptions的

**结论也就是现在的Appium其实是可以完美的做微信自动化的**

我在想我是不是国内第一个提供微信webview自动化方法的人
借鉴此思路的同学转发请注明原链. [https://testerhome.com/topics/6954](https://testerhome.com/topics/6954)

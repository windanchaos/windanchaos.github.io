---
title: Selenium Webdriver重新使用已打开的浏览器实例
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-04-17 18:26:26
---
本文转自：[http://blog.csdn.net/wwwqjpcom/article/details/51232302](http://blog.csdn.net/wwwqjpcom/article/details/51232302)
本文中的样例均使用SoapUI ，关于SoapUI+Webdriver 的配置，请看上一篇：
[](http://blog.csdn.net/wwwqjpcom/article/details/51174664)[http://blog.csdn.net/wwwqjpcom/article/details/51174664](http://blog.csdn.net/wwwqjpcom/article/details/51174664)

我弄这个的本意是为了在SoapUI中更好地编写自动化用例，因为我的业务流程有的很长，有7-8个页面。
我想把代码不集中在一个Groovy 脚本里，想在第二个脚本中继续使用第一个脚本中打开的浏览器。这样便于
维护和定位问题。
也还有一种情况是我打开了浏览器，，操作了系统到某一个界面后，我写了这个页面的[测试](http://lib.csdn.net/base/softwaretest "软件测试知识库")脚本，使用已
打开的浏览器我立刻就可以单独对这个页面进行测试，测试我写的代码是否OK 。不通过就人工操作复位页面，
修改代码后再次测试，不用每次测试代码是否可行都从头打卡浏览器，登录系统，重新操作了。可以实现分步
单页面调试自动化脚本。

首先，来简单看一下Selenium Webdriver如何工作的。
（1）Selenium代码调用API实际上根据 The WebDriver Wire Protocol 发送不同的Http Request 到 WebdriverServer。
IE 是 IEDriverServer.exe
Chrome是ChromerDriver，下载地址： [https://sites.google.com/a/chromium.org/chromedriver/downloads](https://sites.google.com/a/chromium.org/chromedriver/downloads)
Firefox是以插件的形式，直接在selenium-server-standalone-XXX.jar里了：
webdriver.xpi （selenium-server-standalone-2.48.2.jar中/org/openqa/selenium/firefox/目录下）

new FirefoxDriver()时，启动Firefox浏览器时，带此插件一起启动，然后插件会默认监听7055端口，7055被占用就使用下一个端口。如下图所示。
![这里写图片描述](/images/dn.net-20160424100800878.png)
同一台机器上可以同时启动多个FirefoxDriver实例，每个实例占用不同的端口号。
```js 
The WebDriver Wire Protocol 协议的具体内容请看：https://code.google.com/p/selenium/wiki/JsonWireProtocol#Introduction。  这个协议现在正在被W3C标准化，W3C Webdriver，两者基本一样。  
W3C Webdriver标准协议内容：http://www.w3.org/TR/webdriver/
```

（2）WebdriverServer接收到Http Request之后，根据不同的命令在[操作系统](http://lib.csdn.net/base/operatingsystem "操作系统知识库")层面去触发浏览器的”native事件“，
模拟操作浏览器。WebdriverServer将操作结果Http Response返回给代码调用的客户端。

为了更清晰直观地看到这个是如何运转的，我们来在使用OWASP ZAP做代理，截获Http Request和Response来看一下。
首先安装OWASP ZAP或其他有代理功能的工具，设置SoapUI Proxy，如ZAP默认使用8080端口，则SoapUI配置如下：
![这里写图片描述](/images/dn.net-20160424100954806.png)
配置完SoapUI端口后，好像需要重启SoapUI，然后在SoapUI 的自动化测试代码中，代理才能正常工作。

重新跑前一节FirefoxDriver的代码，查看截获的请求和响应。如下图所示：
![这里写图片描述](/images/dn.net-20160424101223635.png)
![这里写图片描述](/images/dn.net-20160424101313041.png)
可以清楚地看到代码与DriverServer之间是如何根据WebDriver协议连通的。
WebDriver协议是RESTful风格的。

**回到我们的主题：Webdriver重新使用已打开的浏览器实例。**
Webdriver实例都将重新打开一个浏览器，新建一个Session。Selenium并没有接口或方法可以使用已有Session。
如果在一个测试用例中不将浏览器退出关闭，想要在另一个新的测试用例中使用已打开的浏览器的话，怎么办？
Selenium Webdriver本省并没有这种接口。本人自己实现了一个基于FirefoxDriver的，因为我基本只用Firefox，
IE 什么的，没需求，没动力啊，但是大概原理应该类似，差不多。

FirefoxDriver是主要是由startClient()和startSession()完成初始化。startClient()中打开浏览器，设置执行器HttpCommandExecutor。
StartSession执行New Session指令，获取SessionID，并根据响应，设置capabilities。
具体有兴趣的可以自己下载源代码，自己看。

根据上文，Webdriver 想要执行命令，需要**1：WebdriverServer的地址 2：一个可用的SessionID** 。
写一个自己的WebDriver类来new一个Webdriver。

因此需要在一个用例中保存WebdriverServer的地址和SessionID ,最后不退出关闭浏览器。
另一个用例中使用保存的参数，完成Webdriver的实例化。
代码就不贴在文章里了：源代码及jar包下载地址：
[http://download.csdn.net/detail/wwwqjpcom/9500777](http://download.csdn.net/detail/wwwqjpcom/9500777)

其中的初始化代码如下（需要两个参数 Webdriver 的地址和SessionID）：
```js 
public myFirefoxDriver(String localserver,String sessionID){

        mystartClient(localserver);
        mystartSession(sessionID);

    }
```

代码例子：
**测试用例1中打开浏览器，但是不退出关闭浏览器：**

```js 
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import org.openqa.selenium.firefox.FirefoxDriver
import org.openqa.selenium.support.ui.ExpectedCondition
import org.openqa.selenium.support.ui.WebDriverWait
import org.openqa.selenium.OutputType
import org.apache.commons.io.FileUtils
import org.openqa.selenium.Keys

WebDriver driver = new FirefoxDriver()   

try
{
driver.get("https://learnsoapui.wordpress.com") // Url to be opened

//下面两行将所需的地址和SessionID 保存起来。样例因为是在SoapUI中的两个Step，所以保存为了SoapUI中  
//用例级别的属性，具体请根据自己的使用环境保存为系统参数或其他地方
testRunner.testCase.setPropertyValue( "DriverServer", driver.getCommandExecutor().getAddressOfRemoteServer().toString() )
testRunner.testCase.setPropertyValue( "CaseSession", driver.getSessionId().toString() )
log.info driver.getSessionId().toString()

 WebElement element = driver.findElement(By.id("s"))
 element.sendKeys("Assertion")

 File f1 = driver.getScreenshotAs(OutputType.FILE)
 FileUtils.copyFile(f1, new File("c:\\screenshot1.png")); // Location to save screenshot

 element.submit()

 driver.getKeyboard ().pressKey (Keys.DOWN)
 driver.getKeyboard ().pressKey (Keys.DOWN)
 driver.getKeyboard ().pressKey (Keys.DOWN)
 driver.getKeyboard ().pressKey (Keys.UP)
 driver.getKeyboard ().pressKey (Keys.UP)
 driver.getKeyboard ().pressKey (Keys.UP)
}
catch(Exception e)
{
log.info "Exception encountered : " + e.message
}
```

测试用例2中继续使用1中已打开的浏览器：

```js 
import webtest.myFirefoxDriver;
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import org.openqa.selenium.firefox.FirefoxDriver
import org.openqa.selenium.JavascriptExecutor

//下面三行，取出保存的可用的浏览器的Webdriver Server的地址和SessionID，new一个Webdriver。
def driverserver = testRunner.testCase.getPropertyValue( "DriverServer" )
def caseSession = testRunner.testCase.getPropertyValue( "CaseSession" )
WebDriver driver = new myFirefoxDriver(driverserver,caseSession)

log.info (driver.getCommandExecutor().getAddressOfRemoteServer())

try
{
driver.findElement(By.linkText("Home")).click()// Url to be opened
driver.findElement(By.linkText("About Author")).click()// Url to be opened
 log.info driver.getSessionId().toString()
 log.info driver.getCapabilities()

((JavascriptExecutor)driver).executeScript("alert(\"hello,this is a alert!\")");
 //driver.quit()
}
catch(Exception e)
{
log.info "Exception encountered : " + e.message
}
```

![这里写图片描述](/images/dn.net-20160424110409828.png)
注意代码中的文字注释下方部分，1中要将WebdriverServer的地址和SessionID 保存起来，
2中使用1中保存的参数，用实现的自己的myFirefoxDriver来初始化driver。
（此处感谢[https://learnsoapui.wordpress.com/](https://learnsoapui.wordpress.com/) ， 我最初研究在SoapUI中使用Selenium
Webdriver看了这个，虽然感觉他讲的也是不明不白的 ，但是给了我启发）。

```js 
注：（1）webtest01.jar是我在Selenium 2.48.2版本的代码下编译的，本人只配合用过Selenium 2.48.2 
       和Selenium 2.53.0这两个版本可用，其他的Selenium版本我是没试过的，说不定老版本不支持的。） 
   （2）实际中myFirefoxDriver不仅可以在本地用，用来RemoteWebdriver远程调用也是可以用的，即打开 
       RemoteWebdriver，然后用myFirefoxDriver来继续使用远程的那个已打开的浏览器实例，反正是只需要那两 
       个参数就可以，反正我自己用的时候这种情况也是是可以用的。仅供参考，不提供技术支持，呃，后果自负哦。
```

```js 
<script type="text/javascript">
            $(function () {
                $('pre.prettyprint code').each(function () {
                    var lines = $(this).text().split('\n').length;
                    var $numbering = $('<ul></ul>').addClass('pre-numbering').hide();
                    $(this).addClass('has-numbering').parent().append($numbering);
                    for (i = 1; i <= lines; i++) {
                        $numbering.append($('<li></li>').text(i));
                    };
                    $numbering.fadeIn(1700);
                });
            });
        </script>
```
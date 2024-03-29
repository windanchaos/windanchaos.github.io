---
title: http协议详解及操作
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-11-05 20:21:55
---
互联网，绝大多数的Web开发，都是构建在HTTP协议之上的Web应用,核心就是不同构建在TCP/IP协议基础上的http请求。固本求原，本篇文章将对http协议进行整理学习、然后使用代码去操作。

# １.http协议

## １.1如何工作

HTTP协议是Hyper Text Transfer Protocol（超文本传输协议）的缩写,是用于从万维网（WWW:World Wide Web ）服务器传输超文本到本地浏览器的传送协议。

HTTP是基于客户端/服务端（C/S）的架构模型，通过一个可靠的链接来交换信息，是一个无状态的请求/响应协议。
一个HTTP"客户端"是一个应用程序（Web浏览器或其他任何客户端），通过连接到服务器达到向服务器发送一个或多个HTTP的请求的目的。

一个HTTP"服务器"同样也是一个应用程序（通常是一个Web服务，如Apache Web服务器或IIS服务器等），通过接收客户端的请求并向客户端发送HTTP响应数据。

HTTP使用统一资源标识符（Uniform Resource Identifiers, URI）来传输数据和建立连接。
HTTP是一个基于TCP/IP通信协议来传递数据（HTML 文件, 图片文件, 查询结果等）。
以下图表展示了HTTP协议通信流程：
![这里写图片描述](http://image.windanchaos.tech/blog/om-wp-content-uploads-2013-11-cgiarch.gif.png)

因此，该协议就是客户端和服务器交换数据的一揽子标准。

可以是浏览器发起请求，也可以是程序代码去发起。
序号 方法 描述 1 GET 请求指定的页面信息，并返回实体主体。 2 HEAD 类似于get请求，只不过返回的响应中没有具体的内容，用于获取报文 3 POST 向指定资源提交数据进行处理请求（例如提交表单或者上传文件）。数据被包含在请求体中。POST请求可能会导致新的资源的建立和/或已有资源的修改。 4 PUT 从客户端向服务器传送的数据取代指定的文档的内容。 5 DELETE 请求服务器删除指定的页面。 6 CONNECT HTTP/1.1协议中预留给能够将连接改为管道方式的代理服务器。 7 OPTIONS 允许客户端查看服务器的性能。 8 TRACE 回显服务器收到的请求，主要用于测试或诊断。 客户端发送一个HTTP请求到服务器的请求消息包括以下格式：请求行（request line）、请求头部（header）、空行和请求数据四个部分组成，见下文http报文。

HTTP响应也由四个部分组成，分别是：状态行、消息报文、空行和响应正文。
![这里写图片描述](http://image.windanchaos.tech/blog/om-wp-content-uploads-2013-11-httpmessage.jpg.png)

## １.2协议特点

HTTP协议的主要特点可概括如下：
1.支持客户/服务器模式。
2.简单快速：客户向服务器请求服务时，只需传送请求方法和路径。请求方法常用的有GET、HEAD、POST。每种方法规定了客户与服务器联系的类型不同。由于HTTP协议简单，使得HTTP服务器的程序规模小，因而通信速度很快。
3.灵活：HTTP允许传输任意类型的数据对象。正在传输的类型由Content-Type加以标记。
4.无连接：无连接的含义是限制每次连接只处理一个请求。服务器处理完客户的请求，并收到客户的应答后，即断开连接。采用这种方式可以节省传输时间。
5.无状态：HTTP协议是无状态协议。无状态是指协议对于事务处理没有记忆能力。缺少状态意味着如果后续处理需要前面的信息，则它必须重传，这样可能导致每次连接传送的数据量增大。另一方面，在服务器不需要先前信息时它的应答就较快。

## 1.3HTTP协议的报文

<!-- more -->
HTTP消息由客户端到服务器的请求和服务器到客户端的响应组成，请求和响应由HTTP报文传递，报文是简单的格式化数据块。
起始行和首部就是由行分隔的ASCII文本。每行都以一个由两个字符组成的行终止序列作为结束，其中包括一个回车符（ASCII码13）和一个换行符（ASCII码10）。

请求消息和响应消息都是由以下内容**组成**:

![这里写图片描述](http://image.windanchaos.tech/blog/blog.com-upload-8-69-86959da15dff4b43.jpg.png)
如图，一个请求报文的示意：
![这里写图片描述](http://image.windanchaos.tech/blog/om-wp-content-uploads-2013-11-2012072810301161-.png)
每一个报文域都是由名字+“：”+空格+值 组成，消息报文域的名字是大小写无关的。
如图：一个访问百度的请求报文和响应报文(header)

![这里写图片描述](http://image.windanchaos.tech/blog/dn.net-20171105210421826-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)

**HTTP消息报文包括普通报文、请求报文、响应报文、实体报文。**

在普通报文中，有少数报文域用于所有的请求和响应消息，但并不用于被传输的实体，只用于传输的消息。
eg：
Cache-Control 用于指定缓存指令，缓存指令是单向的（响应中出现的缓存指令在请求中未必会出现），且是独立的（一个消息的缓存指令不会影响另一个消息处理的缓存机制），HTTP1.0使用的类似的报文域为Pragma。
请求时的缓存指令包括：no-cache（用于指示请求或响应消息不能缓存）、no-store、max-age、max-stale、min-fresh、only-if-cached;
响应时的缓存指令包括：public、private、no-cache、no-store、no-transform、must-revalidate、proxy-revalidate、max-age、s-maxage.

请求报文允许客户端向服务器端传递请求的附加信息以及客户端自身的信息。
Header 解释 示例 Accept 指定客户端能够接收的内容类型 Accept: text/plain, text/html Accept-Charset 浏览器可以接受的字符编码集。 Accept-Charset: iso-8859-5 Accept-Encoding 指定浏览器可以支持的web服务器返回内容压缩编码类型。 Accept-Encoding: compress, gzip Accept-Language 浏览器可接受的语言 Accept-Language: en,zh Accept-Ranges 可以请求网页实体的一个或者多个子范围字段 Accept-Ranges: bytes Authorization HTTP授权的授权证书 Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ== Cache-Control 指定请求和响应遵循的缓存机制 Cache-Control: no-cache Connection 表示是否需要持久连接。（HTTP 1.1默认进行持久连接） Connection: close Cookie HTTP请求发送时，会把保存在该请求域名下的所有cookie值一起发送给web服务器。 Cookie: $Version=1; Skin=new; Content-Length 请求的内容长度 Content-Length: 348 Content-Type 请求的与实体对应的MIME信息 Content-Type: application/x-www-form-urlencoded Date 请求发送的日期和时间 Date: Tue, 15 Nov 2010 08:12:31 GMT Expect 请求的特定的服务器行为 Expect: 100-continue From 发出请求的用户的Email From: user@email.com Host 指定请求的服务器的域名和端口号 Host: www.zcmhi.com If-Match 只有请求内容与实体相匹配才有效 If-Match: “737060cd8c284d8af7ad3082f209582d” If-Modified-Since 如果请求的部分在指定时间之后被修改则请求成功，未被修改则返回304代码 If-Modified-Since: Sat, 29 Oct 2010 19:43:31 GMT If-None-Match 如果内容未改变返回304代码，参数为服务器先前发送的Etag，与服务器回应的Etag比较判断是否改变 If-None-Match: “737060cd8c284d8af7ad3082f209582d” If-Range 如果实体未改变，服务器发送客户端丢失的部分，否则发送整个实体。参数也为Etag If-Range: “737060cd8c284d8af7ad3082f209582d” If-Unmodified-Since 只在实体在指定时间之后未被修改才请求成功 If-Unmodified-Since: Sat, 29 Oct 2010 19:43:31 GMT Max-Forwards 限制信息通过代理和网关传送的时间 Max-Forwards: 10 Pragma 用来包含实现特定的指令 Pragma: no-cache Proxy-Authorization 连接到代理的授权证书 Proxy-Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ== Range 只请求实体的一部分，指定范围 Range: bytes=500-999 Referer 先前网页的地址，当前请求网页紧随其后,即来路 Referer: http://www.zcmhi.com/archives/71.html TE 客户端愿意接受的传输编码，并通知服务器接受接受尾加头信息 TE: trailers,deflate;q=0.5 Upgrade 向服务器指定某种传输协议以便服务器进行转换（如果支持） Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11 User-Agent User-Agent的内容包含发出请求的用户信息 User-Agent: Mozilla/5.0 (Linux; X11) Via 通知中间网关或代理服务器地址，通信协议 Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1) Warning 关于消息实体的警告信息 Warn: 199 Miscellaneous warning

响应报文允许服务器传递不能放在状态行中的附加响应信息，以及关于服务器的信息和对Request-URI所标识的资源进行下一步访问的信息。
Header 解释 示例 Accept-Ranges 表明服务器是否支持指定范围请求及哪种类型的分段请求 Accept-Ranges: bytes Age 从原始服务器到代理缓存形成的估算时间（以秒计，非负） Age: 12 Allow 对某网络资源的有效的请求行为，不允许则返回405 Allow: GET, HEAD Cache-Control 告诉所有的缓存机制是否可以缓存及哪种类型 Cache-Control: no-cache Content-Encoding web服务器支持的返回内容压缩编码类型。 Content-Encoding: gzip Content-Language 响应体的语言 Content-Language: en,zh Content-Length 响应体的长度 Content-Length: 348 Content-Location 请求资源可替代的备用的另一地址 Content-Location: /index.htm Content-MD5 返回资源的MD5校验值 Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ== Content-Range 在整个返回体中本部分的字节位置 Content-Range: bytes 21010-47021/47022 Content-Type 返回内容的MIME类型 Content-Type: text/html; charset=utf-8 Date 原始服务器消息发出的时间 Date: Tue, 15 Nov 2010 08:12:31 GMT ETag 请求变量的实体标签的当前值 ETag: “737060cd8c284d8af7ad3082f209582d” Expires 响应过期的日期和时间 Expires: Thu, 01 Dec 2010 16:00:00 GMT Last-Modified 请求资源的最后修改时间 Last-Modified: Tue, 15 Nov 2010 12:45:26 GMT Location 用来重定向接收方到非请求URL的位置来完成请求或标识新的资源 Location: http://www.zcmhi.com/archives/94.html Pragma 包括实现特定的指令，它可应用到响应链上的任何接收方 Pragma: no-cache Proxy-Authenticate 它指出认证方案和可应用到代理的该URL上的参数 Proxy-Authenticate: Basic refresh 应用于重定向或一个新的资源被创造，在5秒之后重定向（由网景提出，被大部分浏览器支持） 
Refresh: 5; url=

http://www.zcmhi.com/archives/94.html Retry-After 如果实体暂时不可取，通知客户端在指定时间之后再次尝试 Retry-After: 120 Server web服务器软件名称 Server: Apache/1.3.27 (Unix) (Red-Hat/Linux) Set-Cookie 设置Http Cookie Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=1 Trailer 指出头域在分块传输编码的尾部存在 Trailer: Max-Forwards Transfer-Encoding 文件传输编码 Transfer-Encoding:chunked Vary 告诉下游代理是使用缓存响应还是从原始服务器请求 Vary: /* Via 告知代理客户端响应是通过哪里发送的 Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1) Warning 警告实体可能存在的问题 Warning: 199 Miscellaneous warning WWW-Authenticate 表明客户端请求实体应该使用的授权方案 WWW-Authenticate: Basic

请求和响应消息都可以传送一个实体。一个实体由实体报文域和实体正文组成，但并不是说实体报文域和实体正文要在一起发送，可以只发送实体报文域。
HTTP实体的组成：实体首部和实体主体。
```js 
实体首部：描述了HTTP报文的内容
实体主体：实体主体即原始数据
```

#### 1.3.4.1实体首部

Allow：列出了可以对此实体执行的请求方法

Location：告知客户端实体实际上位于何处，用于将接收端定向到资源的位置(URL)上去

Content-Base：解析主体中的相对URL时使用的基础URL

Content-Encoding：对主体执行的任意编码方式

Content-Language：理解主体时最适宜使用的自然语言

Content-Length：主体的长度

Content-Location：资源实际所处的位置

Content-MD5：主体的MD5校验和

Content-Range：在整个资源中此实体表示的字节范围

Content-Type：这个主体的对象类型

ETag：与此实体相关的实体标记

Expires：实体不再有效，要从原始的源端再次获取实体的日期和时间

Last-Modified：这个实体最后一次被修改的日期和时间

#### 1.3.4.2.实体的主体

该部分其实就是HTTP要传输的内容，是可选的。HTTP报文可以承载很多类型的数字数据，比如，图片、视频、HTML文档电子邮件、软件应用程序等等。
这是大头。但是描述的信息很少，说明http并不是很care你传输的是什么东西，它就是一个负责运输的工具。

当浏览者访问一个网页时，浏览者的浏览器会向网页所在服务器发出请求。当浏览器接收并显示网页前，此网页所在的服务器会返回一个包含HTTP状态码的信息头（server header）用以响应浏览器的请求。
HTTP状态码由三个十进制数字组成，第一个十进制数字定义了状态码的类型，后两个数字没有分类的作用。HTTP状态码共分为5种类型：
HTTP状态码的英文为HTTP Status Code。 下面是常见的HTTP状态码：
分类 分类描述 1/*/* 信息，服务器收到请求，需要请求者继续执行操作 2/*/* 成功，操作被成功接收并处理 3/*/* 重定向，需要进一步的操作以完成请求 4/*/* 客户端错误，请求包含语法错误或无法完成请求 5/*/* 服务器错误，服务器在处理请求的过程中发生了错误

# ２用Python操作http请求

## ２.1python处理http的包选型

根据前人踩坑描述，Python 3 处理HTTP请求的包：http，urllib，urllib3，requests。
http是偏低层的，一般不使用。

下面摘录官网的document地址：
http: [https://docs.python.org/3/library/http.html](https://docs.python.org/3/library/http.html)

urllib也是一个包，里面含有多个模块：urllib.request，urllib.error，urllib.parse，urllib.robotparser。
这里的urllib.request 跟python 2.X 的urllib2有点像。urllib.request 基于http.client，但是比 http.client 更高层一些。

urllib：[https://docs.python.org/3/library/urllib.html](https://docs.python.org/3/library/urllib.html)

相比python的标准库，urllib3有很多很重要的特性，比如线程安全等。同时urllib3也很强大而且易于使用。
urllib3：[https://pypi.python.org/pypi/urllib3](https://pypi.python.org/pypi/urllib3)

Requests 基于urllib3，号称“Requests is an elegant and simple HTTP library for Python, built for human beings.”，意思就是专门为人类设计的HTTP库。
Requests：[http://docs.python-requests.org/en/latest/index.html](http://docs.python-requests.org/en/latest/index.html)

选型结论:requests和urllib3
[http://docs.python-requests.org/en/latest/user/quickstart/](http://docs.python-requests.org/en/latest/user/quickstart/)
[https://urllib3.readthedocs.io/en/latest/user-guide.html](https://urllib3.readthedocs.io/en/latest/user-guide.html)
剩下的事就简单了，在document里面翱翔一番。

## 2.2urllib3

我作为爬坑的，我说还是不要用它了，不方便。urllib3默认不支持https，支持也可以，请你做点额外的工作。user-guide上都有。
```js 
# -*- coding: utf-8 -*-
'''学习使用urlib3，集合了大部分方法的使用Demo.by windanchaos'''
import urllib3

'''
You’ll need a PoolManager instance to make requests. 
This object handles all of the details of connection pooling and thread safety.
'''
http = urllib3.PoolManager()


# make a request use request()
# request() returns a HTTPResponse object
# HTTPResponse返回了http的表头headers\状态码status\实体data.
# 定义超时和重试次数
r1 = http.request('GET', 'http://www.baidu.com',timeout=4.0,retries=10)
r2 = http.request('GET', 'http://httpbin.org/robots.txt')

print(r1.status)
# headers 是header的dict
print(r1.headers)
print(r1.data)

print(r2.status)
print(r2.headers)
print(r2.data)

# 请求数据的组织,下面访问baidu，使用手机端的User-Agent组织请求报头,返回的data就是移动端的了
agent={'User-Agent':'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) \
    Version/9.0 Mobile/13B143 Safari/601.1'}
r3 = http.request('GET', 'http://www.baidu.com', headers=agent)
print(r3.data)

# post和put请求，需要自己encode请求的参数
from urllib import urlencode
import json
encoded_args = urlencode({'arg': 'value'})
url4 = 'http://httpbin.org/post?' + encoded_args
r4 = http.request('POST', url4)
print(json.loads(r4.data.decode('utf-8'))['args'])

# 当然如果是form数据，urllib3也可以帮你encode，如：
r5 = http.request('POST', 'http://httpbin.org/post', fields={'field': 'value'})
print(json.loads(r5.data.decode('utf-8'))['form'],r5.status)

# post json demo
data = {'attribute': 'value'}
encoded_data = json.dumps(data).encode('utf-8')
r6 = http.request('POST', 'http://httpbin.org/post', body=encoded_data, headers={'Content-Type': 'application/json'})
print(json.loads(r6.data.decode('utf-8'))['json'])


# post file and binary data
'''
For uploading files using multipart/form-data encoding you can use the same approach as Form data and specify 
the file field as a tuple of (file_name, file_data)
'''
with open('example.txt') as fp:
    file_data = fp.read()
r7 = http.request('POST','http://httpbin.org/post', fields={'filefield': ('example.txt', file_data, 'text/plain')})
json.loads(r7.data.decode('utf-8'))['files']


'''
For sending raw binary data simply specify the body argument. It’s also recommended to set the Content-Type header
'''
with open('example.jpg', 'rb') as fp:
    binary_data = fp.read()
r8 = http.request('POST','http://httpbin.org/post',body=binary_data,headers={'Content-Type': 'image/jpeg'})
json.loads(r8.data.decode('utf-8'))['data']

# 对ssl默认是不支持的。需要提供额外的配置或下载额外的包。

# log & Errors & Exceptions¶
'''
If you are using the standard library logging module urllib3 will emit several logs. 
In some cases this can be undesirable. 
You can use the standard logger interface to change the log level for urllib3’s logger
>>>logging.getLogger("urllib3").setLevel(logging.WARNING)

>>> try:
...     http.request('GET', 'nx.example.com', retries=False)
>>> except urllib3.exceptions.NewConnectionError:
...     print('Connection failed.')
'''
```

## 2.3requests

文章超长了。转到[下一篇](http://blog.csdn.net/windanchaos/article/details/78473728)继续。

Reference参考文献（网页）：
[http://www.runoob.com/http/http-tutorial.html](http://www.runoob.com/http/http-tutorial.html)
[http://www.cnblogs.com/li0803/archive/2008/11/03/1324746.html](http://www.cnblogs.com/li0803/archive/2008/11/03/1324746.html)
[http://tools.jb51.net/table/http_status_code](http://tools.jb51.net/table/http_status_code)
[http://www.cnblogs.com/miniren/p/5885393.html](http://www.cnblogs.com/miniren/p/5885393.html)

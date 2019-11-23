---
title: infer运用实践
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-02-03 17:30:18
---
2016年上半年研究过一段时间infer，最难的是安装到ubuntu上各种依赖环境要解决，最后在公司的java代码上跑出来30多个可能存在空指针的代码段，并提交给研发处理。在使用过程中，我发现了一个infer的bug，并提交到infer的github上，该问题在：[https://github.com/facebook/infer/issues/442](https://github.com/facebook/infer/issues/442)
当然我的大部分提交都阵亡了，研发看了存在空指针可能的地方，告诉我代码确实会有空指针出现的可能，但是基于业务逻辑，是不会有问题的，由于鄙人对java不是很懂，难以识别代码，一股废了九牛二虎之力后，轻易的就消逝的感觉萦绕心间。下面把别人安装infer的文章转过来，以表纪念。

所有内容可以参考：[infer官网](https://infer.liaohuqiu.net/)
本文转自：[http://www.jianshu.com/p/4667e36aadea](http://www.jianshu.com/p/4667e36aadea)

# About Infer

Infer 是一个静态分析工具。Infer 可以分析 Objective-C， Java 或者 C 代码，报告潜在的问题。
任何人都可以使用 Infer 检测应用，这可以将那些严重的 bug 扼杀在发布之前，同时防止应用崩溃和性能低下。
![这里写图片描述](/images/uqiu.net-static-images-Infer-landing-.png)

# Infer特性

## Android 和 Java

Infer 可检查 Android 和 Java 代码中的 NullPointException 和 资源泄露。

## iOS

除了以上，Infer 还可发现 iOS 和 C 代码中的内存泄露，内存泄露，内存泄露。
Infer适用范围

包括 Facebook Android 和 iOS 主客户端，Facebook Messenger， Instagram 在内的，以及其他影响亿万用户的手机应用，每次代码变更，都要经过 Infer 的检测。

# Infer优点

1:效率高，规模大，几分钟能扫描数千行代码；
2:支持增量及非增量分析（后边会解释）
3:分解分析，整合输出结果。（infer能将代码分解，小范围分析后再将结果整合在一起，兼顾分析的深度和速度）

# Infer捕捉的bug类型

## C/OC中捕捉的bug类型

1:Resource leak
2:Memory leak
3:Null dereference
4:Premature nil termination argument

## 只在 OC中捕捉的bug类型

1:Retain cycle
2:Parameter not null checked
3:Ivar not null checked

# Infer安装

Infer为Linux和MacOS系统提供了预构建的二进制文件,如果你只是想使用Infer,而不想为该项目贡献代码的话,这些二进制文件足够了.相反，如果你想编译infer,请选择源码安装。此文档以Mac系统，源文件安装为栗子。

## 环境要求

Python版本：大于等于2.7

## 第一种：二进制文件安装

从infer release页面获取最新版本infer-osx-vXX.tar.xz (以osx标识),然后执行下面命令来安装Infer.

## 第二种：源码安装

借助brew安装

/usr/bin/ruby -e “$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/master/install](https://raw.githubusercontent.com/Homebrew/install/master/install))”

brew install infer
安装达到100% 后可通过｀infer –version｀查看infer版本信息

cd 你的代码文件路径//建议放到一个不常改动的位置哦）
echo “export PATH=\”$PATH:pwd/infer/infer/bin\”” \ >> ~/.bash_profile &&source ~/.bash_profile
执行完如上操作，如果没报错你就成功啦！

## Git克隆＋clang

（网速特别慢就不推荐了，因为俩步操作都很耗时）

git clone [https://github.com/facebook/infer.git](https://github.com/facebook/infer.git)

注意：如果要分析C和Objective-C，Infer还需要clang以及facebook-clang-plugin插件。 facebook-clang-plugin插件见：facebook-clang-plugin如果只想分析Java/Android代码，那么无需以上的依赖库

# Infer 的使用

[facebook/infer](https://github.com/facebook/infer%20) demo
目前infer支持的编译器有如下几种：
![这里写图片描述](/images/s.jianshu.io-upload_images-1673979-f9716e18248c7933.jpg-imageMogr2-auto-orient-strip.png)
infer能分析的文件类型
在github上下载demo，demo下examples目录里，你会发现有android项目、C语言文件、java类、oc类、iOS项目，没错啦，infer完全支持以上几种类型的BUG分析。这里我们用ios_hello项目来做栗子：
首先用cd命令进入ios_hello目录，然后运行以下命令进行编译
```js 
infer -- xcodebuild -target HelloWorldApp -configuration Debug -sdk
iphonesimulator
```

注意： 其中HelloWorldApp是你的项目名称

# 编译结果

1: 在项目所在目录下多出build和infer-out文件夹
![这里写图片描述](/images/s.jianshu.io-upload_images-1673979-90e8889c74a7ed1c.jpg-imageMogr2-auto-orient-strip.png)

编译 后
build文件夹：捕获阶段: Infer 捕获编译命令(上面介绍的编译器命令)，将文件翻译成 Infer 内部的中间语言。运行环境和设备信息也有所体现。
infer-out文件夹：分析阶段产生的文件，Infer将分析bugs结果输出到不同格式文件中，如csv、txt、json 方便对分析结果进行加工分析。
2: 运行后在终端会看到大量日志信息(同infer-out文件，可以以多种形式查看log信息)
![这里写图片描述](/images/s.jianshu.io-upload_images-1673979-4ce4efc6e7e9980b.jpg-imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)
![这里写图片描述](/images/s.jianshu.io-upload_images-1673979-8e23f650dda9195c.jpg-imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)
代码分析
cc

错误总结

# 注意事项总结

1:在俩次执行编译命令的过程中，发现在没有对代码做任何更改的时候，报出BUILD SUCCEEDED的提示：我懵了！

我懵了
根据提示可以看到，此次build并没有分析任何文件。原因就是上面所提到的增量分析。

**增量模式和非增量模式**
在第一次运行的时候，两种模式是一样的，都会对工程的所有文件进行编译检查，产生检查结果:
增量模式：当已经产生分析结果后（build和infer-out文件夹），再执行编译命令，即为增量模式。如有代码没有改动，则此次不会有编译结果产生，如果代码有新的改动，此次只产生新的编译结果。这种以增量为基准的原则叫做增量模式。
非增量模式：在删除了俩个文件夹的情况下，运行文件，会输出所有的编译信息，即此时处于非增量模式。

## 增量模式和非增量模式的转化

1:简单粗暴的做法是删除文件夹，即增量－>非增量
2:科学的做法是这样的：xcodebuild -target HelloWorldApp -configuration Debug -sdk iphonesimulator clean，以保证增量－>非增量状态
but…项目中我们更常用到的方式是修改单个文件，然后检测。 比如我检测出了这样的问题：
![这里写图片描述](/images/s.jianshu.io-upload_images-1673979-2862699ff2c6ef3c.jpg-imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)
查到bug
然后我去代码修正了这个问题：
![这里写图片描述](/images/s.jianshu.io-upload_images-1673979-b5e95982029f61e6.jpg-imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)
修改代码
执行：

```js 
xcodebuild -target HelloWorldApp -configuration Debug -sdk iphonesimulator clean
```

然后看终端，问题就修复了。
2:如果编译过程出现‘AttributeError: ‘NoneType’ object has no attribute ‘encode’’
![这里写图片描述](/images/s.jianshu.io-upload_images-1673979-41992bd81a373283--imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)
encode错误
解决办法：1，pwd查看你当前目录，应该在工程所在目录下，而不是图上用户目录。
2，猴塞雷，请关注你的额代码，可能有错误。
---
title: 关于DevOps的摘录
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 测试的框架和技术

date: 2017-07-18 16:25:53
---
DevOps（英文Development和Operations的组合）是一组过程、方法与系统的统称，用于促进开发（应用程序/软件工程）、技术运营和质量保障（QA）部门之间的沟通、协作与整合。简单地来说，就是更好的优化开发(DEV)、测试(QA)、运维(OPS)的流程，开发运维一体化，通过高度自动化工具与流程来使得软件构建、测试、发布更加快捷、频繁和可靠。

以下内容转自：[http://www.ituring.com.cn/article/265237](http://www.ituring.com.cn/article/265237)
当我们谈到 DevOps 时，可能讨论的是：流程和管理，运维和自动化，架构和服务，以及文化和组织等等概念。那么，到底什么是”DevOps”呢？

## 什么是DevOps

随着软件发布迭代的频率越来越高，传统的「瀑布型」（开发—测试—发布）模式已经不能满足快速交付的需求。2009 年左右 DevOps 应运而生，简单地来说，就是更好的优化开发(DEV)、测试(QA)、运维(OPS)的流程，开发运维一体化，通过高度自动化工具与流程来使得软件构建、测试、发布更加快捷、频繁和可靠。

![flow.ci](https://windanchaos.github.io/images/s.jianshu.io-upload_images-310906-735d15ceea69b44d.jpg-imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)

关于 DevOps 是什么，DevOps 的合著者 John Willis 写了一个非常好的帖子，在[这里](http://itrevolution.com/the-convergence-of-devops/).

## Devops 的好处与价值

在[2016 DevOps 新趋势调查报告](http://www.infoq.com/cn/articles/2016-devops-new-trend)显示，74% 的公司在尝试接受 DevOps，那么 Devops 有哪些好处与价值呢？

以上可以看出，DevOps 的好处更多基于在于持续部署与交付，这是对于业务与产品而言。而 DevOps 始于接受 DevOps 文化与技术方法论，它是部门间沟通协作的一组流程和方法，有助于改善公司组织文化、提高员工的参与感。

## Devops与持续集成

DevOps 是一个完整的面向IT运维的工作流，以 IT 自动化以及持续集成（CI）、持续部署（CD）为基础，来优化程式开发、测试、系统运维等所有环节。

纵观各个 DevOps 实践公司的技术资料，最全面最经典的是 flickr 的[10+ deploys per day](http://www.slideshare.net/jallspaw/10-deploys-per-day-dev-and-ops-cooperation-at-flickr)最佳实践提到的 DevOps Tools 的技术关键点:

```js 
1.Automated infrastructure（自动化，系统之间的集成） 2.shared version control（SVN共享源码） 3.one step build and deploy（持续构建和部署） 4.feature flags（主干开发） 5.Shared metrics 6.IRC and IM robots（信息整合）
```

以上的技术要点由持续集成/部署一线贯穿，主干开发是进行持续集成的前提，自动化以及代码周边集中管理是实施持续集成的必要条件。毫无疑问，DevOps 是持续集成思想的延伸，持续集成/部署是 DevOps 的技术核心，在没有自动化测试、持续集成/部署之下，DevOps就是空中楼阁。

我们做了一款 Hosted 持续集成产品—— [flow.ci](http://flow.ci/?utm_source=ituring&utm_medium=passage&utm_content=devops_guide) ，它融入了 workflow 机制的持续集成（CI）服务，也可以理解为自动化流程平台，除了集成代码、编译、测试之外，还可以集成常用的工具、灵活自定义流程，帮助你们塑造一个更优秀智能的 DevOps 环境。

![flow.ci](https://windanchaos.github.io/images/s.jianshu.io-upload_images-310906-98ac44a2bdf136de--imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)

## DevOps 的技术栈与工具链

<!-- more -->
Everything is Code，DevOps 也同样要通过技术工具链完成持续集成、持续交付、用户反馈和系统优化的整合。[Elasticbox](https://elasticbox.com/) 整理了 [60+ 开源工具与分类](https://elasticbox.com/blog/devops-open-source-tools/)，其中包括版本控制&协作开发工具、自动化构建和测试工具、持续集成&交付工具、部署工具、维护工具、监控，警告&分析工具等等， 补充了一些国内的服务，可以让你更好的执行实施 DevOps 工作流。

![flow.ci](https://windanchaos.github.io/images/s.jianshu.io-upload_images-310906-d7baf300841107a2.jpg-imageMogr2-auto-orient-strip%7CimageView2-2-w-1240.png)

顺便再分享一个 [DevOps BookMarks](http://www.devopsbookmarks.com/)，涉及了DevOps方方面面的工具和内容，有兴趣的同学可以去学习下。

## DevOps 最佳实践

自 2009 年提出 DevOps 的概念起，很多公司都开始实施 DevOps，国外比较著名的有Amazon 、Google、Facebook等，国内著名的有百度、华为、阿里等。Amazon 是 DevOps 最佳实践的最有说服力的代表之一。这是 Amazon 在 [Why We Need DevOps](http://www.youtube.com/watch?v=877OCQA_xzE) 一个月的 DevOps 快照：

```js 
11.6 seconds: 平均部署时长 (工作日) 1,079: 一小时的最大部署量 10,000: 主机平均并发接收部署量 30,000: 主机最高并发接收部署量
```

从早期的大型 SOA (Service Oriented Architecture)到 DevOps 文化的形成，Amazon 的每个工程师都可以完全独立地编写代码，测试代码，版本管理，部署上线，服务监测等任务。这套内部强大的 DevOps 文化最终形成核聚变， Amazon 一跃成为世界级别的云服务领导者 —— Amazon Web Services (AWS)。

除了 Amazon 外还有一些国内外的 DevOps 实践公司，一起来看看。

最全面最经典的是 flickr 的[10+ deploys per day](http://www.slideshare.net/jallspaw/10-deploys-per-day-dev-and-ops-cooperation-at-flickr)，简直是 DevOps 教科书般的存在。

百度技术团队是如何利用DevOps，来看看[解密百度持续交付方法与实践](http://dbaplus.cn/news-21-471-1.html)。

百度技术团队是如何利用DevOps，来看看[解密百度持续交付方法与实践](http://dbaplus.cn/news-21-471-1.html)。

解密Netflix 技术团队在整个 DevOps 过程中使用的部署工具和服务.

[How We Build Code at Netflix](http://techblog.netflix.com/2016/03/how-we-build-code-at-netflix.html).

2009年，Etsy建立自己的工具来更好更快地部署发布，[「Etsy 如何应用 DevOps」](http://www.networkworld.com/article/2886672/software/how-etsy-makes-devops-work.html)值得一读。

2009年，LinkedIn 团队就开始使用自动化部署工具，用于管理在1000+节点环境下发布上千个应用/服务的复杂性。这是 LinkedIn 自己造的轮子 >>[Deployment and Monitoring Automation with glu](http://devops.com/2014/04/02/deployment-and-monitoring-automation-glu/).

Airbnb 作为第三方平台公司，需要迅速发布多个小型部署。关于 Airbnb 的数据和基础设施，可以参考这个[slides](http://www.slideshare.net/InfoQ/data-infrastructure-at-airbnb)。

星巴克的 DevOps 计划>> [Starbucks Announces /#DevOpsTogether](https://medium.com/@cloud_opinion/starbucks-announces-devopstogether-2933aad59d74).

Ancestry.com 是 DevOps 运动的早期采用者，是 Continuous Delivery 和 DevOps 运动的先锋。想了解更多关于他们的过程、迁移和 DevOps 文化，不妨查看一下他们的系列文章[http://blogs.ancestry.com/techroots/category/devops/](http://blogs.ancestry.com/techroots/category/devops/)。

## DevOps = Culture + Tools

如果想整个业务部署 DevOps，不但需要软性要求即从上而下的培养 DevOps 文化自上而下地进行探索，也有硬性工具链要求，才能获得更高质量的软件交付。

最后，不论你是技术Leader，还是一名Dev、QA 或 Ops，实现全面的 DevOps 非常理想化也十分有挑战，希望这份 DevOps 初学者指南是一个好的开始:)

[flow.ci](http://flow.ci/?utm_source=ituring&utm_medium=passage&utm_content=devops_guide) 是融入了 workflow 机制的持续集成（CI）服务，也可以理解为自动化流程平台，除了集成代码、编译、测试之外，还可以集成常用的工具、灵活自定义流程。1 分钟即可完成开发测试环境搭建，开启第一个 Build。

本文来自 [flow.ci 官方博客](http://blog.flow.ci/)，转载请联系:)

=================================分割线=============================
1、监控工具比较老牌的就是Zabbix,Nagios，用Zabbix的感觉是最多的。国内的有小米开源的OpenFalcon。这类监控工具一般是对服务器、服务（中间件，数据库）做一些常用指标的监控。

2、性能分析/APM工具APM很多时候被认为是监控的一个细分领域。但在现代复杂分布式系统架构下，APM工具往往更能准确、直接的帮助用户定位到性能瓶颈，比如哪一个URL访问慢、哪一个方法执行慢、哪一个SQL执行慢。在以往要想拿到这些数据，往往得需要比较资深的架构师、DBA一起合作才能拿到这些数据，而定位瓶颈的效率往往还不太高。现在通过APM工具能让普通技能的运维人员，也很高效的定位到这些深层的问题。现在商用的APM工具不少，国外的有Newrelic，国内知名的就有听云、Oneapm、透视宝这些。开源的也有Pinpoint（naver开源）、Zipkin（twitter开源）、CAT（大众点评开源）.

3、批量+自动化运维工具这里就比较多了，知名的有Puppet、Ansible、Chef、Saltstack这些。这些在网上的资料也比较多，找比较新版本的官方文档看就行了。Puppet和chef是比较早期的工具，受众面也很大，不过这两个工具基于ruby实现，现在要找到熟悉ruby的人来做这块的二次开发可不容易。而ansible和saltstack则相对新生代一些，目前用户基数增长很快，基于python实现，要找做二次开发的人也相对容易的多。

4、集中日志分析工具在一个服务器比较多的环境下，如何集中的管理和分析、查询日志，已经变成一个比较强的需求了。想象一下，如果发生了某个错误，你还得一台台机器去翻日志文件，是不是很蛋疼。在这个需求驱动下，就诞生了一些集中日志分析工具。在开源领域，比较知名的就是ELK这一套工具了，涵盖了日志采集、上报、搜索、展现这一类基本需求，现在比较多的上规模的企业都用这个，网上资料也大把。核心实现机制都是通过一些日志采集代理（类似Filebeat）去爬日志文件，将最新的部分提交到采集服务端，后端再对接搜索引擎，能支持很快速、准确的搜索即可。有一个国内不怎么知名的Sentry日志收集服务，比较轻量级，本身是Python做的，与各种语言的日志框架做了非常好的集成，可以很方便的集中收集异常日志，并分配给对应的开发人员。它在github上有10000多个star了，这在DevOps相关的软件里，都是排名非常靠前的了。git的地址：[https://github.com/getsentry/sentry](https://github.com/getsentry/sentry)

5、持续集成/发布工具我接触的人都是用Jenkins的，没有用其他的，可能跟我所在的技术圈子有关。集成打包的过程其实一般都比较简单，配好版本库和打包脚本就行。但发布的过程就比较复杂，有些是全量发布，但也有非常多的IT团队采用增量发布。这个方面如果想用工具，还是得先分析清楚现有的发布流程，手工情况下怎么做，哪些能通过自动化工具来完成。

6、IaaS集成最近两年的公有云推广比较迅速，很多新的服务器采购都被导入到云上去了。现在主流的公有云都提供了比较完备的API，基于这些API也可以做一些针对基础资源的自动化操作，比如游戏行业的快速开服。

关于DevOps对效率的提升，Puppet出过一份调研报告，算是比较成体系的。中文版的报告链接在此：[http://www.idcos.com/download/devops-report](http://www.idcos.com/download/devops-report)

DevOps 开源工具:
[https://www.oschina.net/question/2012764_246208](https://www.oschina.net/question/2012764_246208)
[https://blog.profitbricks.com/51-best-devops-tools-for-devops-engineers/](https://blog.profitbricks.com/51-best-devops-tools-for-devops-engineers/)

---
title: shell正则表达式
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2018-03-08 17:45:07
---
# 正则表达式的分类

# 基本组成部分

正则表达式的基本组成部分。
![这里写图片描述](https://windanchaos.github.io/images/dn.net-20180308174914289-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)

# POSIX字符类

POSIX字符类是一个形如[:…:]的特殊元序列（meta sequence），他可以用于匹配特定的字符范围。
![这里写图片描述](https://windanchaos.github.io/images/dn.net-20180308174928299-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)

# 元字符

元字符（meta character）是一种Perl风格的正则表达式，只有一部分文本处理工具支持它，并不是所有的文本处理工具都支持。
![这里写图片描述](https://windanchaos.github.io/images/dn.net-20180308174945870-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)

shell 除了有通配符之外，由shell 负责预先先解析后，将处理结果传给命令行之外，shell还有一系列自己的其他特殊字符
![这里写图片描述](https://windanchaos.github.io/images/dn.net-20180308172720352-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)

# 转义符

有时候，我们想让 通配符，或者元字符 变成普通字符，不需要使用它。那么这里我们就需要用到转义符了。 shell提供转义符有三种
![这里写图片描述](https://windanchaos.github.io/images/dn.net-20180308173011390-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70.png)

# shell解析脚本的过程

![这里写图片描述](https://windanchaos.github.io/images/gs.com-cnblogs_com-chengmo-WindowsLiveWriter-LinuxShell_142B8-1_2-.png)
如果用双引号包括起来，shell检测跳过了1-4步和9-10步，单引号包括起来，shell检测就会跳过了1-10步。也就是说，双引号 只经过参数扩展、命令代换和算术代换就可以送入执行步骤，而单引号转义符直接会被送入执行步骤。而且，无论是双引号转义符还是单引号转义符在执行的时候能够告诉各个命令自身内部是一体的，但是其本身在执行时是并不是命令中文本的一部分。

本文参考：

[https://www.cnblogs.com/chengmo/archive/2010/10/17/1853344.html](https://www.cnblogs.com/chengmo/archive/2010/10/17/1853344.html)
[http://man.linuxde.net/docs/shell_regex.html](http://man.linuxde.net/docs/shell_regex.html)

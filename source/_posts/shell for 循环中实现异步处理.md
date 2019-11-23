---
title: shell for 循环中实现异步处理
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2018-07-18 14:29:44
---
理解异步，需要理解shell壳的原理，父shell和子shell进程之间关系。
shell什么情况下会产生子进程
下英文摘自info bash
1、后台执行命令 &。If a command is terminated by the control operator ‘&’, the shell executes the command asynchronously in a subshell.
2、管道命令 |。Each command in a pipeline is executed in its own subshell。
3、括号命令()。
Placing a list of commands between parentheses causes a subshell
environment to be created
4、执行外部脚本、程序：
When Bash finds such a file while searching the `$PATH’ for a command, it spawns a subshell to execute it. In other words, executing filename ARGUMENTS is equivalent to executing bash filename ARGUMENTS

核心命令：
等待命令

```js 
wait
```

后台运行命令

```js 
&
```

代码块，fork子进程

```js 
（
）
```

实例代码：
在for循环中，异步执行 单元 ()&：

```js 
for i in {1..5}
do
   echo ${i}
   (
     echo block one sleep:${i}
     echo block one_start:`date`
     sleep ${i}          
     echo block one_end:`date`
   )&
     echo Main_One:$!
   ( 
     echo block tow sleep:1
     echo block tow_start:`date`
     sleep 1
     echo block tow:`date`
  )&
     echo Main_Tow:$!
done
echo out:$!
```

以上测试结果显示，循环中(…)&代码，后台运行后，就fork了一个子进行。

```js 
1
Main_One:17976
block one sleep:1  #这里块一开始
Main_Tow:17977
2
Main_One:17978
Main_Tow:17980
3
block one sleep:2
Main_One:17981
Main_Tow:17983
4
Main_One:17984
Main_Tow:17985
5
Main_One:17986
Main_Tow:17987
out:17987  #这里整个脚本跑完
block one_start:Wed Jul 18 14:00:29 CST 2018
block one sleep:3
block tow sleep:1 #这里block二开始执行
block tow sleep:1
block tow sleep:1
block tow sleep:1
block tow sleep:1
block one_start:Wed Jul 18 14:00:29 CST 2018
block one sleep:4
block one sleep:5
block tow_start:Wed Jul 18 14:00:29 CST 2018
block tow_start:Wed Jul 18 14:00:29 CST 2018
block tow_start:Wed Jul 18 14:00:29 CST 2018
block tow_start:Wed Jul 18 14:00:29 CST 2018
block one_start:Wed Jul 18 14:00:29 CST 2018
block tow_start:Wed Jul 18 14:00:29 CST 2018
block one_start:Wed Jul 18 14:00:29 CST 2018
block one_start:Wed Jul 18 14:00:29 CST 2018
block one_end:Wed Jul 18 14:00:30 CST 2018
block tow:Wed Jul 18 14:00:30 CST 2018
block tow:Wed Jul 18 14:00:30 CST 2018
block tow:Wed Jul 18 14:00:30 CST 2018
block tow:Wed Jul 18 14:00:30 CST 2018
block tow:Wed Jul 18 14:00:30 CST 2018 #block二 先结束
block one_end:Wed Jul 18 14:00:31 CST 2018
block one_end:Wed Jul 18 14:00:32 CST 2018
block one_end:Wed Jul 18 14:00:33 CST 2018
block one_end:Wed Jul 18 14:00:34 CST 2018 #block一结束
```

看到网上有人说for循环中，是使用的子进程进行操作，这个结论应该是不合实际的。
只有在显性的fork了子进程，才有这种现象。在没有fork子进程的时候，for循环是顺序执行，等待上一个循环结束才会继续执行。
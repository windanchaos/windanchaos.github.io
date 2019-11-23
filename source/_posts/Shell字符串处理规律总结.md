---
title: Shell字符串处理规律总结
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2017-06-12 23:35:50
---
# 字符处理几个特殊约定

/#代表**截掉**开始
```js 
chaosbom@chaosbomPC:~$ file="thisfile.txt"
chaosbom@chaosbomPC:~$ echo ${file#*.}
txt
chaosbom@chaosbomPC:~$ echo ${file#*i}
sfile.txt
```

%代表**截掉**结尾

```js 
chaosbom@chaosbomPC:~$ file="thisfile.txt"
chaosbom@chaosbomPC:~$ echo ${file%e.*}
thisfil
chaosbom@chaosbomPC:~$ echo ${file%.*}
thisfile
```

//代表取所有（相对应未明确所有则是第一个）

```js 
chaosbom@chaosbomPC:~$ file="thisfile.txt"
chaosbom@chaosbomPC:~$ echo ${file//i/I}
thIsfIle.txt
chaosbom@chaosbomPC:~$ echo ${file//i}
thsfle.txt
```

/a/b 表示符合模式a的字符串将被b字符串替换，不指定b字符串则是删除。
如果被替换串包含/字符，那么要转义，写成\/

灵感来源：
[http://blog.csdn.net/guojin08/article/details/38704823](http://blog.csdn.net/guojin08/article/details/38704823)
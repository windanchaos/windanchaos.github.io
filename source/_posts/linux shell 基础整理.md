---
title: linux shell 基础整理
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2016-08-28 21:13:09
---
# 特殊变量

变 量 含义 $0 当前脚本的文件名 $n 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。 $/# 传递给脚本或函数的参数个数。 $/* 传递给脚本或函数的所有参数。 $@ 传递给脚本或函数的所有参数。被双引号(” “)包含时，与 $/* 稍有不同，下面将会讲到。 $? 上个命令的退出状态，或函数的返回值。 $$ 当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。

# 转义字符

转义字符 含义 \ 反斜杠 \a 警报，响铃 \b 退格（删除键） \f 换页(FF)，将当前位置移到下页开头 \n 换行 \r 回车 \t 水平制表符（tab键） \v 垂直制表符

# 变量替换

变量替换可以根据变量的状态（是否为空、是否定义等）来改变它的值。
转义字符 含义 ${var} 变量本来的值 ${var:-word} 如果变量 var 为空或已被删除(unset)，那么返回 word，但不改变 var 的值。 ${var:=word} 如果变量 var 为空或已被删除(unset)，那么返回 word，并将 var 的值设置为 word。 ${var:?message} 如果变量 var 为空或已被删除(unset)，那么将消息 message 送到标准错误输出，可以用来检测变量 var 是否可以被正常赋值。若此替换出现在Shell脚本中，那么脚本将停止运行。 ${var:+word} 如果变量 var 被定义，那么返回 word，但不改变 var 的值。

# Shell 传递参数

在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：$n。n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推……
参数处理 说明 $/# 传递到脚本的参数个数 $/* 以一个单字符串显示所有向脚本传递的参数。如”$/*”用「”」括起来的情况、以”1、$2…n”的形式输出所有参数。跟0，表示执行脚本自己的名称。 $$ 脚本运行的当前进程ID号 $! 后台运行的最后一个进程的ID号 $@ 与∗相同，但是使用时加引号，并在引号中返回每个参数。如”@”用「”」括起来的情况、以”1”“2” … “$n” 的形式输出所有参数。 $- 显示Shell使用的当前选项，与set命令功能相同。 $? 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。

$/* 与 $@ 区别：
相同点：都是引用所有参数。
不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 ” /* ” 等价于 “1 2 3”（传递了一个参数），而 “@” 等价于 “1” “2” “3”（传递了三个参数）。

# shell数组

数组中可以存放多个值。Bash Shell 只支持一维数组（不支持多维数组），初始化时不需要定义数组大小。与大部分编程语言类似，数组元素的下标由0开始。

# shell运算符

## 文件测试运算符

文件测试运算符用于检测 Unix 文件的各种属性。

属性检测描述如下：
操作符 说明 举例 -d file 检测文件是否是目录，如果是，则返回 true。 [ -d $file ] 返回 false。 -f file 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 [ -f $file ] 返回 true。 -k file 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。 [ -k $file ] 返回 false。 -p file 检测文件是否是有名管道，如果是，则返回 true。 [ -p $file ] 返回 false。 -u file 检测文件是否设置了 SUID 位，如果是，则返回 true。 [ -u $file ] 返回 false。 -g file 检测文件是否设置了 SGID 位，如果是，则返回 true。 [ -g $file ] 返回 false。 -r file 检测文件是否可读，如果是，则返回 true。 [ -r $file ] 返回 true。 -w file 检测文件是否可写，如果是，则返回 true。 [ -w $file ] 返回 true。 -x file 检测文件是否可执行，如果是，则返回 true。 [ -x $file ] 返回 true。 -s file 检测文件是否为空（文件大小是否大于0），不为空返回 true。 [ -s $file ] 返回 true。 -e file 检测文件（包括目录）是否存在，如果是，则返回 true。 [ -e $file ] 返回 true。

PS:SUID 是 Set User ID, SGID 是 Set Group ID的意思。设置了suid的程序文件,在用户执行该程序时,用户的权限是该程序文件属主的权限。例如程序文件的属主是root，那么执行该程序的用户就将暂时获得root账户的权限。sgid与suid类似，只是执行程序时获得的是文件属组的权限。

<!-- more -->
## 算术运算符

原生bash不支持简单的数学运算，但是可以通过其他命令来实现，例如 awk 和 expr，expr 最常用。
expr 是一款表达式计算工具，使用它能完成表达式的求值操作。
例如，两个数相加(注意使用的是反引号 ` 而不是单引号 ‘)：
```js 
#!/bin/bash
val=`expr 2 + 2`
echo "两数之和为 : $val"
```

PS：表达式和运算符之间要有空格，例如 2+2 是不对的，必须写成 2 + 2，这与我们熟悉的大多数编程语言不一样。

运算符 说明 举例 + 加法 
```js 
expr $a + $b
```
结果为 30。 - 减法 
```js 
expr $a - $b
```
结果为 -10。 /* 乘法 
```js 
expr $a \* $b
```
结果为 200。 / 除法 
```js 
expr $b / $a
```
结果为 2。 % 取余 
```js 
expr $b % $a
```
结果为 0。 = 赋值 a=$b 将把变量 b 的值赋给 a。 == 相等 用于比较两个数字，相同则返回 true。 [ a==b ] 返回 false。 != 不相等 用于比较两个数字，不相同则返回 true。 [ a!=b ] 返回 true。

注意：条件表达式要放在方括号之间，并且要有空格，例如: [a==b] 是错误的，必须写成 [ a==b ]。

## 关系运算符

关系运算符只支持数字，不支持字符串，除非字符串的值是数字。

下表列出了常用的关系运算符，假定变量 a 为 10，变量 b 为 20：
运算符 说明 举例 -eq 检测两个数是否相等，相等返回 true。 [ a−eqb ] 返回 false。 -gt 检测左边的数是否大于右边的，如果是，则返回 true。 [ a−gtb ] 返回 false。 -ge 检测左边的数是否大于等于右边的，如果是，则返回 true。 [ a−geb ] 返回 false。

## 布尔运算符

下表列出了常用的布尔运算符，假定变量 a 为 10，变量 b 为 20：
运算符 说明 举例 ! 非运算，表达式为 true 则返回 false，否则返回 true。 [ ! false ] 返回 true。 -o 或运算，有一个表达式为 true 则返回 true。 [ a−lt20−ob -gt 100 ] 返回 true。 -a 与运算，两个表达式都为 true 才返回 true。 [ a−lt20−ab -gt 100 ] 返回 false。

## 逻辑运算符

以下介绍 Shell 的逻辑运算符，假定变量 a 为 10，变量 b 为 20:
运算符 说明 举例 && 逻辑的 AND [[ $a -lt 100 && $b -gt 100 ]] 返回 false || 逻辑的 OR [[ $a -lt 100 || $b -gt 100 ]] 返回 true

## 字符串运算符

下表列出了常用的字符串运算符，假定变量 a 为 “abc”，变量 b 为 “efg”：
运算符 说明 举例 = 检测两个字符串是否相等，相等返回 true。 [ $a = $b ] 返回 false。 != 检测两个字符串是否相等，不相等返回 true。 [ $a != $b ] 返回 true。 -z 检测字符串长度是否为0，为0返回 true。 [ -z $a ] 返回 false。 str 检测字符串是否为空，不为空返回 true。 [ $a ] 返回 true。

# shell流程控制

## if句法

```js 
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```

## for句法

```js 
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

## while句法

```js 
while condition
do
    command
done
```

break和continue适用于for和while循环。

# Shell 函数

shell中函数的定义格式如下：
```js 
[ function ] funname [()]
{
    command
    [return int]
}
```

实例：

```js 
funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
```

# Shell 输入/输出重定向

扫盲：在Linux系统的世界观里几乎视一切为文件。对于目录、设备的操作也可以完全等同于对纯文本文件的操作。。。
文件描述符是一些小数值，你可以通过它们访问的打开的文件设备，而有多少文件描述符可用取决于系统的配置情况。但是当一个程序开始运行时，它一般会有3个已经打开的文件描述符，就是
0：标准输入
1：标准输出
2：标准错误
那些数学（即0、1、2）就是文件描述符，因为在Linux上一切都是文件，所以标准输入（stdin），标准输出（stdout）和标准错误（stderr）也可看作文件来对待。
关于输入输出重定向深入浅出的文章： [输入输出重定向详解](http://blog.chinaunix.net/uid-26495963-id-3067275.html)

## 重定向命令列表如下

命令 说明 command > file 将输出重定向到 file。 command < file 将输入重定向到 file。 command >> file 将输出以追加的方式重定向到 file。 n > file 将文件描述符为 n 的文件重定向到 file。 n >> file 将文件描述符为 n 的文件以追加的方式重定向到 file。 n >& m 将输出文件 m 和 n 合并。 n <& m 将输入文件 m 和 n 合并。 << tag 将开始标记 tag 和结束标记 tag 之间的内容作为输入。

## 重定向深入讲解

一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：
```js 
标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。
```

默认情况下，command > file 将 stdout 重定向到 file，command < file 将stdin 重定向到 file。

如果希望 stderr 重定向到 file，可以这样写：
```js 
$ command 2 > file
```

如果希望 stderr 追加到 file 文件末尾，可以这样写：

```js 
$ command 2 >> file
```

2 表示标准错误文件(stderr)。

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：
```js 
$ command > file 2>&1
```

或者

```js 
$ command >> file 2>&1
```

如果希望对 stdin 和 stdout 都重定向，可以这样写：

```js 
$ command < file1 >file2
```

command 命令将 stdin 重定向到 file1，将 stdout 重定向到 file2。

## /dev/null 文件

如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null：
```js 
$ command > /dev/null
```

/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到。但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到”禁止输出”的效果。

如果希望屏蔽 stdout 和 stderr，可以这样写：
```js 
$ command > /dev/null 2>&1
```

# Shell 文件引用

和其他语言一样，Shell 也可以包含外部脚本。这样可以很方便的封装一些公用的代码作为一个独立的文件。
Shell 文件包含的语法格式如下：
```js 
. filename   # 注意点号(.)和文件名中间有一空格
或
source filename
```

实例：

```js 
#使用 . 号来引用test1.sh 文件
. ./test1.sh
# 或者使用以下包含文件代码
# source ./test1.sh
echo "地址：$url"
```

以上内容引用自：[菜鸟教程官网地址](http://www.runoob.com)

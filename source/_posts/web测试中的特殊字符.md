---
title: web测试中的特殊字符
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-02-23 21:09:28
---
# JavaScript 特殊字符

需要被转义才能显示正确，转义是斜线。
\’ 单引号
\” 双引号
\& 和号
\ 反斜杠
\n 换行符
\r 回车符
\t 制表符
\b 退格符
\f 换页符

# HTML需要转义的字符

[转义对照表](http://www.jb51.net/onlineread/htmlchar.htm)

# 数据库特殊字符：

_ (下划线) : Oracle中代表占位符
表示查找含_的字符串。
%（百分号）表示查找含%的字符串。
‘(单引号)：表示查找含’的字符串
/#井号表示查找含/#的字符串
通配符，和需求相关。如果/*和?当作通配符处理，则不需要数据库开发人员特殊处理。如果当作其本身这个字符，则需要处理。所以需要测试是否已经做了正确的处理。
/*（星号）：代表通配任意多个字符或数字进行查询
?（问号）：代表通配1个字符或数字进行查询

下面是我python一个提供特殊字符的方法：
```js 
def random_special_charactor():
    sep_charactor =['\'','\"','&','\\','\n','\r','\t','\b','\f','\<','\>',
                    '<br/>','`','@','$','*','^','#','?','_','&&']
 #16进制
    sep_charactor_0x = str(bytes([0x60,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2a,0x2b,0x2c,0x2d,
                        0x2e,0x2f,0x3c,0x3e,0x3f,0x40,0x5b,0x5c,0x5d,0x5e,0x5f,0x7b,0x7c,0x7d,0x7e,0x60]))
    return ''.join(random.sample(sep_charactor_0x,5))
```
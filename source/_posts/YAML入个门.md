---
title: YAML入个门
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 测试的框架和技术

date: 2018-01-03 23:21:28
---
拷贝自：[http://www.ruanyifeng.com/blog/2016/07/yaml.html](http://www.ruanyifeng.com/blog/2016/07/yaml.html)

YAML 是专门用来写配置文件的语言，非常简洁和强大，远比 JSON 格式方便。

本文介绍 YAML 的语法，以 [JS-YAML](https://github.com/nodeca/js-yaml) 的实现为例。你可以去[在线 Demo](http://nodeca.github.io/js-yaml/) 验证下面的例子。

![](/images/ng.com-blogimg-asset-2016-bg2016070403-.png)

## 一、简介

YAML 语言（发音 /ˈjæməl/ ）的设计目标，就是方便人类读写。它实质上是一种通用的数据串行化格式。

它的基本语法规则如下。

```js 
#
```
表示注释，从这个字符一直到行尾，都会被解析器忽略。

YAML 支持的数据结构有三种。

以下分别介绍这三种数据结构。

## 二、对象

对象的一组键值对，使用冒号结构表示。
```js 
animal: pets
```

转为 JavaScript 如下。

```js 
{ animal: 'pets' }
```

Yaml 也允许另一种写法，将所有键值对写成一个行内对象。
<!-- more -->

```js 
hash: { name: Steve, foo: bar }
```

转为 JavaScript 如下。

```js 
{ hash: { name: 'Steve', foo: 'bar' } }
```

## 三、数组

一组连词线开头的行，构成一个数组。
```js 
- Cat
- Dog
- Goldfish
```

转为 JavaScript 如下。

```js 
[ 'Cat', 'Dog', 'Goldfish' ]
```

数据结构的子成员是一个数组，则可以在该项下面缩进一个空格。

```js 
-
 - Cat
 - Dog
 - Goldfish
```

转为 JavaScript 如下。

```js 
[ [ 'Cat', 'Dog', 'Goldfish' ] ]
```

数组也可以采用行内表示法。

```js 
animal: [Cat, Dog]
```

转为 JavaScript 如下。

```js 
{ animal: [ 'Cat', 'Dog' ] }
```

## 四、复合结构

对象和数组可以结合使用，形成复合结构。
```js 
languages:
 - Ruby
 - Perl
 - Python 
websites:
 YAML: yaml.org 
 Ruby: ruby-lang.org 
 Python: python.org 
 Perl: use.perl.org
```

转为 JavaScript 如下。

```js 
{ languages: [ 'Ruby', 'Perl', 'Python' ],
  websites: 
   { YAML: 'yaml.org',
     Ruby: 'ruby-lang.org',
     Python: 'python.org',
     Perl: 'use.perl.org' } }
```

## 五、纯量

纯量是最基本的、不可再分的值。以下数据类型都属于 JavaScript 的纯量。

数值直接以字面量的形式表示。
```js 
number: 12.30
```

转为 JavaScript 如下。

```js 
{ number: 12.30 }
```

布尔值用

```js 
true
```
和

```js 
false
```
表示。

```js 
isSet: true
```

转为 JavaScript 如下。

```js 
{ isSet: true }
```

```js 
null
```
用

```js 
~
```
表示。

```js 
parent: ~
```

转为 JavaScript 如下。

```js 
{ parent: null }
```

时间采用 ISO8601 格式。

```js 
iso8601: 2001-12-14t21:59:43.10-05:00
```

转为 JavaScript 如下。

```js 
{ iso8601: new Date('2001-12-14t21:59:43.10-05:00') }
```

日期采用复合 iso8601 格式的年、月、日表示。

```js 
date: 1976-07-31
```

转为 JavaScript 如下。

```js 
{ date: new Date('1976-07-31') }
```

YAML 允许使用两个感叹号，强制转换数据类型。

```js 
e: !!str 123
f: !!str true
```

转为 JavaScript 如下。

```js 
{ e: '123', f: 'true' }
```

## 六、字符串

字符串是最常见，也是最复杂的一种数据类型。

字符串默认不使用引号表示。
```js 
str: 这是一行字符串
```

转为 JavaScript 如下。

```js 
{ str: '这是一行字符串' }
```

如果字符串之中包含空格或特殊字符，需要放在引号之中。

```js 
str: '内容： 字符串'
```

转为 JavaScript 如下。

```js 
{ str: '内容: 字符串' }
```

单引号和双引号都可以使用，双引号不会对特殊字符转义。

```js 
s1: '内容\n字符串'
s2: "内容\n字符串"
```

转为 JavaScript 如下。

```js 
{ s1: '内容\\n字符串', s2: '内容\n字符串' }
```

单引号之中如果还有单引号，必须连续使用两个单引号转义。

```js 
str: 'labor''s day'
```

转为 JavaScript 如下。

```js 
{ str: 'labor\'s day' }
```

字符串可以写成多行，从第二行开始，必须有一个单空格缩进。换行符会被转为空格。

```js 
str: 这是一段
  多行
  字符串
```

转为 JavaScript 如下。

```js 
{ str: '这是一段 多行 字符串' }
```

多行字符串可以使用

```js 
|
```
保留换行符，也可以使用

```js 
>
```
折叠换行。

```js 
this: |
  Foo
  Bar
that: >
  Foo
  Bar
```

转为 JavaScript 代码如下。

```js 
{ this: 'Foo\nBar\n', that: 'Foo Bar\n' }
```

```js 
+
```
表示保留文字块末尾的换行，

```js 
-
```
表示删除字符串末尾的换行。

```js 
s1: |
  Foo

s2: |+
  Foo


s3: |-
  Foo
```

转为 JavaScript 代码如下。

```js 
{ s1: 'Foo\n', s2: 'Foo\n\n\n', s3: 'Foo' }
```

字符串之中可以插入 HTML 标记。

```js 
message: |

  <p style="color: red">
    段落
  </p>
```

转为 JavaScript 如下。

```js 
{ message: '\n<p style="color: red">\n  段落\n</p>\n' }
```

## 七、引用

锚点

```js 
&
```
和别名

```js 
*
```
，可以用来引用。
```js 
defaults: &defaults
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  <<: *defaults

test:
  database: myapp_test
  <<: *defaults
```

等同于下面的代码。

```js 
defaults:
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  adapter:  postgres
  host:     localhost

test:
  database: myapp_test
  adapter:  postgres
  host:     localhost
```

```js 
&
```
用来建立锚点（

```js 
defaults
```
），

```js 
<<
```
表示合并到当前数据，

```js 
*
```
用来引用锚点。

下面是另一个例子。
```js 
- &showell Steve 
- Clark 
- Brian 
- Oren 
- *showell
```

转为 JavaScript 代码如下。

```js 
[ 'Steve', 'Clark', 'Brian', 'Oren', 'Steve' ]
```

## 八、函数和正则表达式的转换

这是 [JS-YAML](https://github.com/nodeca/js-yaml) 库特有的功能，可以把函数和正则表达式转为字符串。
```js 

```
 /# example .yml fn : function ( ) { return 1 } reg : /test/

解析上面的 yml 文件的代码如下。

```js 
var yaml = require('js-yaml');
var fs   = require('fs');

try {
  var doc = yaml.load(
    fs.readFileSync('./example.yml', 'utf8')
  );
  console.log(doc);
} catch (e) {
  console.log(e);
}
```

从 JavaScript 对象还原到 yaml 文件的代码如下。

```js 
var yaml = require('js-yaml');
var fs   = require('fs');

var obj = {
  fn: function () { return 1 },
  reg: /test/
};

try {
  fs.writeFileSync(
    './example.yml',
    yaml.dump(obj),
    'utf8'
  );
} catch (e) {
  console.log(e);
}
```

## 九、参考链接

* [YAML 1.2 规格](http://www.yaml.org/spec/1.2/spec.html)
* [YAML from Wikipedia](https://en.wikipedia.org/wiki/YAML)
* [YAML for Ruby](http://yaml.org/YAML_for_ruby.html)

（完）

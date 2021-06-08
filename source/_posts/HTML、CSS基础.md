---
title: HTML、CSS基础
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 前端框架和技术

date: 2017-02-12 14:15:48
---
本文是使用splinter过程中，遇到阻碍（主要是动态样式导致element not visiable）,而推演出来的基础学习内容。以下内容早在2013年左右就看过，全当复习总结重新来一次，所以html常用的如标题、段落、链接、图像、表格等没有列入。本问内容全部来自：[http://www.w3school.com.cn](http://www.w3school.com.cn) 感谢无私的网站提供的基础学习内容。

# HTML基础概念

什么是 HTML？

HTML 是用来描述网页的一种语言。
```js 
HTML 指的是超文本标记语言 (Hyper Text Markup Language)
HTML 不是一种编程语言，而是一种标记语言 (markup language)
标记语言是一套标记标签 (markup tag)
HTML 使用标记标签来描述网页
```

HTML 标签

HTML 标记标签通常被称为 HTML 标签 (HTML tag)。
```js 
HTML 标签是由尖括号包围的关键词，比如 <html>
HTML 标签通常是成对出现的，比如 <b> 和 </b>
标签对中的第一个标签是开始标签，第二个标签是结束标签
开始和结束标签也被称为开放标签和闭合标签
```

所有标签：[http://www.w3school.com.cn/tags/index.asp](http://www.w3school.com.cn/tags/index.asp)

HTML 文档 = 网页
```js 
HTML 文档描述网页
HTML 文档包含 HTML 标签和纯文本
HTML 文档也被称为网页
```

HTML 元素

HTML 元素指的是从开始标签（start tag）到结束标签（end tag）的所有代码。
开始标签 元素内容 结束标签
<!-- more -->
```js 
<p>     This is a paragraph     </p>
<a href="default.htm" >     This is a link  </a>
<br />
```

注释：开始标签常被称为开放标签（opening tag），结束标签常称为闭合标签（closing tag）。

HTML 元素语法
```js 
HTML 元素以开始标签起始
HTML 元素以结束标签终止
元素的内容是开始标签与结束标签之间的内容
某些 HTML 元素具有空内容（empty content）
空元素在开始标签中进行关闭（以开始标签的结束而结束）
大多数 HTML 元素可拥有属性
```

HTML 属性

**HTML 标签可以拥有属性。**属性提供了有关 HTML 元素的更多的信息。

属性总是以名称/值对的形式出现，比如：name=”value”。

属性总是在 HTML 元素的开始标签中规定。新版推荐使用小写属性。属性值应该始终被包括在引号内。双引号是最常用的，不过使用单引号也没有问题。
```js 
<a href="http://www.w3school.com.cn">This is a link</a>
```

常用属性：

属性 值 描述 class classname 规定元素的类名（classname），样式选择器定义样式 id id 规定元素的唯一 id style style_definition 规定元素的行内样式（inline style） title text 规定元素的额外信息（可在工具提示中显示）

# HTML CSS

## 如何使用样式

当浏览器读到一个样式表，它就会按照这个样式表来对文档进行格式化。有以下三种方式来插入样式表：

当样式需要被应用到很多页面的时候，外部样式表将是理想的选择。使用外部样式表，你就可以通过更改一个文件来改变整个站点的外观。
```js 
<head>
<link rel="stylesheet" type="text/css" href="mystyle.css">
</head>
```

当单个文件需要特别样式时，就可以使用内部样式表。你可以在 head 部分通过
```js 
<head>
<style type="text/css">
body {background-color: red}
p {margin-left: 20px}
</style>
</head>
```

当特殊的样式需要应用到个别元素时，就可以使用内联样式。 使用内联样式的方法是在相关的标签中使用样式属性。样式属性可以包含任何 CSS 属性。以下实例显示出如何改变段落的颜色和左外边距。
```js 
<p style="color: red; margin-left: 20px">
This is a paragraph
</p>
```
 标签 描述 <style> 定义样式定义。 <link> 定义资源引用。 <div> 定义文档中的节或区域（块级） <span> 定义文档中的行内的小块或区域。

## CSS基本语法

CSS 规则由两个主要的部分构成：选择器，以及一条或多条声明。
```js 
selector {declaration1; declaration2; ... declarationN }
```

选择器通常是您需要改变样式的 HTML 元素。

每条声明由一个属性和一个值组成。

属性（property）是您希望设置的样式属性（style attribute）。每个属性有一个值。属性和值被冒号分开。
```js 
selector {property: value}
```

下面这行代码的作用是将 h1 元素内的文字颜色定义为红色，同时将字体大小设置为 14 像素。

在这个例子中，h1 是选择器，color 和 font-size 是属性，red 和 14px 是值。
```js 
h1 {color:red; font-size:14px;}
```

下面的示意图为您展示了上面这段代码的结构：

![这里写图片描述](/images/.com.cn-i-ct_css_selector.gif.png)

## CSS样式四剑客

通过依据元素在其位置的上下文关系来定义样式，你可以使标记更加简洁。

在 CSS1 中，通过这种方式来应用规则的选择器被称为上下文选择器 (contextual selectors)，这是由于它们依赖于上下文关系来应用或者避免某项规则。在 CSS2 中，它们称为派生选择器，但是无论你如何称呼它们，它们的作用都是相同的。

派生选择器允许你根据文档的上下文关系来确定某个标签的样式。通过合理地使用派生选择器，我们可以使 HTML 代码变得更加整洁。

比方说，你希望列表中的 strong 元素变为斜体字，而不是通常的粗体字，可以这样定义一个派生选择器：
```js 
li strong {
    font-style: italic;
    font-weight: normal;
  }
```

请注意标记为<strong> 的蓝色代码的上下文关系：

```js 
<p><strong>我是粗体字，不是斜体字，因为我不在列表当中，所以这个规则对我不起作用</strong></p>

<ol>
<li><strong>我是斜体字。这是因为 strong 元素位于 li 元素内。</strong></li>
<li>我是正常的字体。</li>
</ol>
```

id 选择器可以为标有特定 id 的 HTML 元素指定特定的样式。

id 选择器以 “/#” 来定义。

下面的两个 id 选择器，第一个可以定义元素的颜色为红色，第二个定义元素的颜色为绿色：
```js 
#red {color:red;}
#green {color:green;}
```

下面的 HTML 代码中，id 属性为 red 的 p 元素显示为红色，而 id 属性为 green 的 p 元素显示为绿色。

这个段落是红色。

这个段落是绿色。

注意：id 属性只能在每个 HTML 文档中出现一次。

id 选择器和派生选择器

在现代布局中，id 选择器常常用于建立派生选择器。下面的样式只会应用于出现在 id 是 sidebar 的元素内的段落。
```js 
#sidebar p {
    font-style: italic;
    text-align: right;
    margin-top: 0.5em;
    }
```

在 CSS 中，类选择器以一个点号显示：
```js 
.center {text-align: center}
```

在上面的例子中，所有拥有 center 类的 HTML 元素均为居中。

在下面的 HTML 代码中，h1 和 p 元素都有 center 类。这意味着两者都将遵守 “.center” 选择器中的规则。
```js 
<h1 class="center">
This heading will be center-aligned
</h1>

<p class="center">
This paragraph will also be center-aligned.
</p>
```

注意：类名的第一个字符不能使用数字！它无法在 Mozilla 或 Firefox 中起作用。

和 id 一样，class 也可被用作派生选择器：
```js 
.fancy td {
    color: #f60;
    background: #666;
    }
```

在上面这个例子中，类名为 fancy 的更大的元素内部的表格单元都会以灰色背景显示橙色文字。（名为 fancy 的更大的元素可能是一个表格或者一个 div）

元素也可以基于它们的类而被选择：
```js 
td.fancy {
    color: #f60;
    background: #666;
    }
```

在上面的例子中，类名为 fancy 的表格单元将是带有灰色背景的橙色。

```js 
<td class="fancy">
```

你可以将类 fancy 分配给任何一个表格元素任意多的次数。那些以 fancy 标注的单元格都会是带有灰色背景的橙色。那些没有被分配名为 fancy 的类的单元格不会受这条规则的影响。还有一点值得注意，class 为 fancy 的段落也不会是带有灰色背景的橙色，当然，任何其他被标注为 fancy 的元素也不会受这条规则的影响。这都是由于我们书写这条规则的方式，这个效果被限制于被标注为 fancy 的表格单元（即使用 td 元素来选择 fancy 类）。

对带有指定属性的 HTML 元素设置样式。
可以为拥有指定属性的 HTML 元素设置样式，而不仅限于 class 和 id 属性。

注释：只有在规定了 !DOCTYPE 时，IE7 和 IE8 才支持属性选择器。在 IE6 及更低的版本中，不支持属性选择。
属性选择器

下面的例子为带有 title 属性的所有元素设置样式：
```js 
[title]
{
color:red;
}
```

属性和值选择器

下面的例子为 title=”W3School” 的所有元素设置样式：
```js 
[title=W3School]
{
border:5px solid blue;
}
```

下面的例子为带有包含指定值的 lang 属性的所有元素设置样式。适用于由连字符分隔的属性值：

```js 
[lang|=en] { color:red; }
```

**CSS 选择器参考手册**

选择器 描述 [attribute] 用于选取带有指定属性的元素。 [attribute=value] 用于选取带有指定属性和值的元素。 [attribute~=value] 用于选取属性值中包含指定词汇的元素。 [attribute=value] 用于选取带有以指定值开头的属性值的元素，该值必须是整个单词。 [attribute^=value] 匹配属性值以指定值开头的每个元素。 [attribute$=value] 匹配属性值以指定值结尾的每个元素。 [attribute/*=value] 匹配属性值中包含指定值的每个元素。

# [HTML 表单](http://www.w3school.com.cn/html/html_forms.asp)

**HTML 表单用于搜集不同类型的用户输入。**包含不同类型的 input 元素、复选框、单选按钮、提交按钮等等。
<form> 元素定义 HTML 表单：
实例
```js 
<form>
 .
form elements
 .
</form>
```

**<input> 元素**
<input> 元素是最重要的表单元素。
<input> 元素有很多形态，根据不同的 type 属性。

这是本章中使用的类型：
类型 描述 text 定义常规文本输入。 radio 定义单选按钮输入（选择多个选择之一） submit 定义提交按钮（提交表单）

**文本输入**

<input type=”text”> 定义用于文本输入的单行输入字段：
实例
```js 
<form>
 First name:<br>
<input type="text" name="firstname">
<br>
 Last name:<br>
<input type="text" name="lastname">
</form>
```

注释：表单本身并不可见。还要注意文本字段的默认宽度是 20 个字符。

**单选按钮输入**

定义单选按钮。

单选按钮允许用户在有限数量的选项中选择其中之一：
实例
```js 
<form>
<input type="radio" name="sex" value="male" checked>Male
<br>
<input type="radio" name="sex" value="female">Female
</form>
```

**提交按钮**

<input type=”submit”> 定义用于向表单处理程序（form-handler）提交表单的按钮。

表单处理程序通常是包含用来处理输入数据的脚本的服务器页面。

表单处理程序在表单的 action 属性中指定：
实例
```js 
<form action="action_page.php">
First name:<br>
<input type="text" name="firstname" value="Mickey">
<br>
Last name:<br>
<input type="text" name="lastname" value="Mouse">
<br><br>
<input type="submit" value="Submit">
</form>
```

**Action 属性**

action 属性定义在提交表单时执行的动作。

向服务器提交表单的通常做法是使用提交按钮。

通常，表单会被提交到 web 服务器上的网页。

在上面的例子中，指定了某个服务器脚本来处理被提交表单：
```js 
<form action="action_page.php">
```

如果省略 action 属性，则 action 会被设置为当前页面。

**Method 属性**

method 属性规定在提交表单时所用的 HTTP 方法（GET 或 POST）：
```js 
<form action="action_page.php" method="GET">
```

或：

```js 
<form action="action_page.php" method="POST">
```

何时使用 GET？

您能够使用 GET（默认方法）：

如果表单提交是被动的（比如搜索引擎查询），并且没有敏感信息。

当您使用 GET 时，表单数据在页面地址栏中是可见的：
```js 
action_page.php?firstname=Mickey&lastname=Mouse
```

注释：GET 最适合少量数据的提交。浏览器会设定容量限制。
何时使用 POST？

您应该使用 POST：

如果表单正在更新数据，或者包含敏感信息（例如密码）。

POST 的安全性更加，因为在页面地址栏中被提交的数据是不可见的。

**Name 属性**

如果要正确地被提交，每个输入字段必须设置一个 name 属性。

本例只会提交 “Last name” 输入字段：
实例
```js 
<form action="action_page.php">
First name:<br>
<input type="text" value="Mickey">
<br>
Last name:<br>
<input type="text" name="lastname" value="Mouse">
<br><br>
<input type="submit" value="Submit">
</form>
```

用<fieldset> 组合表单数据

<fieldset> 元素组合表单中的相关数据

元素为 元素定义标题。
实例
```js 
<form action="action_page.php">
<fieldset>
<legend>Personal information:</legend>
First name:<br>
<input type="text" name="firstname" value="Mickey">
<br>
Last name:<br>
<input type="text" name="lastname" value="Mouse">
<br><br>
<input type="submit" value="Submit"></fieldset>
</form>
```

HTML 元素，已设置所有可能的属性，是这样的：
实例

```js 
<form action="action_page.php" method="GET" target="_blank" accept-charset="UTF-8"
ectype="application/x-www-form-urlencoded" autocomplete="off" novalidate>
.
form elements
 .
</form>
```

Here is the list of <form> attributes:

属性 描述 accept-charset 规定在被提交表单中使用的字符集（默认：页面字符集）。 action 规定向何处提交表单的地址（URL）（提交页面）。 autocomplete 规定浏览器应该自动完成表单（默认：开启）。 enctype 规定被提交数据的编码（默认：url-encoded）。 method 规定在提交表单时所用的 HTTP 方法（默认：GET）。 name 规定识别表单的名称（对于 DOM 使用：document.forms.name）。 novalidate 规定浏览器不验证表单。 target 规定 action 属性中地址的目标（默认：_self）。

# HTML其他

## 元素的容器

“块级元素”译为 block level element，“内联元素”译为 inline element。
块级元素在浏览器显示时，通常会以新行来开始（和结束）。
例子：<h1>, <p>, <ul>, <table>
内联元素在显示时通常不会以新行开始。
例子：<b>,<td>, <a>, <img>

HTML<div> 元素
HTML<div> 元素是块级元素，它是可用于组合其他 HTML 元素的容器。
<div> 元素没有特定的含义。除此之外，由于它属于块级元素，浏览器会在其前后显示折行。
如果与 CSS 一同使用，<div> 元素可用于对大的内容块设置样式属性。
<div> 元素的另一个常见的用途是文档布局。它取代了使用表格定义布局的老式方法。使用 <table> 元素进行文档布局不是表格的正确用法。<table> 元素的作用是显示表格化的数据。

HTML <span> 元素
HTML <span> 元素是内联元素，可用作文本的容器。
<span> 元素也没有特定的含义。
当与 CSS 一同使用时，<span> 元素可用于为部分文本设置样式属性。

## HTML 脚本

<script> 标签用于定义客户端脚本，比如 JavaScript。

script 元素既可包含脚本语句，也可通过 src 属性指向外部脚本文件。

必需的 type 属性规定脚本的 MIME 类型。

JavaScript 最常用于图片操作、表单验证以及内容动态更新。

下面的脚本会向浏览器输出“Hello World!”：
```js 
<script type="text/javascript">
document.write("Hello World!")
</script>
```

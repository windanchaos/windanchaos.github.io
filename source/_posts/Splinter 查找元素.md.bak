---
title: Splinter 查找元素
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-01-22 16:29:08
---
## 通常的查找元素方法

```js 
browser.find_by_css('h1')
browser.find_by_xpath('//h1')
browser.find_by_tag('h1')
browser.find_by_name('name')
browser.find_by_text('Hello World!')
browser.find_by_id('firstheader')
browser.find_by_value('query')
```

方法返回的结果是一个list，通过以下方法可以返回第一个、最后一个或指定位置的元素。

```js 
first_found = browser.find_by_name('name').first
last_found = browser.find_by_name('name').last
second_found = browser.find_by_name('name')[1]
```

## All elements and find_by_id

A web page should have only one id, so the find_by_id method returns always a list with just one element.

## Finding links

If you need to find the links in a page, you can use the methods find_link_by_text, find_link_by_partial_text, find_link_by_href or find_link_by_partial_href. Examples:
```js 
links_found = browser.find_link_by_text('Link for Example.com')
links_found = browser.find_link_by_partial_text('for Example')
links_found = browser.find_link_by_href('http://example.com')
links_found = browser.find_link_by_partial_href('example')
```

As the other find_/* methods, these returns a list of all found elements.
You also can search for links using other selector types with the methods find_by_css, find_by_xpath, find_by_tag, find_by_name, find_by_value and find_by_id.

<!-- more -->
## 链式查询元素

Finding methods are chainable, so you can find the descendants of a previously found element.
find的方法是链式的，所以可以在找到一个元素之后，继续在这个元素内部查找你所要找的元素
```js 
divs = browser.find_by_tag("div")
within_elements = divs.first.find_by_name("name")
```

## ElementDoesNotExist exception

If an element is not found, the find_/* methods return an empty list. But if you try to access an element in this list, the method will raise the splinter.exceptions.ElementDoesNotExist exception.

---
title: 测试测mysql语句的性能——explain ，Mysql查询优化器的使用
author: windanchaos
tags: 
       - FromCSDN

category: 
       - MySQL数据库

date: 2017-12-14 20:07:49
---
MySQL 查询优化器有几个目标，但是其中最主要的目标是尽可能地使用索引，并且使用最严格的索引来消除尽可能多的数据行。最终目标是提交 SELECT 语句查找数据行，而不是排除数据行。优化器试图排除数据行的原因在于它排除数据行的速度越快，那么找到与条件匹配的数据行也就越快。如果能够首先进行最严格的测试，查询就可以执行地更快。
**MySql 深化学习**

# 1 **explain用法**

explain可以帮助我们分析select语句，**找出select语句的瓶颈**，从而可以针对性地去做优化，让MySQL查询优化器更好地工作。

MySQL查询优化器有几个目标，其中**最主要的目标是尽可能地使用索引，并且使用最严格的索引来消除尽可能多的数据行**。

使用explain+select语句，会返回以下的一个表，截图使用的navicat的工具截图：

![](http://image.windanchaos.tech/blog/dn.net-20171214200235222-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)

下面对上述表的每一列进行说明：

## 1.1 **id列**

说明：MySQL Query Optimizer 选定的执行计划中查 询的序列号。表示查询中执行 **select 子句或 操作表的顺序，id 值越大优先级越高，越先 被执行。id 相同，执行顺序由上至下。**

## 1.2 **select_type列**

select_type查询类型
 
说明 **SIMPLE**
 
**简单的select查询，不使用union及子查询** **PRIMARY**
 
**最外层的select查询** UNION
 
UNION中的第二个或随后的select查询，不依赖外部查询的结果集 DEPENDENT UNION
 
UNION 中的第二个或随后的 select 查询，依赖于外部查询的结果集 UNION RESULT
 
UNION 查询的结果集 SUBQUERY
 
子查询中的第一个 select 查询，不依赖于外部查询的结果集 DEPENDENT SUBQUERY
 
<!-- more -->
子查询中的第一个 select 查询，依赖于外部 查询的结果集 **DERIVED**
 
**用于 from 子句里有子查询的情况。MySQL 会 递归执行这些子查询，把结果放在临时表里。** UNCACHEABLE SUBQUERY
 
结果集不能被缓存的子查询，必须重新为外 层查询的每一行进行评估 UNCACHEABLE UNION
 
UNION 中的第二个或随后的 select 查询，属 于不可缓存的子查询

## 1.3 **TABLE列**

说明：输出行所引用的表。

## 1.4**TYPE**

说明：**很重要的列之一，显示连接使用的类型，按最优到最差的类型排序。**
TYPE
 
**说明** **system**
 
表仅有一行(=系统表)。这是 const 连接类型 的一个特例。 **const**
 
const 用于用常数值比较 PRIMARY KEY 时。当 查询的表仅有一行时，使用 System。 **eq_ref**
 
除 const 类型外**最好的可能实现的连接类型**。它用在一个索引的所有部分被连接使用并且索引是 UNIQUE 或 PRIMARY KEY，对于每个索引键，表中只有一条记录与之匹配。 ref
 
连接不能基于关键字选择单个行，可能查找到多个符合条件的行。叫做 ref 是因为索引要跟某个参考值相比较。这个参考值或者是一个常数，或者是来自一个表里的多表查询的

结果值。 ref_or_null
 
如同 ref，但是 MySQL 必须在初次查找的结果

里找出 null 条目，然后进行二次查找。 index_merge
 
说明索引合并优化被使用了。 unique_subquery
 
在某些IN查询中使用此种类型，而不是常规的ref index_subquery
 
在某些IN查询中使用此种类型，与unique_subquery类似，但是查询的是非唯一性索引。 range
 
只检索给定范围的行，使用一个索引来选择行。key列显示使用了哪个索引。 **index**
 
**全表扫描，只是扫描表的时候按照索引次序进行而不是行。主要优点是避免了排序，但是开销仍然非常大。** **all**
 
**最坏的情况，从头到尾全表扫描。**

****

## 1.5 **possible_keys**

说明：指出Mysql能在该表中使用哪些索引有助于查询。如果为空，说明没有可用的索引。

## 1.6 **key_len**

说明：使用的索引的长度，在不损失精确性的情况下，长度越短越好。

## 1.7 **ref**

说明：显示索引的那一列被使用了。

## 1.8 **rows**

说明：Mysql认为必须检查的用来返回请求数据的行数。

## 1.9 **extra**

Using filesort
 
表示MySQL会对结果使用一个外部索引排序，而不是从表里按索引次序读到相关内容。 Using Temporary
 
表示MySQL在对查询结果排序时使用临时表，常见于排序order by和分组查询group by.

至于如何去获取到业务流程中的sql语句，这就需要结合自己公司的实际情况了。
我们公司的日志是使用log4j，开启debug模式，每一个操作都会把日志打印出来，包括mysql。对核心可能存在并发的地方。逐一去排查还是有点作用的。

实操一个：
下图是我在某业务日志中捕获的（所谓捕获，就是不断的check）
![这里写图片描述](http://image.windanchaos.tech/blog/dn.net-20171215113203697-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)

在当前数据规模下查0.053s。但是如果数据规模一大，这个效率肯定是不行的。
我去看了下的索引，order_id没有索引。所以，让研发加了一个order_id 索引。解决问题。

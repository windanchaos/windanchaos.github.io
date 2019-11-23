---
title: python队列在Queue，Collection 的基础
author: windanchaos
tags: 
       - FromCSDN

category: 
       - python编程语言

date: 2017-08-10 07:26:38
---
以下内容分别来自：
[http://www.cnblogs.com/itogo/p/5635629.html](http://www.cnblogs.com/itogo/p/5635629.html)
[http://blog.csdn.net/u010504064/article/details/71173041](http://blog.csdn.net/u010504064/article/details/71173041)

Queue是python标准库中的线程安全的队列（FIFO）实现,提供了一个适用于多线程编程的先进先出的数据结构，即队列，用来在生产者和消费者线程之间的信息传递

## 基本FIFO队列

**class Queue.Queue(maxsize=0)**

FIFO即First in First Out,先进先出。Queue提供了一个基本的FIFO容器，使用方法很简单,maxsize是个整数，指明了队列中能存放的数据个数的上限。一旦达到上限，插入会导致阻塞，直到队列中的数据被消费掉。如果maxsize小于或者等于0，队列大小没有限制。

举个栗子：
```js 
import Queue

q = Queue.Queue()

for i in range(5):
    q.put(i)

while not q.empty():
    print q.get()
```

输出：

```js 
0
1
2
3
4
```

## LIFO队列

**class Queue.LifoQueue(maxsize=0)**

LIFO即Last in First Out,后进先出。与栈的类似，使用也很简单,maxsize用法同上

再举个栗子：
```js 
import Queue

q = Queue.LifoQueue()

for i in range(5):
    q.put(i)

while not q.empty():
    print q.get()
```

输出：

```js 
4
3
2
1
0
```

可以看到仅仅是将

```js 
Queue.Quenu类
```
替换为

```js 
Queue.LifiQueue类
```

## 优先级队列

**class Queue.PriorityQueue(maxsize=0)**

构造一个优先队列。maxsize用法同上。
```js 
import Queue
import threading

class Job(object):
    def __init__(self, priority, description):
        self.priority = priority
        self.description = description
        print 'Job:',description
        return
    def __cmp__(self, other):
        return cmp(self.priority, other.priority)

q = Queue.PriorityQueue()

q.put(Job(3, 'level 3 job'))
q.put(Job(10, 'level 10 job'))
q.put(Job(1, 'level 1 job'))

def process_job(q):
    while True:
        next_job = q.get()
        print 'for:', next_job.description
        q.task_done()

workers = [threading.Thread(target=process_job, args=(q,)),
        threading.Thread(target=process_job, args=(q,))
        ]

for w in workers:
    w.setDaemon(True)
    w.start()

q.join()
```

结果

```js 
Job: level 3 job
Job: level 10 job
Job: level 1 job
for: level 1 job
for: level 3 job
for: job: level 10 job
```

## 一些常用方法

意味着之前入队的一个任务已经完成。由队列的消费者线程调用。每一个get()调用得到一个任务，接下来的task_done()调用告诉队列该任务已经处理完毕。

如果当前一个join()正在阻塞，它将在队列中的所有任务都处理完时恢复执行（即每一个由put()调用入队的任务都有一个对应的task_done()调用）。

阻塞调用线程，直到队列中的所有任务被处理掉。

只要有数据被加入队列，未完成的任务数就会增加。当消费者线程调用task_done()（意味着有消费者取得任务并完成任务），未完成的任务数就会减少。当未完成的任务数降到0，join()解除阻塞。

将item放入队列中。

其非阻塞版本为

```js 
put_nowait
```
等同于

```js 
put(item, False)
```

从队列中移除并返回一个数据。block跟timeout参数同

```js 
put
```
方法

其非阻塞方法为｀get_nowait()｀相当与

```js 
get(False)
```

如果队列为空，返回True,反之返回False

＝＝＝＝＝＝＝＝＝＝＝＝这＝＝＝是＝＝＝分＝＝＝割＝＝＝线＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

# Cellection

```js 
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017-4-25 10:33
# @Author  : coderManFans
# @Site    : Python 高级数据结构模块
#            1.Python中的高级数据结构包括
#            Collections,Array,Heapq,Bisect,Weakref,Copy,Pprint
#            2.Collections模块包含了内建类型之外的一些有用的工具，如Counter,defaultdict,OrderDict
#              deque以及nametuple.其中Counter,deque以及defaultdict是最常用的类
#
# @File    : collectionsDemo.py
# @Software: PyCharm


#1.Collections

#1.1 Counter()
'''
Counter继承了dict类，其中seq为可迭代对象。接收seq,并以字典的形式返回seq
中每个元素（hashable）出现的次数

Counter的应用场景：
1.统计一个单词在给定序列中一共出现了多少次
2.统计给定序列中不同单词出现的次数

'''
from collections import Counter

list1 = ['a','b','c',23,23,'a','d','b','e']
counter1 = Counter(list1)
print(counter1)
print(counter1['a'])

#1.1.1统计不同单词的数目
print(len(set(list1)))

#1.1.2对统计结果进行分组 下面的方法表示分为4组，不填默认全部分组，以列表
#存储，里面元素是tuple对象
print(counter1.most_common(4))


#1.1.3 elements()获取Counter()生成对象的所有键名，重复的几个会全部打印
# 该方法返回一个迭代器对象
keylist = counter1.elements()
print(keylist)
print(list(keylist))

#1.1.4 update(x) 更新计数器 把x的内容加入到原来计数器中
#x可以作为字符串，列表，元组，集合，但是不能作为字典，纯数字，否则报错
list2 = ['a','d','f','q',2,3,2,3,4]
print(counter1)
counter1.update(list2)
print(counter1)

#1.1.5 substract(x) 更新计数器 把x代表的次数减少1，默认减少1,(通过字典形式指定一次减少的个数)
#，不存在则减为-1，依次减，作用与update()相反

counter1.subtract('a')
print(counter1)
counter1.subtract(['a','b',2])
print(counter1)




#1.2 Deque
'''
Deque是一种由队列结构扩展而来的双端队列（double-ended queue），队列元素
能够在队列两端添加或者删除。因此还被称为头尾连接列表（head-tail linked list）,当然还有另一个特殊的数据结构也实现了这个

Deque 支持线程安全的，经过优化的append和pop操作，在队列两端的相关操作都能够
达到近乎O(1)的时间复杂度。虽然list也支持类似的操作，但是它是
对定长列表的操作表现很不错，而当遇到pop(0)和insert(o,v)
这样既改变了列表的长度又改变其元素位置的操作时，其复杂度就变为O(n)了、

'''
from collections import deque

#1.2.1 定义一个双向队列（循环队列）
de1 = deque()
#默认往双向队列右边加入元素
de1.append('asdf')
print(de1)

#1.2.2 往双向队列左边加入一个元素
de1.appendleft('2323')
de1.appendleft(232324)
de1.appendleft('2323')
de1.appendleft(23)
de1.appendleft(23)
print(de1)

#1.2.3 返回指定元素在双向队列中的个数
count1 = de1.count(23)
print(count1)


#1.2.4 反转双向队列
print(de1)
de1.reverse()
print(de1)


#1.2.5 向双向队列中指定位置插入一个元素
de1.insert(2,'abced')
print(de1)


#1.2.6 用一个迭代器从右边扩展双向队列，相当于从右边批量插入
de1.extend(['a','adfasdf','asdf','asdfasd23'])
print(de1)


#1.2.7 用一个迭代器从左边扩展双向队列，相当于从左边批量插入
de1.extendleft(['2','3','2',22,';',23,233.002,23.22])
print(de1)


#1.2.8 返回从左到右遇到的第一个value的索引
index1 = de1.index('3')
print(index1)

#1.2.9 浅复制双向队列
de2 = de1.copy()
de3 = de2
de2.append('----asdfasdfa-sdf-asd-f')
print(de3)
print(de2)


#1.2.10 队列的左旋转，右旋转
#默认向右旋转n步（默认n = 1）,n是负数则向左旋转
print(de1)
de1.rotate(2)
print(de1)

#1.2.11 删除并返回右边的一个元素
val1 = de1.pop()
print(val1)


#1.2.12 删除并返回左边的一个元素
val2 = de1.popleft()
print(val2)


#1.2.13 删除第一次出现的值
de1.remove('2')
print(de1)


#1.2.14 清空队列中的数据
de1.clear()
print(de1)
#------------------------------------------------------------


#1.3 collections 中的 defaultDict
'''
该类型除了在处理不存在的键的操作之外与普通的字典完全相同。当查找一个
不存在的键的操作发生时，它的default_factory会被调用，提供一个默认的值，
并且将这对键值存储下来。其他的参数同普通的字典方法dict()一致，
一个defaultdict的实例同内建dict一样拥有同样的操作
defaultdict与dict唯一的区别就是初始化默认值的问题，
defaultdict的默认值可以是空list[],或者set{},或者0

defaultdict与dict.setdefault(key,[,default])是等价的，区别是复制的时候会被覆盖
其他使用与dict没有区别


defaultdict对象在当你希望使用它存放追踪数据的时候很有用。
'''
from collections import defaultdict

list3 = [('yellow',1),('blue',2),('yellow',3),('blue',3)]
dict1 = defaultdict(list)
print(dict1)

for k,v in list3:
    dict1[k].append(v)
print(dict1)
dict2 = defaultdict(set)
print(dict2)

dict3 = {}


#-----------------------------------------------------------------------------

#1.4 collections 有序字典 orderedDict的使用
'''
orderedDict是collections中的一个包，能够记录字典元素的插入顺序，常常和排序函数一起使用
来生成一个排序的字典
默认的dict是不保证顺序的，但是该类可以保证插入的顺序

该对象里的元素是字典对象，如果其顺序不同，那么则Python会认为是两个不同的对象

'''
from collections import OrderedDict

dict4 = {'ba1':3,'aple':2,'pear':23,'orga':4}

#1.4.1 按照key排序
orderdict1 = OrderedDict(sorted(dict4.items(),key = lambda  t:t[0]))
print(orderdict1)

#1.4.2 按照value排序
orderdict1 = OrderedDict(sorted(dict4.items(),key = lambda  t:t[1]))
print(orderdict1)

dict5 = {'a':1,'c':2,'b':3}
dict6 = {'b':3,'a':1,'c':2}

print(dict5 == dict6)

#1.4.3 注意这种方式的初始化是保证顺序的
orderdict2 = OrderedDict(dict5)
orderdict3 = OrderedDict(dict6)
print(orderdict2)
print(orderdict3)
print(orderdict3 == orderdict2)

orderdict4 = OrderedDict()
orderdict4['a'] = 123
orderdict4['b'] = 13
orderdict4['d'] = 1
orderdict5 = OrderedDict()
orderdict5['d'] = 1
orderdict5['b'] = 13
orderdict5['a'] = 123
print(orderdict4)
print(orderdict5)
print(orderdict4 == orderdict5)


#1.4.4 有序删除 每次删除最后一个，相当于内存的栈存放，后进先出，pop()是指定元素进行删除
dict7 = orderdict5.popitem()
print(dict7)

orderdict5['h'] = 'asdfasdf'
orderdict5['e'] = 'asdfasdf'

#1.4.5 将指定键值移动到最后,也就是移动到最上面
print(orderdict5)
orderdict5.move_to_end('h')
print(orderdict5)


#1.4.6 设置默认键值
orderdict5.setdefault('k','is default value,key')
print(orderdict5)


#---------------------------------------------------------------------------


#1.5 namedtuple 可命名元组的使用方式
from collections import namedtuple
'''
namedtuple继承tuple对象，namedtuple创建一个和tuple类似的对象，而且对象可以通过属性名访问元素值
tuple只通过索引去访问，namedtuple可以提供基于对象的方式通过属性名访问元素值
每个元素都有自己的名字，类似于java的Bean，C语言中的struct。
同样的，对象属性一旦确定则不可更改，tuple中的值一旦确定也不可更改

但是在使用namedtuple的时候注意属性名不能使用Python的关键字，如:class def等。
而且不能有重复的属性名称。
如果有属性冲突的情况下，可以通过namedtuple开启重命名模式
'''

#1.5.1 初始化 下面的方式相当于创建了一个Person类 里面有5个属性
personObj = namedtuple("person",'name age gender address money ')
print(type(personObj))
print(personObj)

Bob = personObj(name='Bob',age=23,gender='nan',address='beijing',money=30000.00)
#上面的代码相当于创建了一个Person对象，下面则是通过元组的方式打印该Person对象
print(Bob)
zhangsan = personObj(name='zhangsan',age=40,gender='nan',address='nanjing',money=303330.00)
#通过属性名之间访问到属性值
print(zhangsan.address+"-----"+zhangsan.gender+"----"+zhangsan.name)

#1.5.2 存在命名冲突的情况
#通过设置重命名模式为True解决命名冲突的情况
personObj2 = namedtuple("person",'name age gender address money age ',rename=True)
#第二个冲突的属性名通过: _+indexNum的方式表示,设置值的时候要通过 _+indexNum=value的方式
print(personObj2._fields)

lisi = personObj2(name='zhangsan',age=40,gender='nan',address='nanjing',money=303330.00,_5=30)
print(lisi)
```
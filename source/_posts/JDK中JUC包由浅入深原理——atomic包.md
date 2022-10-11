---
title: JDK中JUC包由浅入深原理——atomic包
date: 2022-10-11 08:54:26
category: 
      - Java编程语言
tags:
---

# intel CPU原子操作

需有一个基本逻辑，CPU不支持的，上层不可能自己YY出来。沿着操作系统内核往应用层，通常都是利用底层的能力，构筑上层的大厦。

在intel中，指令lock+指令，可构成一个原子指令（即要么都执行，要么不执行）。上层代码，可基于此构建自己的原子操作。

依据可查阅intel开发手册Volume3 - 8.1到3。

![image-20221011093328936](/Users/boy/Code/windanchaos.github.io/source/images/image-20221011093328936.png)

从上可知，通常套路原子指令大概就有：

```assembly
LOCK; ADDL $0,0(%%esp) //栈底加0，什么也不做
```

```assembly
CMPXCHG;  //自带LOCK
```

# JDK和hotspot源码

以java.util.concurrent.atomic.AtomicInteger为例

![image-20221011142419420](/Users/boy/Code/windanchaos.github.io/source/images/image-20221011142419420.png)

上图展示了从jdk到jdk源码，到hotspot源码，类AtomicInteger中的getAndIncrement方法的调用链路。到hotsopt层面就一句核心:

```assembly
  #define LOCK_IF_MP(mp) "cmp $0, " #mp "; je 1f; lock; 1: "  //定义宏，如果mp与0相等，则跳过lock指令，否则执行lock
  inline jint _Atomic_cmpxchg(jint exchange_value, volatile jint* dest, jint compare_value, int mp) {
    __asm__ volatile (LOCK_IF_MP(%4) "cmpxchgl %1,(%3)" //比较并交换指令
                    : "=a" (exchange_value)
                    : "r" (exchange_value), "a" (compare_value), "r" (dest), "r" (mp)
                    : "cc", "memory");
    return exchange_value;
  }
```

以上内联代码转义为正常汇编代码，大概如下：

```assembly
cmp $0, " #mp "; //mp = multi processor 多核
je 1f; //跳到1:所在行，就是什么也不做
lock; 
cmpxchgl exchange_value,dest  //dest和exchange_value相比较，如果相等ZF寄存器置1并把dest放入EAX寄存器（即栈返回值）。如果不相等，ZF寄存器的值置0，并将exchange_value的值存入EAX寄存器（即栈返回值）。
1:

```

intel手册该指令解释如下：

![image-20221011144908523](/Users/boy/Code/windanchaos.github.io/source/images/image-20221011144908523.png)

所以，lock;cmpxchg提供了atuomic包下面的底层支持。

# ABA问题

并发条件下通过cmpxchg方式操作，存在aba问题，即cpu对同一个值改动2次，从A改到B又改回A，其他cpu并不知道值变过，解决办法就是加版本号(Stamped)。在juc包中对应的类为：AtomicStampedReference。它的原理类似上面。

# LOCK指令

lock指令为什么能保证指令的原子性呢？

核心：在CPU内部中有个store buffer，可提高CPU执行效率。同时带来了多核情况下，同一个内存中的值，在不同CPU当中的可能是不同的（写回内存前，没有刷出store buffer）。lock指令锁住了数据总线的同时，主动刷出了store buffer，通过cache的连通性（ Store Forwarding），其他CPU会获知自己拿的值过期，可更新到最新值。

![image-20221011151713702](/Users/boy/Code/windanchaos.github.io/source/images/image-20221011151713702.png)

图参考[hwViewForSwHackers](http://www.puppetmastertrading.com/images/hwViewForSwHackers.pdf)


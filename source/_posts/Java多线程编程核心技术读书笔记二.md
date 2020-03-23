---
title: Java多线程编程核心技术读书笔记二
date: 2020-03-23 10:46:46
category:
    - Java编程语言
---



这篇读书笔记是《Java多线程编程核心技术》图书的最后一篇。由于写笔记的时候已经读完了整本书，留下了一个大致的印象——适合做多线程的入门读物，所以在读完后感觉缺点什么东西，顺手就打开了另一本《Java并发编程的艺术》，瞬间感觉当年书买得十分的合理，《Java并发编程的艺术》虽然没有开始读，但是大致看了几页，感觉这本书还是要深入一些，更加贴近原理，知识的密度要高很多。

# 第3章 线程间通信

这一章基本围绕“wait等待/notify通知” 机制来描述线程之间通信的方式。

## wait/notify

其核心思想是处理好锁的获取，锁的释放，唤醒（本质是改变线程自己的状态）的关系。

每个锁都有两个队列，一个就绪，一个阻塞。就绪是要需要锁的（可参与锁竞争），阻塞是不需要锁的（被其他事情中断而不能参与锁的争夺，notify就是改变这个队列中的线程的状态，使其进入就绪状态）

某线程调用的lock对象的wait()方法，线程释放锁，进入waiting状态（线程的等待队列）；

其他线程的lock对象调用notify()或notifyall()方法，则随机或全部讲waiting该锁的线程设置回runnable可执行状态，同时线程会在完成自己代码的执行后，释放自己占用的lock（注意不是notify动作的时候释放）。等待队列中的线程则被cpu随机调用执行。

这里要题外话，书上描述“如果线程抢占到cpu资源…………”，这个描述很容易让新手误解线程是主动的，实际上并不是，是线程自己的状态配置被其他获取到cpu资源的线程改变了，然后被cpu调用到了才对。

wait(long)可以加时间参数，等带long时间看看有没有被唤醒，超过long就自动唤醒。

使用wait/notify，需要避免混乱：如过早通知、等待条件发生改变

## 生产/消费者模式

生产者和消费者数量在{1,N}的笛卡尔积的组合，如何处理好同步。主要是利用wait/notify的技巧。

还介绍了以下管道进行线程间的通信。这个之前了解比较少就专门记录一下。

- PipedInputStream 和 PipedOutputStream，通过各自对象的connect(stream)方法建立进和出通道的联系
- PipedReader 和PipedWriter，同上

## 线程的join方法

线程若需要其他线程等待自己线程结束，可以使用的方法。为什么要等？比如等子线程执行后返回值。是被等待的线程调用join()方法来阻塞等待线程。join()具有使线程排队运行的作用，与synchronized的区别：join内部使用的wait()方法进行等待，而synchronized是使用的对象监视器做同步。

join(long) 同wait(long)。

join(long) 和sleep(long) 区别。锁释放阻塞和和锁持有等待（阻塞）。

## 类ThreadLocal

主要解决每个线程绑定自己线程的值。教程向我们展示了如何使用ThreadLocal，我这里做下变通自己写了测试代码。

```java
public class ThreadLocalDemo {
    static ThreadLocal local=new ThreadLocal();
    public static void main(String[] args) {
        Thread threadA=new Thread(new ThreadA(local), "threadA");
        Thread threadB=new Thread(new ThreadB(local), "threadB");
        threadA.start();
        threadB.start();
        setValue();
    }
    public static void setValue(){
        for (int i = 0; i < 10; i++) {
            local.set(Thread.currentThread().getName()+i);
            //打印threadlocat中的值
            System.out.println(local.get());
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

class ThreadA implements Runnable{
    private ThreadLocal local;
    public ThreadA(ThreadLocal local) {
        this.local=local;
    }

    @Override
    public void run() {
        ThreadLocalDemo.setValue();
    }
}
class ThreadB implements Runnable{
    private ThreadLocal local;
    public ThreadB(ThreadLocal local) {
        this.local=local;
    }

    @Override
    public void run() {
        ThreadLocalDemo.setValue();
    }
}
```

通过查看源码， ThreadLocal<T>泛型。底层用的map存储线程的值，所以，一个线程是只能存一个值。

# 第4章 Lock的使用

这个章节主要在聊ReentrantLock和ReentrantReadWriteLock。

jdk1.5增加的锁，也能实现线程之间的同步和互斥，而且具备了嗅探锁定、多路分支通知等特性。

## ReentrantLock

Lock是接口，ReentrantLock实现了这个接口、围绕ReentrantLock讲故事，故事的内容纷繁，我就截个图说明了。

lock的方法：

![image-20200323153650930](/images/image-20200323153650930.png)

condition的方法：

![image-20200323171203293](/images/image-20200323171203293.png)

- 最简单的情节，加锁，办事，解锁。

- 复杂一点的，等待condition，等别人在此confdition上面调用notify或notifyall。不同的condition可以精准唤醒。

- 然后教程展示了使用这套机制实现生产者\消费者模式

  ReenTrantLock的方法

  ![image-20200323165314439](/images/image-20200323165314439.png)

## 公平锁和非公平锁

公平锁，表示线程获取锁的顺序是按照线程加锁的顺序来分配，FIFO形式。反之就是非公平，非公平是随机的。

## ReentrantReadWriteLock

更加细粒度的锁。

规则：读线程之间不互斥；读和写互斥，写和写互斥。

```java
        ReentrantReadWriteLock lock= new ReentrantReadWriteLock();
        lock.writeLock().lock();
        lock.readLock().lock();
```

使用起来大同小易。

# 第5章 Timer

这个章节主要介绍了定时/计划功能，它在移动端开发使用较多，其内部是使用多线程方式来处理的。细节也不纠结，比较简单。

![image-20200323173831646](/images/image-20200323173831646.png)

# 第6章 单例模式和多线程

本章开篇，提及一个观点，多线程模式下，很多不良设计会给商业应用带来灾难。这是一个值得警醒的问题。

单例模式有饿汉和懒汉模式。

本质区别是单例对象的生成是在类加载时还是在单例方法被调用时。

出现线程安全问题是懒汉模式。

这里不断的优化单例模式。给方法加synchronized、给代码块加synchronized。文章说synchronized慢，至于为什么慢没有说，我姑且猜测是synchronized包裹的代码行越多，就导致多线程能并发执行的越少。

然后给出了DCL机制，double check lock。

```java
public class AloneInstance {
    private static AloneInstance instance;
    private AloneInstance(){}
    public static AloneInstance getInstance(){
        if(instance==null){
            System.out.println("somethine init need to do");
            synchronized (AloneInstance.class){
                if(instance==null)
                    instance = new AloneInstance();
            }
        }
        return instance;
    }
}
```

其他使用静态代码块、静态内之类实现的单利模式，本质其实还是提前生成了单例对象。

还有一种天然线程安全的enum枚举实现单例模式。这块我之前有了解，但是枚举为什么是线程安全的继续深入了解了一下——编译后反编译的代码显示，它是静态的，恩静态的。毋庸置疑了。

最后，序列化的单例模式如何保证线程安全？反序列化类生成是通过反射机制来实现的，所以会导致单利模式的结构被破坏。要保证线程安全，就要使用静态方式、并增加一个获取实例的非静态方法。

```java
public class Singleton implements Serializable {
    private static class SingletonHolder {
        private static final Singleton INSTANCE = new Singleton();
    }

    private Singleton() {
    }

    public static Singleton getInstance() {
        return SingletonHolder.INSTANCE;
    }
    //防止序列化破坏单例模式
    public Object readResolve() {
        return SingletonHolder.INSTANCE;
    }
}
```










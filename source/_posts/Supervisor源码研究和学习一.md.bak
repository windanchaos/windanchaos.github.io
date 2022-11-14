---
title: Supervisor源码研究和学习
date: 2019-11-26 00:15:09
category:
	- 计算机科学基础
---

# 出发点
最近，在构思一套内部环境服务的监控系统，起码的功能是能识别到业务进程异常（进程级别的），退出后自动拉起。
找到了supervisor，了解基本功能后，觉得它在分布式方面还存在不足之处，所有配置分散在单机上。鉴于它的技术符合目前需要练习python技术栈。所以，准备对其源代码进行解构、分析和学习。

# 概览
源码研究和学习，起码要对该工具如何使用有个基本的掌握。

Supervisor是用Python开发的一套通用的进程管理程序，能将一个普通的命令行进程变为后台daemon，并监控进程状态，异常退出时能自动重启。它是通过fork/exec的方式把这些被管理的进程当作supervisor的子进程来启动，这样只要在supervisor的配置文件中，把要管理的进程的可执行文件的路径写进去即可。也实现当子进程挂掉的时候，父进程可以准确获取子进程挂掉的信息的，可以选择是否自己启动和报警。supervisor还提供了一个功能，可以为supervisord或者每个子进程，设置一个非root的user，这个user就可以管理它对应的进程。
## medusa
它依赖第三方的[medusa](http://www.nightmare.com/medusa/)来处理网络请求。medusa的源码也值得学习和研究。

## supervisord
类似于docker所在服务器运行的守护进程，负责响应客户端的命令行、受监控进程的监控、重启、受控子进程的标准输入输出的日志、生成和处理与子流程生命周期中相对应的“事件”。配置文件一般为/etc/supervisord.conf。
## supervisorctl
控制台，和supervisord交互。通过控制台，用户可以连接到不同的supervisord进程（ 通过UNIX domain socket or an internet (TCP) socket），查看supervisord的控制进程的状态。读取/etc/supervisord.conf下的[supervisorctl]内容作为配置。
## Web Server
supervisord的浏览器控制台。仅支持单机模式，就是说，N台服务器安装了supervisor的话，就有N个webServer，它们彼此之间并没有关联，所以也没有一个集中化的界面统一管理。

有个php的解决方案：https://blog.csdn.net/geerniya/article/details/80107761
## XML-RPC Interface
The same HTTP server which serves the web UI serves up an XML-RPC interface that can be used to interrogate and control supervisor and the programs it runs.

## 不足

优点：
    - 可以将非后台运行程序后台运行
    - 自动监控，重启进程
    
缺点：
    - 不能管理后台运行程序
    - 对多进程服务，不能使用kill关闭
# 源码分析
源码分析步骤：

1、clone代码到本地；

2、本地做supervisord的配置

3、参考别写的源码文章，找到程序入口，阅读代码

4、debug若干次，追中代码运行逻辑
<!-- more -->

## 执行逻辑和核心
supervisord作为进程入口，启动后先将自己的进程daemon化。接着开始利用opitons.py中的代码，对配置进行初始化，读取关键配置，我目前只研究了启动监控进程部分。读取完配置后，去检查运行环境、进程状态等，没有启动则启动受控进程，受控进程和supervisor的进程通过pipes通信，子进程状态上报。其中的核心方法只有一句：
```
# options.py中的方法
    def execve(self, filename, argv, env):
        return os.execve(filename, argv, env)
```
其他代码都服务于它，supervisor的进程控制模块的代码基本就围绕这如何构建filename,argv,env这三大参数展开。如何展开的我就不细说了，debug运行跟，基本都暴露给出来了。要提醒以下的是，执行os.execve这个方法，是supervisor的进程先fork了子进程后再跑的os.execve。

## supervisor自身的数据模型
当然这个主要内容都在supervisor/supervisor/supervisord.py里了。

我试着做个简单解读
```
class Supervisor:
    # 下面4个是进程自身的状态控制信息
    # 处理发送了停止请求的参数
    stopping = False # set after we detect that we are handling a stop request
    # 暂时不清楚这个参数具体干什么
    lastshutdownreport = 0 # throttle for delayed process error reports at stop
    # {进程组名称:进程组}的map信息
    process_groups = None # map of process group name to process group object
    # 按优先级排序了的被shutdown了的进程组信息的list
    stop_groups = None # list used for priority ordered shutdown

    def __init__(self, options):
        self.options = options #配置信息
        self.process_groups = {} #hold住的进程组
        self.ticks = {} #消息机制
```
这里需要注意，supervisor对受控进程进行管理，采用的进程组的概念，而不是单进程。

supervisord.py里有个逻辑很漂亮，那就是把自己daemon化了。具体代码怎么流转的自己看代码了，只写我觉得对我有价值的内容。

### 实现daemon进程的套路
supervisor启动时，也是被自己的父进程fork出来的。因此，它遵循了daemon化的一般原则，详见下面方法的说明。

```
    # supervisor的run方法中有一句，进程状态还不是daemon并且是第一加载配置就daemon化
            if (not self.options.nodaemon) and self.options.first:
                self.options.daemonize()
```
调用os.setsid,让进程摆脱父进程的session（会话）而自立门户，成为新的进程组的leader。而有一种情况是自身本来就是会话的leader的化就没有办法再自立门户了，所以标准动作是先fork自己，退出自己，再把fork出来的进程。options中的daemon方法，满满的套路。代码作者还给出了为什么要把标准0.1.2设置为null的原因。[点击跳转自己读](http://www.hawklord.uklinux.net/system/daemons/d3.htm)，如果用我大白话说的话，意思很简单，linux下一切。老实说，我觉得damonize这个方法应该放到进程的相关模块中。
```
    def daemonize(self):
        # To disassociate ourselves from our parent's session group we use
        # os.setsid.  It means "set session id", which has the effect of
        # disassociating a process from is current session and process group
        # and setting itself up as a new session leader.
        #
        # Unfortunately we cannot call setsid if we're already a session group
        # leader, so we use "fork" to make a copy of ourselves that is
        # guaranteed to not be a session group leader.
        #
        # We also change directories, set stderr and stdout to null, and
        # change our umask.
        #
        # This explanation was (gratefully) garnered from
        # http://www.hawklord.uklinux.net/system/daemons/d3.htm

        pid = os.fork()
        if pid != 0:
            # Parent
            self.logger.blather("supervisord forked; parent exiting")
            os._exit(0)
        # Child
        self.logger.info("daemonizing the supervisord process")
        if self.directory:
            try:
                os.chdir(self.directory)
            except OSError, err:
                self.logger.critical("can't chdir into %r: %s"
                                     % (self.directory, err))
            else:
                self.logger.info("set current directory: %r"
                                 % self.directory)
        os.close(0)
        self.stdin = sys.stdin = sys.__stdin__ = open("/dev/null")
        os.close(1)
        self.stdout = sys.stdout = sys.__stdout__ = open("/dev/null", "w")
        os.close(2)
        self.stderr = sys.stderr = sys.__stderr__ = open("/dev/null", "w")
        os.setsid()
        os.umask(self.umask)
        # XXX Stevens, in his Advanced Unix book, section 13.3 (page
        # 417) recommends calling umask(0) and closing unused
        # file descriptors.  In his Network Programming book, he
        # additionally recommends ignoring SIGHUP and forking again
        # after the setsid() call, for obscure SVR4 reasons.
```
所以，python的daemon进程的一般套路可以总结为：

- fork子进程，fork有两个返回值，通过返回值执行逻辑
- 返回值为不为0，就是父进程，退出父进程
- 子进程执行os.setid()，让自己成为进程组和会话的leader。
- 安全的关闭父进程的三标（输入、输出、错误）
- 重新指定子进程的标三标，使用os.dup或os.dup2函数，supervisor直接赋值。
- 重新设置子进程的掩码umask，就是chmod给权限的时候那组组合数字，出于安全性的考虑，往往不希望这些文件被别的用户查看。这时，可以使用umask函数修改文件权限，创建掩码的取值，以满足守护进程的要求。
- 重新指定子进程的工作目录。当进程没有结束时，其工作目录是不能被卸载的。为了防止这种问题发生，守护进程一般会将其工作目录更改到根目录下（/目录）。更改工作目录使用的函数是chdir。

需要注意：

 在 Unix 上通过 spawn 和 forkserver 方式启动多进程会同时启动一个 资源追踪 进程，负责追踪当前程序的进程产生的、并且不再被使用的命名系统资源(如命名信号量以及 SharedMemory 对象)。当所有进程退出后，资源追踪会负责释放这些仍被追踪的的对象。通常情况下是不会有这种对象的，但是假如一个子进程被某个信号杀死，就可能存在这一类资源的“泄露”情况。（泄露的信号量以及共享内存不会被释放，直到下一次系统重启，对于这两类资源来说，这是一个比较大的问题，因为操作系统允许的命名信号量的数量是有限的，而共享内存也会占据主内存的一片空间）。要选择一个启动方法，你应该在主模块的 if __name__ == '__main__' 子句中调用 set_start_method()

supervisord模块就解读完毕。
## supervisor的配置模型
都在options.py中了，基类Options。

从配置中，我们可以窥探出supervisor整个系统由哪些元素构成。这里做一个列举，它们的基类是Options：
- ServerOptions
- ClientOptions
- ProcessConfig
- ProcessGroupConfig
- EventListenerConfig
- EventListenerPoolConfig
- FastCGIGroupConfig
- FastCGIProcessConfig

这里要吐槽下，我现在对python的模块原则还不了解，所以我对supervisor作者在options.py写了些异常类表示不理解，按linux一个命令只做一件事这种原则，不是应该有个异常类的模块才对？

配置从哪里来，我大致看了：命令行、默认配置路径找。

如果我要写和配置有关的代码，我会再来细究，这里就跳过了。

## supervisor受控进程模型
process.py中，Subprocess是最重要的一个类。基本几大类：状态、日志、事件、管道、异常。
```
class Subprocess:

    """A class to manage a subprocess."""

    # Initial state; overridden by instance variables

    pid = 0 # Subprocess pid; 0 when not running
    config = None # ProcessConfig instance
    state = None # process state code
    listener_state = None # listener state code (if we're an event listener)
    event = None # event currently being processed (if we're an event listener)
    laststart = 0 # Last time the subprocess was started; 0 if never
    laststop = 0  # Last time the subprocess was stopped; 0 if never
    delay = 0 # If nonzero, delay starting or killing until this time
    administrative_stop = 0 # true if the process has been stopped by an admin
    system_stop = 0 # true if the process has been stopped by the system
    killing = 0 # flag determining whether we are trying to kill this proc
    backoff = 0 # backoff counter (to startretries)
    dispatchers = None # asnycore output dispatchers (keyed by fd)
    pipes = None # map of channel name to file descriptor #
    exitstatus = None # status attached to dead process by finsh()
    spawnerr = None # error message attached by spawn() if any
    group = None # ProcessGroup instance if process is in the group

    def __init__(self, config):
        """Constructor.

        Argument is a ProcessConfig instance.
        """
        self.config = config
        self.dispatchers = {}
        self.pipes = {}
        self.state = ProcessStates.STOPPED
```
### 进程状态模型
ProcessStates类中，该类在state.py中。
```
class ProcessStates:
    STOPPED = 0
    STARTING = 10
    RUNNING = 20
    BACKOFF = 30
    STOPPING = 40
    EXITED = 100
    FATAL = 200
    UNKNOWN = 1000

STOPPED_STATES = (ProcessStates.STOPPED,
                  ProcessStates.EXITED,
                  ProcessStates.FATAL,
                  ProcessStates.UNKNOWN)

RUNNING_STATES = (ProcessStates.RUNNING,
                  ProcessStates.BACKOFF,
                  ProcessStates.STARTING)
```



那接下来，在开源代码中学习代码及所属领域的知识是研究的出发点。


# 我的应用场景
supervisor并不适合我的应用场景。

首先，它是作为父进程来fork受监控的进程的，也就是子进程的生命周期它能无微不至的照顾到，虽然子进程的所有信息它都能掌握，但在我的场景下，有发版和更新的刚性需求。如果用supervisor来监控和拉起，就导致发版更新后也不得不用supervisor的自动重启来完成。这种强耦合的方式并不是很优美，会导致大量改造工作。

其次，部署信息都是散落在服务器上的，对于超过10个应用，甚至更多，分散化的部署维护起来也不方便。所以有个潜在的需求，统一配置受控进程。supervisor的http服务是单机版的，对于分布式部署来说，缺少一个统一界面维护。

所以，我可能会supervisor做如下的改造：
- 获取监控进程的信息源来自db或者redis之类持久化的存储服务
- fork子进程，但是并不监控子进程的状态，只判定它是否存在。不存在超过一个阈值自动拉起。
- 有一个受控进程的展现页面，所有被supervisor分散监控进程状态都列在上面，可以触发重启、启动操作


源码解读第一波就到这了。

# 参考
[supervisor官方文档](http://www.supervisord.org)

[supervisoer源码分析](https://blog.csdn.net/qq_33339479/article/details/78374837)
[进程组、session、前台任务、后台任务、守护进程](https://blog.csdn.net/xybz1993/article/details/80869471)

[操作系统核心原理-3.进程原理（上）：进程概要](https://www.cnblogs.com/edisonchou/p/5003694.html)


[进程实现原理](https://blog.csdn.net/u014688145/article/details/50644876)

[fork()子进程与父进程的关系（继承了什么）](https://blog.csdn.net/qq_22613757/article/details/88770579)

[操作系统中信号工作原理](https://blog.csdn.net/gangstudyit/article/details/80551912)

[supervisor的daenon进程原理](http://www.cems.uwe.ac.uk/~irjohnso/coursenotes/lrc/system/daemons/d3.htm)

[linux的文件描述符](https://www.cnblogs.com/diantong/p/10413079.html)

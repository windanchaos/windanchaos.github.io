---
title: jenkins经验
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 持续集成

date: 2017-10-28 15:40:44
---
## 1、关于进程

即jenkins默认会kill掉自己生产的子进程。这个问题百度一下就解决。

## 2、莫名其妙的failure，命令执行的返回状态对jenkins的影响

原则：自己编写的shell脚本，函数必须有一个自己想给出的返回状态，告知jenkins该状态成功或失败后，是否继续执行。因为从安全角度考虑，jenkins面对每一个命令，只要抛出异常，必然是终止其执行的，以免之后的脚本依赖错误执行导致不可预见的错误。如下面的脚本，主要目的是结束关键词输入的进程。
```js 
function kill_process(){
    local process=${1}
    #进程存在则执行kill动作，进程不存在什么也不做
    [ -n "`ps -ef |grep ${process}|grep -v grep| awk '{print $2}' | head -1`" ] && \
    ps -ef |grep ${process}|grep -v grep| awk '{print $2}' | xargs kill -9 
}
```

单机运行的时候不会有任何问题。
然而在jenkins中调用的时候（以下例子是ssh到服务器后执行kill动作的日志）,没有报错。但是failure了

```js 
[user@iZbp1gs5bd83lri6133n08Z ~]$ source /arthas/sites/deploy_function.sh
[user@iZbp1gs5bd83lri6133n08Z ~]$ kill_process servers/apache-tomcat
[user@iZbp1gs5bd83lri6133n08Z ~]$ logout
Connection to 172.16.0.24 closed.
Build step 'Execute shell' marked build as failure
```

原因就是kill_process 的状态是由：

```js 
[ -n "`ps -ef |grep ${process}|grep -v grep| awk '{print $2}' | head -1`" ]
```

这个判断决定，而该进程当时是不存在的，不存在则状态就是非0，所以函数执行等效是失败的。实际上，业务是允许的进程不存在的，所以优化为：

```js 
function kill_process(){
<!-- more -->
    local process=${1}
    #进程存在则执行kill动作，进程不存在什么也不做
    [ -n "`ps -ef |grep ${process}|grep -v grep| awk '{print $2}' | head -1`" ] && \
    ps -ef |grep ${process}|grep -v grep| awk '{print $2}' | xargs kill -9 || return 0
}
```

就是进程存在则kill掉，kill会返回成功状态。进程不存在，也返回成功状态。

## 3、找不到参数控件，你可能只是用错了item类型

我曾网上查找到jenkins的参数化方法，但是我自己的项目始终找不到对应的控件，试过了重装、降版本，卸载插件之类无效的方案。
最后，换成了“**构建一个自由风格的软件项目”**
哦，我想要的都有了。。。。。

## 4、同一个函数，有的成功了，有的失败了，你可能是本地的参数没有明确定义

如下脚本，注销的
local SITE_PATH=”/arthas/sites/”
函数被循环调用，则SITE_PATH这个参数不明确定义的话，使用的就是上一次被定义的值。而这个值，却不一定会在下次调用中存在，就会报错。
**所以，编写的函数一定要明确定义参数。**
```js 
function kill_remote_process(){
    local deploy_function="${USER_HOME}/deploy_function.sh"
    local ip=${1}
    local process=${2}
    #local SITE_PATH="/arthas/sites/"
    get_server_UPP ${ip}
    sshpass -p $PASSWORD scp -P ${CONFIG_REMOTE_PORT} ${deploy_function} ${CONFIG_REMOTE_USER}@${CONFIG_REMOTE_IP}:${SITE_PATH}
    sshpass -p $PASSWORD ssh -tt ${CONFIG_REMOTE_USER}@${CONFIG_REMOTE_IP} -p ${CONFIG_REMOTE_PORT}<<EOF
source ${SITE_PATH}deploy_function.sh
kill_process ${process}
logout
EOF
    if [[  (`ps -ef |grep ${process}|grep -v $0|grep -v grep| grep -v activemq |awk '{print $2}' | head -1`) ]];then
        ps -ef |grep ${process}|grep -v $0|grep -v grep| grep -v activemq | awk '{print $2}' | xargs kill -9
    fi
}
```

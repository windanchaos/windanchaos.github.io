---
title: linux shell判断文件是否更新、修改
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2018-07-10 19:49:06
---
核心命令：stat
如下函数，判断文件是否更新，传入文件路径，间隔时间（秒s），则输入文件在多少秒内是否被更新过。
函数会持续等待文件不再变化后停止。
```js 
function whether_changed(){
    local file_path=${1}
    local check_time=${2}
    while [[ true ]]; do
        file_old_stat="`stat ${file_path}|grep Size`"
        sleep ${check_time}
        file_new_stat="`stat ${file_path}|grep Size`"
        if [[ `echo ${file_old_stat}` == `echo ${file_new_stat}` ]]; then
            echo "### In ${check_time}s ,${file_path} does not change ###"
            break
        else
            echo "#### Wait ${check_time}s ####"
        fi
    done
}
```

如果要判断某文件自从上次修改以来是否有变更过，则可以将文件状态记录在一个文本中。下次提取比较即可。这里不提供实现。

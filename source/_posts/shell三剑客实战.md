---
title: shell三剑客实战
date: 2020-05-17 16:55:03
category: Linux管理维护

---

# 一点总结

由于自己本身就对shell中常用的命令有所了解，所以基础的就不啰嗦了。在我之前的[博客]( [https://blog.windanchaos.tech/categories/Linux%E7%AE%A1%E7%90%86%E7%BB%B4%E6%8A%A4/](https://blog.windanchaos.tech/categories/Linux管理维护/) )中已经有不少内容

就写过的很多shell脚本经验看，最近作为助教又在跟着霍格沃兹第三期，又有了新感受。结合以前的经验，做个简单的总结。

- 代码要**规范**
- 虽然是shell，代码在逻辑上也要**缜密**

# Linux文本三剑客

## awk

最基本的作用，按规则输出列。

前置学习printf 或print。

### printf

命令格式：

printf '匹配式' 输入内容

它的输出全部当成字符串。所以需要自己来设置换行或空格。

%ns

输出字符串。n是数字指代输出几个字符

%ni

输出整数。n是数字自带输出几个数字。

%m.nf

输出浮点数。m是总的位数，n是小数位数

下面是例子，文本demo.txt

ID      Name    Linux   PHP     MySQL   Java
1       Liming  82      55      58      87
<!-- more -->
2       SC      82      65      72      77
3       Tg      88      83      93      75



下面的命令会无差别打印全部字符，没有任何分隔符。

```bash
 printf '%s' `cat demo.txt`
 #打印结果如下
 #IDNameLinuxPHPMySQLJava1Liming825558872SC826572773Tg88839375
```

下面命令正常输出。

```bash
printf '%s\t%s\t%s\t%s\t%s\t%s\t\n' `cat demo.txt`
```

### awk句法

```bash
awk '条件1{动作1} 条件2{动作2}...' 文件名
```

awk 是一行一行执行的，先第一行全部内容给$0,依次列给$N。依据条件类型判定动作执行，不断的迭代。

条件可以是以下：**

保留字**BEGIN**，awk程序尚未读取数据之前执行1次。

保留字**END**，awk处理完数据，即将结束执行1次。

没有条件

x > =10

x == y

A ~ B  A中是包含B的字符串

A !~ B A中不包含B的字符串

```bash
awk 'BEGIN{print "hellow world"} {printf $2 "\t" $6 "\n"}' demo.txt 
# 第二列中匹配关键字Tg，需要//包裹关键字，告知是正则
awk '$2 ~ /Tg/ {print $3}' demo.txt
# 整行是否包含关键字，打印
awk '/Tg/ {print $3}' demo.txt
```

**动作可以是**：

格式化输出

流程控制语句

### awk常用内置变量

NF  当前拥有的的列总数

NR  awk所处理的行，总行数据的第几行

$n 代表目前读入的第n个字段（$0  $1....）

FS  定义分隔符，指定分隔符是个动作

```bash
# 打印bash权限的用户
cat /etc/passwd |grep /bin/bash|awk 'BEGIN{FS=":"} {print $1}'
```

## sed

用途：数据选、换、增、查。

### 句法

```bash
sed [选项] '[动作]' 文件名
```

选项：

-n	处理过的数据才输入到屏幕，不加打印全部并加上处理过的。

-e	允许对输入数据多条sed操作

-f	从脚本读取sed操作

-r	支持正则

-i	sed修改写回文件

动作：
a \	追加。追加多行时，需要每行末尾用"\\"代表数据未完。

c \	行替换。追加多行时，需要每行末尾用"\\"代表数据未完。

i \	前插入。追加多行时，需要每行末尾用"\\"代表数据未完。

p3	打印第三行。

d 删除

s	字符替换。格式“行范围s/旧字符/新字符/g”

```bash
sed '2p' demo.txt
sed -n '2p' demo.txt
sed  '2,4d' demo.txt
sed  '2c 11111' demo.txt
sed 's/Liming/Limi/g ; s/Tg/TTTT/g' demo.txt
# 同文本多次操作
sed -e '2c 11111' -e '3c gogogo' demo.txt
# 一个统计nginx中每类别url响应时间的函数
url_avg_time(){
  awk '{print $(NF-1), $7}' nginx.log | \
  sed 's#\?.*##g' | \
  sed 's#%21#\!#g' | \
  sed 's#/\(topics\|replies\|avatar\)/[0-9]\+#/\1/int#g' | \
  sed 's#\(.\+\)/[^/].*\(png\|jpg\|gif\|jpeg.*\)#\1/id\.\2#g' | \
  sed 's# /[^/]\+/\(topics\|following\|replies\|columns\|favorites\|reward\|followers\)$# /username/\1#g' | \
  sed 's#\.\(tar\.tgz\|tar\.gz\|tar\|gz\|zip\|rar\)$#\.compress#g' | \
  sort -k 2 | \
  awk '{total[$2]+=$1; times[$2]++;} END{for(url in total){avg=sprintf("%.3f", total[url]/times[url]); print(avg, url)}}' | \
  sort -k 1 -nr | \
  awk 'BEGIN{printf("%s\t%s\n", "平均响应时间", "接口地址")} {printf("%8s\t%s\n", $1, $2)}'
}
```

## grep

数据查找和定位。用得比较熟，略过。



# 资源

## ps





ps查询出来cpu利用率的是时间范围内的平均值，不是实时

```bash
ps -ef
ps aux
ps -p -o

```



## top

```bash
top -hv|-bcHiOSs -d secs -n max -u|U user -p pid -o fld -w [cols]

```

常用套路

```bash
# 查询进程的现成
top -p pid -H
# -b 批处理，刷新评率下稳定输出文本
top -b 
# -n 输出多少次

# 格式化输出
ps -o %cpu,%mem -p 22056

# 一个综合函数,打印进程10s内的cpu和mem使用率。最后输出平均
perf_get() {
    #使用变量替换位置参数
    local proc="$1"
    local timeout="$2"
    #基本使用给予基本检查
    [ -z "$proc" ] && { echo please give a proc name or pid; return 1; }
    [ -z "$timeout" ] && timeout=10
    #top的批处理输出
    top -b -d 1 -n $timeout |
    #范围限定，为了精准处理
        grep '^[ 0-9][1-9]' |
        #提取精准数据
        awk '{print $1,$9,$10,$12}' |
        #取出感兴趣数据，同时读一行就给后面的管道进程，方便实时显示
        grep --line-buffered -i "$proc" |
        #分组统计并打印，使用tab作为OFS进行输出，fflush()可以实时输出给后面的进程
        awk '
    BEGIN{OFS="\t";print "CPU","MEM"}
    {cpu+=$2; mem+=$3;print $1,$2,$3,$4;}
    END{print "";print "avg: ",cpu/NR,mem/NR}'
}

```

## netstat

```shell
netstat -anp

```

# 数组的套路

套路就是招式。。

```bash
# 定义
array=()
array=(a b c)
# 取值
b=${array[1]}
# 取index集合0 1 2
index=${!array[@]}
# 数组长度
length=${#array[@]}
# 数组所有元素
all_1=${array[@]} //数组
all_2=${array[*]} //字符串
# 遍历
for i in ${array[@]}
do
${i}
...
done
# index的遍历
for i in ${!array[@]}
do
${array[$i]}
...
done

```



# 实战

## 需求

题一：

一家公司有N多人，老板要在年会上抽奖，编写一个脚本进行抽奖。模拟， 每个人掷骰子 。

输出每一轮的掷骰子的结果；

选出最后一个人。 

题二：

增加输出参数N，为最后抽到的人数。如果没有抽足，则从未抽中人群中继续抽，直到抽完。输入同上。

## 抽奖题一

```bash
# 抽奖函数，传入数组
function draw(){
        local array=${1}
        local number=${2}
        # 数组长度
        local size=${#array[@]}
        # 淘汰list
        local removed=()
        if [ ${size} -eq ${number} ]
        then
        {
           # 打印/返回中奖名单
           echo ${array[*]}
           return 0;
        }
        else
        {
           for i in "${!array[@]}";
           do 
              ((RANDOM%6+1 < 4))
              # 记录淘汰名单
              removed[${#removed[@]}]=array[$i]
              # 淘汰
              unset array[$i];
           done
           # 对名单进行判定，如果小于预期值，则重新从淘汰列表抽取（size-已抽取数）
           if [ ${#array[@]} -lt ${number} ]
           then
              # 先输出已选出的名单
              printf ${array[*]}" "
              # 递归调用
              draw ${removed[@]} ((${number}-${#array[@]}))
           else
              # 否则递归调用
              draw ${array[@]}
           fi
        }
        fi
}
function lucky(){
	# 选出人数要求
	number=${1}
    # 数组准备
    array=$(cat ~/username.txt |sort |uniq |grep -v ^$)
    # 中奖名单
    draw ${array[@]}
}


```

## 抽奖题二

第二个抽奖，递归



```bash
function draw(){
        local array=($*)
        # 由于数组做参数传递，多个参数情况下难以操作，做特殊处理
        # 传递参数全部当做数据，取最后一个做人数，然后删除
        local number=${array[${#array[@]}-1]}
        unset array[${#array[@]}-1]
        # 数组长度
        local size=${#array[@]}
        # 淘汰list
        local removed=()
        # 递归结束的条件一:抽足人数
        if [ ${size} -eq ${number} ]
        then
        {
           # 打印/返回中奖名单
           echo "已中奖名单："${array[*]}
           return 0;
        }
        # 递归结束的条件二：没有抽奖的人
        else if [ ${#array[@]} -gt 0 ];then
        {
           for i in ${!array[@]};
           do
              # 记录淘汰名单
              ((RANDOM%6+1 < 4)) && removed[${#removed[@]}]=${array[$i]} && unset array[$i]
           done
           # 对名单进行判定，如果小于预期值，则重新从淘汰列表抽取（预期人数 - 已抽取数）的人数
           if [ ${#array[@]} -lt ${number} ]
           then
              # 先输出已选出的名单
              echo "已中奖名单如下。由于中奖人数不足，剩余人员抽继续抽取。。。"
              echo ${array[*]} 
              # 条件二的递归调用
              draw ${removed[@]} $((${number} - ${#array[@]}))
           else
              # 条件一的递归调用
              draw ${array[@]} ${number}
           fi
        }
        fi
        fi
}
function lucky_top(){
    # 选出人数要求
    number=${1}
    # 数组准备
    array=$(cat ~/username.txt |sort |uniq |grep -v ^$)
    # 抽奖函数，传入数组
    draw ${array[@]} ${number}
}

```



第二个抽奖，非递归方法

```bash
function lucky_top2(){
    # 选出人数要求
    number=${1}
    # 数组准备
    array=$(cat ~/username.txt |sort |uniq |grep -v ^$)
    # 无人中奖直接返回
    [ 0 -eq ${number} ] && echo "不需要有人中奖" && return 0
    # 中奖数超过候选人直接返回
    [ ${#array[@]} -lt ${number} ] && echo "全部中奖："${array[*]} && return 0
    # 淘汰list
    local removed=()
    while [ ${#selected[@]} -lt ${number} ];do
    	# 中奖循环
    	# 中奖list
    	local selected=()
        for i in ${!array[@]};
        do
           # 记录中奖名单,删除中奖者
           ((RANDOM%6+1 > 3)) && selected[${#selected[@]}]=${array[$i]} && unset array[$i]
        done
        # 打印每次抽奖的中奖名单
        echo "已中奖名单如下。由于中奖人数不足，剩余人员抽继续抽取。。。"
        echo ${selected[@]}
    done
}

```


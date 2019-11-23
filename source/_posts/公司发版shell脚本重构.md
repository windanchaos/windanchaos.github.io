---
title: 公司发版shell脚本重构
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2016-12-06 18:12:14
---
# 重构前代码

代码关键字被批量替换。仅供参考。
```js 
#!/bin/sh
sitesPath="/ggcall/sites/"
DATE=$(date +%Y%m%d%H%M)
softfile="/home/ggstar/Arhasgg/"
sitesbackup="/home/ggstar/sitesbackup/"
githome="/home/ggstar/Arhasgg/"
#设置环境变量
source /etc/profile
echo "请确认使用该命令，已经从git库拉取了最新的代码，使用了正确的分支"
cd $githome
echo "git分支名称："+`git branch |awk '{print $4}'|head -3`
echo "编译工程，静默方式，过程如果报错会提示，提示需检查错误后重新编译！"
echo "默认gg-sdk-wx未编译，如更新需本地上传/home/ggstar/.m2/repository/com/gg/sdk/gg-sdk-wx/0.0.1/gg-sdk-wx-0.0.1.jar"
echo "依赖包编译"
cd $githome"gg-aggregator"
mvn -q -ff clean install

echo "编译gg-passport"
cd $githome"gg-passport"
mvn -q -ff clean install -P st
cd $githome"gg-openApi"
echo "编译gg-opanApi"
mvn -q -ff clean install -P st
echo "编译gg-imgr-webbent"
cd $githome"gg-imgr-webent"
mvn -q -ff clean install -P st
echo "编译gg-wm-webent"
cd $githome"gg-wm-webent"
mvn -q -ff clean install -P st
echo "编译gg-img-webent"
cd $githome"gg-img-webent"
mvn -q -ff clean install -P st
echo "编译gg-job-webent"
cd $githome"gg-job-webent"
mvn -q -ff clean install -P st
echo "编译gg-sn-webent"
cd $githome"gg-sn-webent"
mvn -q -ff clean install -P st
echo "编译gg-app-webent"
cd $githome"gg-app-webent"
mvn -q -ff clean install -P st
echo "编译gg-yum-webent"
cd $githome"gg-yum-webent"
mvn -q -ff clean install -P st
echo "编译发布完成"

#删除需要更新的原文件
if [ -f $softfile"gg-imgr-webent/target/gg-imgr-webent.war" ]; then
#echo "back-un--to--"$sitesbackup
#tar -zcf $sitesbackup"imgr"/$DATE.tar.gz -P $sitesPath"imgr/ROOT"
#echo "备份完成!"
echo "imgr update---------------------"
cd $sitesPath"imgr/ROOT"
rm -fr `ls $sitesPath"imgr/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-imgr-webent/target/gg-imgr-webent.war" -d $sitesPath"imgr/ROOT"
echo "imgr解压完成！"
fi

if [ -f $softfile"gg-passport/target/gg-passport.war" ]; then

#echo "back-un-------------"
#tar -zcf $sitesbackup"passport"/$DATE.tar.gz -P $sitesPath"passport/ROOT"


echo "passport update---------------------"
cd $sitesPath"passport/ROOT"

rm -fr `ls $sitesPath"passport/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-passport/target/gg-passport.war" -d $sitesPath"passport/ROOT"
echo "passport解压完成！"
fi

if [ -f $softfile"gg-job-webent/target/gg-job-webent.war" ]; then
#echo "back-un-------------"
#tar -zcf $sitesbackup"job"/$DATE.tar.gz -P $sitesPath"job/ROOT"

echo "job update------------"
cd $sitesPath"job/ROOT"
rm -fr `ls $sitesPath"job/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-job-webent/target/gg-job-webent.war" -d $sitesPath"job/ROOT"
echo "job解压完成！"
fi

if [ -f $softfile"gg-wm-webent/target/gg-wm-webent.war" ]; then

#echo "back-un-------------"
#tar -zcf $sitesbackup"wm"/$DATE.tar.gz -P $sitesPath"wm/ROOT"

echo "wm update-----------------"
cd $sitesPath"wm/ROOT"
rm -fr `ls $sitesPath"wm/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-wm-webent/target/gg-wm-webent.war" -d $sitesPath"wm/ROOT"
echo "wm解压完成！"
fi
#司南
if [ -f $softfile"gg-sn-webent/target/gg-sn-webent.war" ]; then

#echo "back-un-------------"
#tar -zcf $sitesbackup"sn"/$DATE.tar.gz -P $sitesPath"sn/ROOT"

echo "sn update-----------------"
cd $sitesPath"sn/ROOT"
rm -fr `ls $sitesPath"sn/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-sn-webent/target/gg-sn-webent.war" -d $sitesPath"sn/ROOT"
echo "sn解压完成！"
fi

#img
if [ -f $softfile"gg-img-webent/target/gg-img-webent.war" ]; then

#echo "back-un-------------"
#tar -zcf $sitesbackup"img"/$DATE.tar.gz -P $sitesPath"img/ROOT"

echo "img update-----------------"
cd $sitesPath"img/ROOT"
rm -fr `ls $sitesPath"img/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-img-webent/target/gg-img-webent.war" -d $sitesPath"img/ROOT"
echo "img解压完成！"
fi

#yum
if [ -f $softfile"gg-yum-webent/target/gg-yum-webent.war" ]; then
echo "yum update-----------------"
cd $sitesPath"yum/ROOT"
rm -fr `ls $sitesPath"yum/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-yum-webent/target/gg-yum-webent.war" -d $sitesPath"yum/ROOT"
echo "yum解压完成！"
fi


#webapp
if [ -f $softfile"gg-app-webent/target/gg-app-webent.war" ]; then
echo "app update-----------------"
cd $sitesPath"app/ROOT"
rm -fr `ls $sitesPath"app/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-app-webent/target/gg-app-webent.war" -d $sitesPath"app/ROOT"
echo "app解压完成！"
fi

#openApiAPI
if [ -f $softfile"gg-openApiApi/target/gg-openApi.war" ]; then
echo "openApi update-----------------"
cd $sitesPath"openApi/ROOT"
rm -fr `ls $sitesPath"openApi/ROOT" -I shopInfo`
echo "删除完成！"
unzip -q $softfile"gg-openApiApi/target/gg-openApi.war" -d $sitesPath"openApi/ROOT"
echo "openApiAPI解压完成！"
fi

#mock
#if [ -f $softfile"gg-mock-webent/target/gg-mock-webent.war" ]; then
#echo "mock update-----------------"
#cd $sitesPath"mock/ROOT"
#rm -fr `ls $sitesPath"mock/ROOT" -I shopInfo`
#echo "删除完成！"
#unzip -q $softfile"gg-mock-webent/target/gg-mock-webent.war" -d $sitesPath"mock/ROOT"
#echo "mock解压完成！"
#fi

#结束tomcat进程
kill -9 ${k}`ps -fe |grep tomcat |awk '{print $2}'|head -3`
#开启tomcat
cd /ggcall/servers/apache-tomcat-8.5.4-80/bin
./startup.sh
#log
#echo "Logs if ERROR show~~"
#tail -f /ggcall/servers/apache-tomcat-8.5.4-80/logs/catalina.out
```

# 重构后代码

代码当中还增加了rpc的编译和发布内容。脚本代码数明显降低。使用了若干新学技能。
包括shell的（流程控制while、if、awk命令、&&命令状态、let和expr语句执行代数运算、数组、定向>、nohub + &）
```js 
#!/bin/bash
githome="/home/ggstar/Arhasgg/"
sitesPath="/ggcall/sites/"
DATE=$(date +%Y%m%d%H%M)
softfile="/home/ggstar/Arhasgg/"
sitesbackup="/home/ggstar/sitesbackup/"

#设置环境变量
source /etc/profile

webents=(gg-aggregator gg-img-webent gg-wm-msger gg-app-webent gg-job-webent gg-openApi gg-wm-webent gg-yum-webent gg-imgr-webent gg-passport gg-sn-webent gg-imgr-rpc gg-yum-rpc)
longth=${#webents}
RPM=0

#git拉取代码
echo "请确认使用该命令，已经从git库拉取了最新的代码，使用了正确的分支"
cd ${githome}
#echo "git分支名称："+`git branch |awk '{print $4}'|head -3`
echo "git分支名称："+`git status |awk '{print $4}' |head -1`
echo "拉取当前分支代码"
git pull origin `git status |awk '{print $4}'|head -1|awk -F 'in/' '{print $2}'`
echo "编译工程，静默方式，过程如果报错会提示，提示需检查错误后重新编译！"

while [ $RPM -lt $longth ]  && [ $? -eq 0  ]
do
    cd ${githome}${webents[$RPM]} && echo "编译${webents[$RPM]}"
    mvn -q -ff clean install -P st && echo "${webents[$RPM]}编译完成！"
    let RPM++
done

#更新rpc
longthpub=`expr $longth - 3`
RPM=$longthpub
while [ $RPM -lt $longth ]  && [ $? -eq 0  ]
do
        if [ -f $softfile"${webents[$RPM]}/target/${webents[$RPM]}.jar" ]; then
                webentname=`echo ${webents[$RPM]}`
                siteName=`echo ${webentname#*-}`
        #判断是否存在webent，不存在则新建
                if [ ! -d  $sitesPath${siteName}  ]; then
                        mkdir -p $sitesPath${siteName}
                        #echo ${webents[$RPM]}|awk -F '-' '{print $2}'
                fi
                #执行代码更新操作
                echo "$siteName更新---------------------"
                kill -9 ${k}`ps -fe |grep $siteName |awk '{print $2}'|head -2`
                cd $sitesPath${siteName} && rm -fr `ls $sitesPath${siteName}` && echo "删除完成！"
                cp -r $softfile"${webents[$RPM]}/target/lib" $softfile"${webents[$RPM]}/target/${webents[$RPM]}.jar"  $sitesPath${siteName} && echo "$siteName解压完成！"
                sleep 10
                nohup  java -Xms512m -Xmx1024m -jar ${webents[$RPM]}.jar > ${webents[$RPM]}".log" &
        fi
        let RPM++
done

#更新webent
RPM=1
longthpub=`expr $longth - 2`
while [ $RPM -lt $longthpub ]
do
        if [ -f $softfile"${webents[$RPM]}/target/${webents[$RPM]}.war" ]; then
                siteName=`echo ${webents[$RPM]}|awk -F '-' '{print $2}'`
        #判断是否存在webent，不存在则新建
                if [ ! -d  $sitesPath${siteName}"/ROOT"  ]; then
                        mkdir -p $sitesPath${siteName}"/ROOT"
            #echo ${webents[$RPM]}|awk -F '-' '{print $2}'
                fi
        #执行代码更新操作
        echo "$siteName 更新---------------------"
        cd $sitesPath${siteName}"/ROOT" && rm -fr `ls $sitesPath${siteName}"/ROOT" -I shopInfo` && echo "删除完成！"
        unzip -q $softfile"${webents[$RPM]}/target/${webents[$RPM]}.war" -d $sitesPath${siteName}"/ROOT" && echo "$siteName解压完成！"

        fi
        let RPM++
done
#结束tomcat进程
kill -9 ${k}`ps -fe |grep tomcat |awk '{print $2}'|head -3`
#开启tomcat
cd /ggcall/servers/apache-tomcat-8.5.4-80/bin
./startup.sh
```
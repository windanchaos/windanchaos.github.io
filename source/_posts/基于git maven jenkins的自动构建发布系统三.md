---
title: 基于git maven jenkins的自动构建发布系统三
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 持续集成

date: 2017-05-06 18:22:56
---
本人使用Linux的shell脚本对公司测试及生产代码的自动构建发布进行了开发工作，并实际运用到工作当中，显著提高了代码发布的效率，减少了人工发版出错的概率。但是，公司迭代速度非常快，开发进度十分聊得，敏捷的模式下，研发提交代码，再到发布到测试环境的频率很高，由于我负责维护和使用这套东西，在解决bug的过程中，个人的生产力大部分被发版占据。痛定思痛，本人打算将shell脚本升级到更加自动化的程度，解放我的生产力。这便引入了jenkins，强大的自动构建部署服务。
安装过程此处略过。
使用了jenkins的open blue ocean，学习了很久如何在pipline中使用groovy的脚本，并研读了官网教程，没有办法的是，所预想的脚本始终run不成功，基本都是语法错误,而且对于jenkinsFiles的语法，除了看到别人写的知道什么意思外，基本达成不了自己预期的。所以，退而其次，我把所有的功能都写到了shell脚本里，只借助jenkins去执行就好了。
参考jenkins的构建流程，shell脚本分为：

使用jenkins新建了如下job:
![这里写图片描述](/images/dn.net-20170506175834112-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)

其中，pull code的job每一个小时拉取代码一次，自动引发自动编译job（build auto），但不发布。也就是代码是自动拉取并编译的。

pull code 的pipline script:
```js 
node {
   def mvnHome
   stage('Preparation') { // for display purposes
      // Get some code from a Git repository
      sh "~/ci/pull.sh"

   }
}
```

pull.sh内容：

```js 
#!/bin/bash
githome="/home/admin/gitCode/"
#设置环境变量
source /etc/profile
cd ${githome}
#git reset --hard HEAD^
echo "git分支名称："+`git status |awk '{print $4}' |head -1`
echo "拉取当前分支代码"
git pull origin `git status |awk '{print $4}'|head -1`
```

build auto 的pipline script:

```js 
node {
   stage('Build') {
      // Run the maven build
      if (isUnix()) {
         sh "bash ~/ci/buildauto.sh"
      } else {
         println "OS is not linux"
      }
   }
}
```

buildauto.sh内容：

```js 
#auto build when the code update in 9 hour
#created by bojiang@maike51.com
source /etc/profile
webents=(boy-aggregator boy-smart-webent boy-wm-msger boy-app-webent boy-job-webent boy-openApi boy-wm-webent boy-yum-webent boy-imgr-webent boy-uic-webent boy-qdragon-webent boy-sn-webent boy-intf-webent boy-kunlun-webent boy-imgr-rpc boy-yum-rpc boy-mdata-rpc boy-uic-rpc boy-sn-rpc)

cd ~/gitCode
history=`git log --since=9.hours -p . |grep diff |awk '{print $4}' |awk -F 'b/' '{print $2}'|sort -u|awk -F '/' '{print $1}'|sort -u`
arr=(`echo $history`)
#get webent list first ,then build service before webents
buildwebent=()
for h in ${arr[@]}
do
    for webent in ${webents[@]}
    do
        if [ "$h" == "$webent"  ] ;then
         buildwebent[${#buildwebent[@]}]=$h
        fi
    done
done
#get service,by remove webent from history
service=()
i=0
#Dynamic arr,longth needs get first
longth=${#arr[@]}
while [ $i -lt $longth ]
do
    echo $i
    echo ${arr[$i]}
    for b in ${buildwebent[@]}
    do
        if [ "${arr[$i]}" == "$b"  ] ;then
           unset arr[$i]
        fi
    done
    let i++
done
#service build first
for s in ${arr[@]}
do
    if [ "$s" != "boy-dbscript-mysql" ] && [ "$s" != "fontend-vue" ]  ;then
        echo "build service $s"
        cd $h && mvn -q -ff clean install
        cd ..
    fi
#vue if need 
for s in ${arr[@]}
do
    if [ "$s" == "fontend-vue" ]  ;then
       bash "~/ci/vue.sh"
    fi
done
```

Buildauto脚本最大的难度是需要用脚本判断9小时内更新过的代码所属webent并对其进行编译，而且需要先编译依赖包，再编译webent。
下面介绍deployauto的job，周一到周五每天11：58和晚上１０：５８自动构建发布（只对更新过但未发不的进行更新）。集合了以上2个job的工作。但是会调用deployauto.sh的脚本执行发布到tomcat的工作。

```js 
node {
    stage('pull') { // for display purposes
        sh "bash ~/ci/pull.sh"
   }
   stage('deploy') { // for display purposes
        sh "bash ~/ci/deployauto.sh"
   }
   stage('restart'){
       sh "bash ~/ci/restarTom.sh"
   }
}
```

deployauto.sh的内容：

```js 
#!/bin/bash
githome="/home/admin/gitCode/"
sitesPath="/arthas/sites/"
DATE=$(date +%Y%m%d%H%M)
softfile="/home/admin/gitCode/"
sitesbackup="/home/admin/sitesbackup/"
git_FE="/home/admin/ArthasMK_FE"
git_MK="/home/admin/gitCode/boy-smart-webent/src/main/webapp/WEB-INF/views/"

#设置环境变量
source /etc/profile
webents=(boy-aggregator boy-smart-webent boy-wm-msger boy-app-webent boy-job-webent boy-openApi boy-wm-webent boy-yum-webent boy-imgr-webent boy-uic-webent boy-qdragon-webent boy-sn-webent boy-intf-webent boy-kunlun-webent boy-imgr-rpc boy-yum-rpc boy-mdata-rpc boy-uic-rpc boy-sn-rpc)
longth=${#webents[@]}
RPM=0

#更新rpc
longthpub=`expr $longth - 5`
RPM=$longthpub
while [ $RPM -lt $longth ]  && [ $? -eq 0  ]
do
        if [ -f $softfile"${webents[$RPM]}/target/${webents[$RPM]}.jar" ]; then
                webentname=`echo ${webents[$RPM]}`
                siteName=`echo ${webentname#*-}`
        #判断是否存在webent，不存在则新建
                if [ ! -d  $sitesPath${siteName}  ]; then
                        echo "新建路径：${sitesPath}${siteName}"
                        mkdir -p $sitesPath${siteName}
                        #echo ${webents[$RPM]}|awk -F '-' '{print $2}'
                fi
                #执行代码更新操作
                echo "$siteName更新---------------------"
                kill -9 ${k}`ps -fe |grep $siteName |awk '{print $2}'|head -2`
                cd $sitesPath${siteName} && rm -fr `ls $sitesPath${siteName}` && echo "删除完成！"
                cp -r $softfile"${webents[$RPM]}/target/lib" $softfile"${webents[$RPM]}/target/${webents[$RPM]}.jar"  $sitesPath${siteName} && echo "$siteName解压完成！"
                nohup  java -Xms246m -Xmx500m -jar ${webents[$RPM]}.jar > ${webents[$RPM]}".log" &
                rm -fr $softfile"${webents[$RPM]}/target"
        fi
        let RPM++
done

#更新webent
RPM=1
longthpub=`expr $longth - 5`
while [ $RPM -lt $longthpub ]
do
        if [ -f $softfile"${webents[$RPM]}/target/${webents[$RPM]}.war" ]; then
                siteName=`echo ${webents[$RPM]}|awk -F '-' '{print $2}'`
                #判断是否存在webent，不存在则新建
                if [ ! -d  "$sitesPath${siteName}/ROOT"  ]; then
                        echo "新建路径：${sitesPath}${siteName}/ROOT"
                        mkdir -p "${sitesPath}${siteName}/ROOT"
                        #echo ${webents[$RPM]}|awk -F '-' '{print $2}'
                fi
                #执行代码更新操作
                echo "$siteName 更新---------------------"
                cd ${sitesPath}${siteName}"/ROOT" && rm -fr `ls -I shopInfo` && echo "删除完成！"
                unzip -q $softfile"${webents[$RPM]}/target/${webents[$RPM]}.war" -d $sitesPath${siteName}"/ROOT" && echo "$siteName解压完成！"
                rm -fr $softfile"${webents[$RPM]}/target"
        fi
        let RPM++
done
```

最后写了个手动发布的job，该job用来手动发版，工作和deployauto干的一样，但是可以提供给其他开发使用。
最后贴一张手动发布的效果图出来：
![这里写图片描述](/images/dn.net-20170506183004352-watermark-2-text-aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2luZGFuY2hhb3M=-font-5a6L5L2T-fontsize-400-fill-I0JBQkFCMA==-dissolve-70-gravity-SouthEast.png)
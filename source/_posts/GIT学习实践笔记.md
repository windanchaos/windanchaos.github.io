---
title: GIT学习实践笔记
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 持续集成

date: 2017-01-11 21:04:46
---
分支管理
git pull origin A:B
git branch –set-upstream-to=origin/develop develop
实践：
拉取远程代码到本地：
git pull origin release/Mandy_final:Mandy_final
要更新代码，使用：git pull origin Mandy_final
提示“fatal: Couldn’t find remote ref Mandy_final”
不知道原因，假设git pull 分支的时候，origin 之后的分知名不是本地的，而是远端的。
验证假设：
git branch –set-upstream-to=origin/release/Mandy_final Mandy_final
git pull命令直接到代码
git pull origin Mandy_final还是之前提示。
因此我自动发版脚本中的拉取代码的**前提**是要保证本地分支名必须和远端分支名保持一致：
```js 
git pull origin `git status |awk '{print $4}'|head -1`
```

**git fetch：相当于是从远程获取最新版本到本地，不会自动merge**

```js 
Git fetch origin master
git log -p master..origin/master
git merge origin/master
```

**git pull：相当于是从远程获取最新版本并merge到本地**
执行分支拉取最好使用git fetch ，否则在多个分支当中切换会导致不必要的merge错误。

git branch -r
git branch -a
git checkout -b mybranch origin/mybranch

git status

/#清理本地分支（远程仓库已经不存在的分支）
git remote prune origin
<!-- more -->

/#本地所有修改的。没有的提交的，都返回到原来的状态
git checkout .

/#把所有没有提交的修改暂存到stash里面。可用git stash pop恢复。
git stash

/#返回到某个节点，不保留修改。
git reset –hard HASH

/#返回到某个节点。保留修改
git reset –soft HASH

/#查看时间段的修改
git log –since=”2016-11-11” –before=”2017-01-06” filepath

/#查看最近修改.-p 选项展开显示每次提交的内容差异，用 -2 则仅显示最近的两次更新
git log –since=”2016-12-25” -p File |grep diff | awk ‘{print $4}’ |awk -F ‘b/’ ‘{print $2}’
以上命令，列出了时间之后，某文件夹下修改过的文件列表。在具体使用中，这个命令解决了静态资源部署的问题，消除了每次更新发版，不管静态文件是否修改过，都要全部上传到cdn的问题。

/#回退历史版本
git reset –hard 3628164（commit号）

**git add -A和 git add . git add -u在功能上看似很相近，但还是存在一点差别**
git add . ：他会监控工作区的状态树，使用它会把工作时的所有变化提交到暂存区，包括文件内容修改(modified)以及新文件(new)，但不包括被删除的文件。
git add -u ：他仅监控已经被add的文件（即tracked file），他会将被修改的文件提交到暂存区。add -u 不会提交新文件（untracked file）。（git add –update的缩写）
git add -A ：是上面两个功能的合集（git add –all的缩写）

Git diff 可以查看当前没有add 的内容修改（不在缓冲区的文件变化）

git diff –cached查看已经add但没有commit 的改动（在缓冲区的文件变化）

git diff HEAD 是上面两条命令的合并

**放弃本地修改**
git checkout . //放弃本地修改，没有提交的可以回到未修改前版本
git clean是从工作目录中移除没有track的文件.
通常的参数是git clean -df:
-d表示同时移除目录,-f表示force,因为在git的配置文件中, clean.requireForce=true,如果不加-f,clean将会拒绝执行.

**不同分支的同一个文件覆盖**

如何从其他分支merge指定文件到当前分支，git checkout 是个合适的工具。
```js 
git checkout source_branch <path>...
```

example:

```js 
git branch
  * A  
    B

git checkout B message.html message.css message.js other.js
```

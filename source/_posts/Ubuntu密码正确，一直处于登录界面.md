---
title: Ubuntu密码正确，一直处于登录界面
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Linux管理维护

date: 2016-11-07 21:04:37
---
if you had used “apt-get update”….
the new update contains some bugs for nvidia drivers….
To slove:
1.get the nvidia software

```js 
sudo dpkg -l |grep nvidia
```
```js 
rc  nvidia-304                               304.132-0ubuntu0.16.04.2                      amd64        NVIDIA legacy binary driver - version 304.132
rc  nvidia-opencl-icd-304                      304.132-0ubuntu0.16.04.2                      amd64        NVIDIA OpenCL ICD
rc  nvidia-settings                            361.42-0ubuntu1                               amd64        Tool for configuring the NVIDIA graphics driver
```

2.remove nvidia all

```js 
sudo apt-get remove nvidia-opencl-icd-304 nvidia-304 nvidia-settings
```

3.restart your computer

```js 
init 6
```
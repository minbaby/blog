---
title: "修改机器名"
date: 2017-11-06T14:47:04+08:00
lastmod: 2018-08-12T14:47:04+08:00
draft: false
keywords: []
description: ""
tags: []
categories: [devops]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: true
toc: true
autoCollapseToc: false
postMetaInFooter: true
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: true
mathjax: false
mathjaxEnableSingleDollar: false
mathjaxEnableAutoNumber: false

# You unlisted posts you might want not want the header or footer to show
hideHeaderAndFooter: false

# You can enable or disable out-of-date content warning for individual post.
# Comment this out to use the global config.
#enableOutdatedInfoWarning: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

[TOC]

## Centos

### 第一步

`sudo vim /etc/sysconfig/network`

修改其中的

`HOSTNAME=your-server-name`



### 第二步

在 `/etc/hosts` 添加映射

`sudo vim /etc/hosts`

`127.0.0.1 your-server-name`

### 第三步

使用 `sudo hostname your-server-name` 修改当前 session

### 第四步

重启网络

`sudo /etc/init.d/network restart`

## Ubuntu 配置

### 第一步
简单粗暴 直接使用  ` sudo hostnamectl set-hostname your-server-name` 即可

### 第二步


在 `/etc/hosts` 添加映射

`sudo vim /etc/hosts`

`127.0.0.1 your-server-name`


----
PS:
有注意到都有进行配置 hosts，这是因为如果不配置的话，会出现 Warning, 可能会出现难以排查的问题。

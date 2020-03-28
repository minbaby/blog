---
title: "群晖修改 docker 源"
date: 2020-03-28T18:34:52+08:00
lastmod: 2020-03-28T18:34:52+08:00
draft: false
keywords: [群晖, Docker, Syno, NAS]
description: ""
tags: [NAS, 群晖, Docker]
categories: [NAS]
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

typora-root-url: ../../../static/
---

## 修改配置文件

```bash
vi /var/packages/Docker/etc/dockerd.json
```  

### 可以看到如下配置

```json
{
   "data-root" : "/var/packages/Docker/target/docker",
   "log-driver" : "json-file",
   "registry-mirrors" : []
}
```
### 改为如下即可

```json
{
   "data-root" : "/var/packages/Docker/target/docker",
   "log-driver" : "json-file",
   "registry-mirrors" : []
}
```

## 完成配置之后重启群晖 docker 组件

```bash
synoservice --restart pkgctl-Docker
```

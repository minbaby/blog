---
title: k8s-microk8s-proxy
date: 2022-10-24T07:34:19Z
lastmod: 2022-10-24T07:34:19Z
draft: false
keywords: [k8s,microk8s,proxy]
description: ""
tags: [k8s,microk8s,proxy]
categories: [k8s]
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
> 在安装 k8s 的过程中，一部分镜像是在 gcr 上的，无法直接访问，所以需要使用代理方式访问。
<!--more-->
1. `sudo vim /etc/environment`(全局代理) or `sudo vim /var/snap/microk8s/current/args/containerd-env` (仅代理容器)
2. 增加如下代码（如果没有的话）
    ```bash
    HTTPS_PROXY=http://squid.internal:3128
    HTTP_PROXY=http://squid.internal:3128
    NO_PROXY=10.0.0.0/8,192.168.0.0/16,127.0.0.1,172.16.0.0/16
    https_proxy=http://squid.internal:3128
    http_proxy=http://squid.internal:3128
    no_proxy=10.0.0.0/8,192.168.0.0/16,127.0.0.1,172.16.0.0/16
    ```

3. 重启
    ```bash
    microk8s stop
    microk8s start
    ```

## 参考

- [MicroK8s - Installing behind a proxy](https://microk8s.io/docs/install-proxy)


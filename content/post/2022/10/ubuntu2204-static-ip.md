---
title: "Ubuntu 2204 配置固定 IP"
date: 2022-10-24T09:12:54Z
lastmod: 2022-10-24T09:12:54Z
draft: false
keywords: [linux, netplan, ubuntu, ubuntu2204]
description: ""
tags: [linux, netplan, ubuntu, ubuntu2204]
categories: [ubuntu, linux]
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
## 临时配置

1. 配置网卡 IP
    ```bash
    sudo ip addr add 192.168.111.3/24 dev eth0
    ```
1. 启用网卡
    ```bash
    sudo ip link set dev eth0 up # 启用网卡
    sudo ip link set dev eth0 down # 禁用网卡
    ```
1. 配置默认网关
    ```bash
    sudo ip route add default via 192.168.111.1
    ```

## 永久配置

1. 编辑 `/etc/netplan/99_config.yaml` (yaml 写成 yml 似乎不生效)
2. 写入如下信息
    ```yaml
    network:
      version: 2
      #  renderer: networkd
      ethernets:
        eth0:
          addresses:
            - 192.168.111.3/24
          gateway4: 192.168.111.1
          nameservers:
            addresses: [192.168.111.1]
    ```
1. 应用
    ```bash
    sudo netplan --debug apply
    ```

## 参考

- [Network - Configuration | Ubuntu](https://ubuntu.com/server/docs/network-configuration)

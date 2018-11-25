---
title: "Install Ufw on Centos"
date: 2015-06-10T12:40:17+08:00
lastmod: 2018-11-25T18:47:17+08:00
draft: true
keywords: [ubuntu, centos, debain, ufw, iptables, linux]
description: ""
tags: [centos, ufw, linux]
categories: [linux]
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
## [UFW][1] 介绍:
```
Ufw stands for Uncomplicated Firewall, 
and is program for managing a netfilter firewall. 
It provides a command line interface and aims to be uncomplicated and easy to use.
```

这个工具是 debian/ubuntu 上比较简单的防火墙工具, 是 iptables 的封装. 对 iptalbes 操作的简化.

## [UFW][1] 安装
这个工具在 debian/ubuntu 上安装比较简单
```
sudo apt-get install ufw
```

由于对于 iptables 不熟悉,所以希望在 Centos 上使用 ufw 工具,进行防火墙管理.

安装[UFW][1]

```bash
# root 账户下
cd /usr/local/src
wget https://launchpad.net/ufw/0.33/0.33/+download/ufw-0.33.tar.gz
tar zxvf ufw-0.33.tar.gz
cd ufw-0.33
python setup.py install

# 解决 WARN: /etc/default/ufw is group writable!
chmod -R g-w /etc/ufw /lib/ufw /etc/default/ufw /usr/local/sbin/ufw
ln -s /usr/local/sbin/ufw /usr/bin/ufw
```

## [UFW][1]使用方法

### 开启
```bash
ufw enable
```

### 允许 22 (ssd服务, 防止意外断开连接,导致无法连接到服务器)
```bash
ufw allow 22
```

### 默认拒绝所有访问
```bash
ufw default deny
```

### 查看防火墙状态
```bash
ufw status
```

### 允许访问 80 ( web server 默认端口)
```bash
ufw allow 80 
```

### 允许从 IP 192.168.1.1 访问所有端口
```bash
 ufw allow from 192.168.1.1 
```

### 复杂的用法
```bash
# 要拒绝所有的TCP流量从10.0.0.0/8 到192.168.0.1地址的22端口
ufw deny proto tcp from 10.0.0.0/8 to 192.168.0.1 port 22
#可以允许所有RFC1918网络（局域网/无线局域网的）访问这个主机（/8,/16,/12是一种网络分级）：
sudo ufw allow from 10.0.0.0/8
sudo ufw allow from 172.16.0.0/12
sudo ufw allow from 192.168.0.0/16
```

参考:  [UFW防火墙简单设置][2]

[1]:https://launchpad.net/ufw/
[2]:http://wiki.ubuntu.com.cn/UFW%E9%98%B2%E7%81%AB%E5%A2%99%E7%AE%80%E5%8D%95%E8%AE%BE%E7%BD%AE
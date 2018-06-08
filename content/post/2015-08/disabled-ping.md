---
title: "Disabled Ping"
date: 2015-08-11T12:50:50+08:00
lastmod: 2018-06-08T12:50:50+08:00
draft: true
keywords: []
description: ""
tags: [linux, ping]
categories: [linux]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
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

```bash
sudo echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
sudo sysctl -p
```
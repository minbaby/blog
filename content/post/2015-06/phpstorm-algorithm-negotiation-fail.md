---
title: "PhpStorm: Algorithm negotiation fail"
date: 2015-06-30T22:59:00+08:00
lastmod: 2018-11-25T19:18:00+08:00
draft: false
keywords: []
description: ""
tags: []
categories: []
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
事情是酱紫的,我用 phpstorm 通过 sftp 协议连接我一台服务器的时候报错

```bash

Algorithm negotiation fail
```

第一次遇到这个问题, 并通过 [stackoverflow][1] 搜索解决.

## 解决方法

1. 编辑 /etc/ssh/sshd_config 文件

```bash

vim /etc/ssh/sshd_config
```

2. 在文件末尾加入如下配置(首先确认配置文件不存在该配置项)

```bash

KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
```

3. 重启 sshd

```bash

serivce sshd restart
```

  [1]: http://stackoverflow.com/questions/28612875/phpstorm-algorithm-negotiation-fail

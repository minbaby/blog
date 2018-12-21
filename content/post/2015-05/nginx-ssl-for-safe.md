---
title: "跟风使用 SSL"
date: 2015-05-19T17:54:47+08:00
lastmod: 2018-11-25T19:10:47+08:00
draft: false
keywords: [nginx, ssl, safe]
description: ""
tags: [nginx, ssl]
categories: [safe]
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

随着互联网的不断发展, 安全越来越受到大家重视, 互联网中的通讯由于是历史原因默认使用的是明文传输方式.
现在大家都呼吁使用 SSL, 来加密 web 服务中的客户端和服务器的通讯.

为了跟风和那绿色的小锁, 取免费 [沃通数字证书][1] 证书.

申请过程就不详细叙述了, 自己网上找找.

申请完成后会收到其邮件(包含证书下载地址). 
下载解压, 然后把 nginx 目录下的文件上传到服务器相应目录(eg. /home/minbaby/ssl/your.domain.com/)

1. /home/minbaby/ssl/your.domain.com/your.domain.com.crt
2. /home/minbaby/ssl/your.domain.com/your.domian.com.key

```bash

server {
  server_name your.domain.com;
  rewrite ^(.*) https://$server_name$1 permanent;
}
```

我们把 80(http 协议默认端口) 的端口重定向到443(ssl 协议默认端口)

```bash

server {
  listen 443;
  server_name your.domain.com;
  
  ssl on;
  ssl_certificate /home/minbaby/ssl/your.domain.com/your.domain.com.crt; 
  ssl_certificate_key /home/minbaby/ssl/your.domain.com/your.domian.com.key;
}
```

  [1]: https://buy.wosign.com/free/FreeSSL.html

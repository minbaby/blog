---
title: "删除 nginx 版本 和 php 的 x-power-by"
date: 2015-09-06T16:26:38+08:00
lastmod: 2018-11-26T23:29:38+08:00
draft: false
keywords: [nginx, php, version, x-power-by]
description: ""
tags: [nginx, php]
categories: [nginx, php]
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

## 隐藏Nginx版本号

Nginx的版本号主要在两个地方会有，一个是HTTP header，有个Server:nginx/1.x.x类似会暴露Web服务器所用软件名称以及版本号，这个也是大多数Web服务器最容易暴露版本号的地方，第二个地方是Nginx出错页面，比如404页面没有找到等，这是如果用户没有指定页面的话，那么Nginx自己的页面会有版本戳记。

```nginx
http {
    # ...省略一些配置
    server_tokens off;
}
```

## 隐藏PHP的版本号

PHP容易暴露的版本号在什么地方呢？其实也是在HTTP头，以类似X-Powered-By: PHP/5.2.11这种形式存在，大家可能会想到会不会是Nginx问题，而去到Nginx里面找相关配置，呵呵，其实这个是在PHP的配置文件php.ini里改动

```ini
;;;;;;;;;;;;;;;;;
; Miscellaneous ;
;;;;;;;;;;;;;;;;;

; Decides whether PHP may expose the fact that it is installed on the server
; (e.g. by adding its signature to the Web server header).  It is no security
; threat in any way, but it makes it possible to determine whether you use PHP
; on your server or not.
; http://php.net/expose-php
; 改为 Off 就可以了
expose_php = On
```
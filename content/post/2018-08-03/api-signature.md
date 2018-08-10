---
title: "Api Signature"
date: 2018-08-03T19:11:07+08:00
lastmod: 2018-08-03T19:11:07+08:00
draft: false
keywords: [api, signature, safe, 安全]
description: ""
tags: [api, signature, safe]
categories: [api,safe]
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

## 规则

接口需要四个公共参数

- X-Nonce
- X-Time
- X-Token
- X-Sign

这四个参数是需要在  __Header__  上发送

| 参数 | 说明 | 长度 | 必须 |
| --- | --- | --- | --- |
| X-Nonce  | 随机字符串 | 16 | 是 |
| X-Time   | 时间戳 | 10 | 是 |
| X-Sign   | lower(sha1("{{固定常量}}:{{X-Nonce}}:{{X-Time}}:{{data}}”)) |40| 是 |

## 能够防护的攻击方式

- 参数修改 （对method,params 等进行 hash）
- 重放攻击 （记录请求时间戳+随机值）

## 签名校验 data 算法

常用请求 METHOD，

### GET

```text
a=b&c=d&e=f
```

get 请求需要对参数进行排序然后

php 部分使用 [ksort](http://php.net/manual/zh/function.ksort.php) 进行排序

```text
uri => /v1/user/{id}
http_build_str => a=b&c=d
data = upper(method)+uri+http_build_str(ksort(get_params))
```

### POST

有两部分参数 1：url参数， 2：body参数

```text
data = upper(method)+uri+http_build_str(ksort(get_params))+http_build_str(ksort(post_params))
```

### PUT

```text
data = upper(method)+uri+http_build_str(ksort(get_params))+http_build_str(ksort(post_params))
```

### DELETE

```text
data = upper(method)+uri+http_build_str(ksort(get_params))
```

## 写在最后

本方案只是解决了，api 接口容易被人利用

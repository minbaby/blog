---
title: "traefik2.0 启用 api"
date: 2019-10-16T16:03:27Z
lastmod: 2019-10-16T16:03:27Z
draft: false
keywords: [traefik, api, api.insecure, 架构, docker]
description: ""
tags: [traefik, api, api.insecure, 架构, docker]
categories: [traefik, 架构]
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

[TOC]

## 在traefit2.0 启用 dashboard



 traefik 2.0 提供了一个比 1.0 更加友好的一个 dashboard。如下图

![Dashboard - Providers](/images/traefik2.0-dashboard/webui-dashboard.png) 



开启方式也很简单：

### 命令行

` --api.dashboard=true `

### traefik.yaml 配置文件

```yaml
api:
  # Dashboard
  #
  # Optional
  # Default: true
  #
  dashboard: true
```

### traefik.toml 配置文件

```toml
[api]
  # Dashboard
  #
  # Optional
  # Default: true
  #
  dashboard = true
```

## 遇到的问题

如果只是这些的话就没有必要写这篇博客了。

按照上边的配置出来的 dashboard 我们是无法直接访问的。

###  安全的方式

当配置完上边之后，内部已经有了一个叫做 `api@internal` 的服务，我们只需要配置一个路由指向这个服务即可。

```yaml
labels:
  - "traefik.http.routers.api.rule=PathPrefix(`/api`) || PathPrefix(`/dashboard`)"
  - "traefik.http.routers.api.service=api@internal"
  - "traefik.http.routers.api.middlewares=auth"
  - "traefik.http.middlewares.auth.basicauth.users=test:$$apr1$$H6uskkkW$$IgXLP6ewTrSuBkTrqE8wj/"
```

这个路由会拦截 `/api` 和 `/dashboard`，如果是这个路由的话，就会执行 `basic auth` 中间件，来保护 dashboard。

### 不安全的方式

```yaml
api:
  dashboard: true
  insecure: true
```

这个时候就可以 ` http://<Traefik IP>:8080/dashboard/ ` 来直接访问了。

## 问题总结

其实这是一个热乎乎的，坑爹故事。文档我翻了好多遍，Google 也搜了好多。也看到了上边的配置，**但是**这个配置要写到那里呢？主要是对这个软件使用不熟悉导致的，可以在 `traefik.yml` 配置文件中定义，也可以在 `docker-compose` `lables` 中配置，这就是一个特殊的内置服务，我们只需要给它配一个路由+认证中间件即可。

## 参考文档

-  [https://docs.traefik.io](https://docs.traefik.io/) 
---
title: "使用 hugo 搭建博客"
date: 2018-06-11T22:13:53+08:00
lastmod: 2018-06-11T22:13:53+08:00
draft: true
keywords: []
description: ""
tags: [hugo, blog, 博客, github]
categories: [hugo]
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

## 辛酸历程

一路走来用过 `wordpress`, `typecho` 等等博客。这些博客都需要使用到DB，需要自己拥有一个虚拟机，搭建 `nginx+php+mysql` 环境。

最近觉的这种方式搭建既费时又费事，搭建需要`搞一搞`, 又需要维护数据库，如果切换服务器，又需要`搞一波`。感觉就是 `累觉不爱`。

这个时候想起了 [Github Pages](https://pages.github.com/)，简单粗暴(方便)。

## Github Pages

github 很贴心的为我们这些程序员提供了静态网站托管服务，来作为项目主页。省去了自己购买域名，购买服务器，配置环境等等过程。有了 Github Pages 之后，我们需要简单的操作一波就可以搞定了。

### project home pages （项目主页）

现在很多开源软件都托管在 `github` 上，比较用心的作者一般都会为自己的程序做一个~~精致~~，有意义的**官网**。

TODO: 这里需要整理一下配置流程

### user or organization home page （用户或者组织主页）

TODO: 这里需要整理一下配置流程
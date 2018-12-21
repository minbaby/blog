---
title: "gitalk"
date: 2018-06-16T16:16:48+08:00
lastmod: 2018-09-24T11:50:48+08:00
draft: true
keywords: []
description: ""
tags: [gitalk, hugo, blog]
categories: [blog]
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

之前一直是自己弄的动态博客，自己弄服务器什么的。最大的问题是，不知道哪天心情不好了，就想换个博客程序，或者哪天忘了续费域名，或者服务器...

犹豫了很久决定使用 github 老哥提供的功能(pages)，简单方便。

迫于 **静态博客**，只能曲线救国了，评论这东西虽然没什么大用，但是聊胜于无吗 。

我使用的这个模板，支持 `gitment` 和 `gitalk`，经过一番对比（其实就是看谁好看），选择了 `gitalk`。

## 官方定位

> Gitalk 是一个基于 GitHub Issue 和 Preact 开发的评论插件。

## 特性

- 使用 GitHub 登录
- 支持多语言 [en, zh-CN, zh-TW, es-ES, fr, ru]
- 支持个人或组织
- 无干扰模式（设置 distractionFreeMode 为 true 开启）
- 快捷键提交评论 （cmd|ctrl + enter）

## 如何使用

### 直接引入

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css">
<script src="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js"></script>

<!-- or -->

<link rel="stylesheet" href="https://unpkg.com/gitalk/dist/gitalk.css">
<script src="https://unpkg.com/gitalk/dist/gitalk.min.js"></script>
```

### 使用 npm 依赖安装

``` bash
npm i --save gitalk
```

```javascript
import 'gitalk/dist/gitalk.css'
import Gitalk from 'gitalk'
```

### 页面使用

html部分只需要加入下边的容器

```html
<div id="gitalk-container"></div>
```

js部分如下

```js
var gitalk = new Gitalk({
  clientID: 'GitHub Application Client ID',
  clientSecret: 'GitHub Application Client Secret',
  repo: 'GitHub repo',
  owner: 'GitHub repo owner',
  admin: ['GitHub repo owner and collaborators, only these guys can initialize github issues'],
  id: location.pathname,
  distractionFreeMode: false 
})

gitalk.render('gitalk-container')
```

> 也就说这里，我们需要申请一个 [**GitHub Application**](https://github.com/settings/applications/new)

> 只需要简单的填写一下应用名称，主页，和回调地址即可，毕竟是自己使用

## 官方文档

> 中文文档 https://github.com/gitalk/gitalk/blob/master/readme-cn.md

---
title: "WSL 设置字体"
date: 2019-09-18T14:20:27Z
lastmod: 2019-09-18T14:20:27Z
draft: true
keywords: [font setting, tmux, vim, wsl, docker]
description: ""
tags: [wsl, docker]
categories: [wsl, docker]
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

## 前言

> 为什么需要这个设置？
>
> 当我们使用 WSL，的时候，默认的终端可以进行自定义字体和大小设置
>
> 但是当我们使用VIM或者tmux的时候会发现，终端似乎重置了一样，还原成默认字体和大小了。

![图片](/images/wsl-font-setting/1.png)

## 解决方案

```text
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage]
"ACP"="1252" (这个不要修改，会导致系统中有些程序乱码)
"MACCP"="10000"
"OEMCP"="437"
```
github 的 issue 里给出了解决方案，就是上边的配置，但是这里需要注意的点是 ACP 这个不要修改，因为 ACP=936 表示使用 `GB2316` 编码。 如果修改成 `ACP=1252` 有一些程序就会出现错误，例如：LOL（登录失败什么的，都是小事。）。


## 参考

- https://github.com/microsoft/Terminal/issues/177

{{% my %}}
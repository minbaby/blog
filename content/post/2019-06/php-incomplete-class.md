---
title: "Php Incomplete Class"
date: 2019-06-09T03:58:58Z
lastmod: 2019-06-09T03:58:58Z
draft: true
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
## 事件重现

在整理 sentry 报错的发现了一个奇怪的 bug。

```
The script tried to execute a method or
access a property of an incomplete object.
Please ensure that the class definition "XXXModel" of the object
you are trying to operate on was loaded _before_
unserialize() gets called or provide a __autoload() function
to load the class definition 
```

系统是采用 `lumen` 构建的，报错的逻辑的地方也没要什么特别的逻辑和写法。大概的写法如下。

```php
<?php

function logic()
{
  return \Cache::remeber('some-key', 10, function () {
    return XXXModel::query()->first();
  });
}

```

这个怎么看都是挺正常的一个逻辑，为啥会出现上边的报错呢？


## 原因

> 最根本的原因是，php 的反序列化函数 `unserialize` 的时候 `XXXModel` 类没有被加载进来。

那么我们来进行一下情景重现。


## PS

才发现 php还有一个这么神奇的类 `__PHP_Incomplete_Class`，
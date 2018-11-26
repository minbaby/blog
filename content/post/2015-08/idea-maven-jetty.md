---
title: "idea 配置 maven jetty run"
date: 2015-08-14T00:09:16+08:00
lastmod: 2018-11-26T23:24:16+08:00
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

## 配置 command line

```ini
org.mortbay.jetty:maven-jetty-plugin:6.1.22:run
```

## 配置POM

```xml
<build>
    <finalName>admin</finalName>
    <plugins>
  <plugin>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-maven-plugin</artifactId>
    <version>9.2.1.v20140609</version>
        </plugin>
    </plugins>
</build>
```

## 修改端口

```ini
Runner选项->VM Options 设置 -Djetty.port=8081
```

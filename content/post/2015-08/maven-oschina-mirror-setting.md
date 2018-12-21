---
title: "maven oschina 源设置【推荐使用阿里云的源】"
date: 2015-08-13T17:26:32+08:00
lastmod: 2018-11-26T23:14:32+08:00
draft: false
keywords: [mvn, maven, oschina, java, aliyun]
description: ""
tags: [mvn, mavne, java]
categories: [java]
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

```xml
<!-- settings.xml -->
<mirror>
    <id>nexus-osc</id>
    <mirrorOf>*</mirrorOf>
    <name>Nexus osc</name>
    <url>http://maven.oschina.net/content/groups/public/</url>
</mirror>
```

```xml
<!-- pom -->
<repositories>
  <repository>
       <id>nexus</id>
    <name>local private nexus</name>
    <url>http://maven.oschina.net/content/groups/public/</url>
    <releases>
      <enabled>true</enabled>
    </releases>
    <snapshots>
        <enabled>false</enabled>
       </snapshots>
   </repository>  
</repositories>

<pluginRepositories>
  <pluginRepository>
    <id>nexus</id>
    <name>local private nexus</name>
    <url>http://maven.oschina.net/content/groups/public/</url>
       <releases>
         <enabled>true</enabled>
       </releases>
       <snapshots>
      <enabled>false</enabled>
    </snapshots>
  </pluginRepository>
</pluginRepositories>
```

```xml
！！！！ OSCHINA 的源已经关闭了， 这里推荐使用阿里云的源，http://maven.aliyun.com/nexus/content/groups/public/
```
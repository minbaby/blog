---
title: "phpbrew set mirror（加速）"
date: 2018-11-24T19:42:15+08:00
lastmod: 2018-11-24T19:42:15+08:00
draft: false
keywords: [phpbrew, mirror, 加速]
description: ""
tags: [php, phpbrew]
categories: [php phpbrew]
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
<!-- https://github.com/phpbrew/phpbrew/wiki/Cookbook#specifying-mirror-site -->
<!-- >  -->

> ## phpbrew 是一个构建、安装多版本 PHP 到用户根目录的工具。
>
>> ### phpbrew 能做什么？
>> - 支持使用 PDO，mysql，sqlite，debug 等不同「Variants」编译 PHP。
>> - 针对不同版本，分别编译 apache php 模块，互不冲突。
>> - 无需 root 权限将 PHP 安装到用户根目录。
>> - 集成至 bash / zsh shell 等，易于切换版本。
>> - 支持自动特性检测。
>> - 易于安装、启用 PHP 扩展。
>> - 支持在系统环境下安装多个 PHP。
>> - 路径检测针对 HomeBrew 以及 MacPorts 进行了优化。

中文文档：[phpbrew 中文](https://github.com/phpbrew/phpbrew/blob/master/README.cn.md)。比较坑的事情发生了，中文文档里边东西是不全的。

因为伟大的那堵墙，使用国外网站、工具的时候都是巨慢，这个时候都希望可以可以使用国内源进行加速。

经过一波查找。终于找到了[phpbrew-specifying-mirror-site](https://github.com/phpbrew/phpbrew/wiki/Cookbook#specifying-mirror-site)

```html
phpbrew 1.15 already shipped with the --mirror [URL] option, 
you may use the option to choose the mirror site instead of the default one:
```

自从　1.15　版本之后，可以使用　`--mirror [URL]` 选项来选择镜像网站代替默认地址。

例如

```bash
phpbrew i --mirror=http://cn2.php.net -d 7.1
```

可用的地址可以从 [php mirror](http://php.net/mirrors.php), 选一个好用的（国内的话就只有: http://cn2.php.net 了)
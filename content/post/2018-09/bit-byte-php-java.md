---
title: "Bit Byte Php Java"
date: 2018-09-05T19:39:56+08:00
lastmod: 2018-09-05T19:39:56+08:00
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

|英文    |缩写   |中文    |长度（位）|   java 类型  |
|:-----:|-------|:-----:|:-----: |:------:|
|bit    |b      |位     |1       | bool    |
|byte   |B      |字节    | 8      | byte   |

java 数据类型 （range 可能是错的，意会就好）

| 数据类型   | bit       | byte      |  range                                             | default  |
| :-------: | :-------: |:-------:  | :----------:                                       |:-----:   |
| byte      | 8         |   1       |-2^<sup>8</sup> ~ (2^<sup>7</sup>-1)                | 0        |
| short     | 16        |   2       |-2^<sup>16</sup> ~ (2^<sup>16</sup>-1)              | 0        |
| int       | 32        |   4       |-2^<sup>32</sup> ~ (2^<sup>32</sup>-1)              | 0        |
| long      | 64        |   8       |-2^<sup>64</sup> ~ (2^<sup>64</sup>-1)              | 0L       |
| float     | 32        |   4       |                                                    | 0.0F     |
| double    | 64        |   8       |                                                    | 0.0      |
| char      | 16        |   2       |'\u0000 ~ u\ffff'                                   | '\u0000' |
| boolean   | 1         |   1/8     |true/false                                          |   false  |

PHP ??? (好像类型，全靠 pack/unpack 过日子)

> 变量的类型通常不是由程序员设定的，确切地说，是由 PHP 根据该变量使用的上下文在运行时决定的。
> [参考](http://cn2.php.net/manual/zh/language.types.intro.php)

boolean (标量),
integer (标量),
float (标量),
string (标量),
array (复合类型),
object (复合类型),
callable (复合类型),
resource (资源),
NULL (无类型),
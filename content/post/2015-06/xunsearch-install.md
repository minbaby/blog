---
title: "xunsearch 安装"
date: 2015-06-27T14:34:08+08:00
lastmod: 2018-11-25T19:15:08+08:00
draft: true
keywords: [php, xunsearch, install]
description: ""
tags: [php, xunsearch, install]
categories: [php, xunsearch]
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

# xunsearch 安装
```sh
wget http://www.xunsearch.com/download/xunsearch-full-latest.tar.bz2
tar -xjf xunsearch-full-latest.tar.bz2
./setup.sh 安装

# 如果缺少 zlib.h
aptitude install zlib1g-dev
```
xunsearch 在当前版本不支持配置 data 目录
如果需要更改目录,可以使用软连接

```
+=================================================+
| Installation completed successfully, Thanks you |
| 安装成功，感谢选择和使用 xunsearch              |
+-------------------------------------------------+
| 说明和注意事项：                                |
| 1. 开启/重新开启 xunsearch 服务程序，命令如下： |
|    /usr/local/xunsearch/bin/xs-ctl.sh restart
|    强烈建议将此命令写入服务器开机脚本中         |
|                                                 |
| 2. 所有的索引数据将被保存在下面这个目录中：     |
|    /usr/local/xunsearch/data
|    如需要转移到其它目录，请使用软链接。         |
|                                                 |
| 3. 您现在就可以在我们提供的开发包(SDK)基础上    |
|    开发您自己的搜索了。                         |
|    目前只支持 PHP 语言，参见下面文档：          |
|    /usr/local/xunsearch/sdk/php/README
+=================================================+
```

在磁盘空间富裕的地方创建存储目录

```sh
mkdir -p /data/xunsearch/data
rm /usr/local/xunsearch/data ##请确认这个目录为空
ln -sf /data/xunsearch/data /usr/local/xunsearch/
```

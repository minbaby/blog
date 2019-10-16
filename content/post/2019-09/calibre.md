---
title: "[转]用到的calibre "
date: 2019-09-14T15:56:16Z
lastmod: 2019-09-14T15:56:16Z
draft: false
keywords: [calibre, tools, 自定义栏目, 自定义分类 , 自定义阅读状态]
description: ""
tags: [calibre, tools]
categories: [calibre, tools, 转发]
author: "suntus"

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

[calibre](https://calibre-ebook.com/) 是一个电子书管理器，最好的，没有之一。而且免费。

大概长这样：

![calibre](/images/calibre-category/1.png)

基本的导入导出就不再说了，主要介绍下用到的功能。

## 多级目录管理

建立像这样自定义的多级目录：

![multi category](/images/calibre-category/2.png)

首先，首选项—>添加栏目—>添加自定义栏目—>

![edit custom column](/images/calibre-category/3.png)

参考值：是搜索的时候用到的词，最好是英文

栏目标题：就是显示出来的顶级目录名

栏目类型：这里选择第二个：

![](/images/calibre-category/4.png)

确定—->应用—>重启calibre。

![restart application](/images/calibre-category/5.png)

然后，首选项—>界面外观—>标签浏览器，将刚刚定义的”suntus”定义为具有层次关系的分类。应用。

现在只是定义了顶层目录，还不会显示下级目录，下级目录在哪儿添加呢？


再然后，导入一本书，编辑该书的元数据—>自定义元数据，

![edit custom fields data](/images/calibre-category/6.png)

添加 `这里是吃饭的.编程语言.python`。calibre中的层级关系使用点来表示，这个就会形成这样的目录结构：

![category tree](/images/calibre-category/7.png)

你可以同时批量编辑好多书的元数据，把它们放到同一个目录下。好吧，其他更快捷的办法我暂时没找到。([PS1](#ps1))

## 筛选

> 注意([PS2](#ps2))

点击某个具有下级分类的分类的时候，calibre会有4中筛选的方法，依次显示为：

![加号](/images/calibre-category/8.png)

加号：只显示该分组中的书籍。

![加加号](/images/calibre-category/9.png)

加加号：显示该分组及以下分组的所有书籍。

![减号](/images/calibre-category/7.png)

减号：显示除该分组外的所有书籍，包括该分组以下分组的。

![减减号](/images/calibre-category/7.png)

减减号：显示除该分组及该分组以下分组外的所有书籍。

## 同步

收集到这么多的书，肯定不想丢啊，那就全都放到谷歌硬盘(15G免费空间)上吧。直接把书库放到同步盘上就好了，到另外的环境安装个calibre，导入书库，就什么都一模一样了，简直绝配。

>本文作者：suntus
>本文链接： 2017/09/13/用到的calibre/
>版权： 本站文章均采用 CC BY-NC-SA 3.0 CN 许可协议，请勿用于商业，转载注明出处！

----

## PS

### ps1

如何快速的把不同的书籍放在同一个目录，如下图

![批量修改书籍分类](/images/calibre-category/13.png)

按住 `Ctrl`， 鼠标左键选择不同的书籍，然后拖到到左侧的目录即可。

### ps2

如果不按照下边的方式筛选的话，则看不到目录结构

![排序方式-按照名称](/images/calibre-category/12.png)

### ps3 增加阅读状态

用calibre管理电子书的时候，有个问题每个人都会遇到：这本书我读过没有！

我是根据题主的方式增加了一个自定义列来搞定的，如下图，

![自定义状态-阅读状态](/images/calibre-category/14.png)

效果如图

![已读-正在读-未读](/images/calibre-category/15.png)
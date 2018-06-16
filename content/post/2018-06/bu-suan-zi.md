---
title: "不蒜子-简易网站统计"
date: 2018-06-16T16:17:09+08:00
lastmod: 2018-06-16T16:17:09+08:00
draft: false
keywords: []
description: ""
tags: [统计]
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

第一次看见这个 “不蒜子”，真的是一脸懵逼，从名字根本看不出来是个什么东西。用拼音输入法打出来也是 “卜算子”。

经过一番努力 ~~百度~~ 谷歌之后。找到了官网 [不蒜子](http://busuanzi.ibruce.info/)。 简洁到令人发指，一句话描述+嵌入脚本+访问量展示。已经能够粗略的知道这个是一个网站统计的东西了。但是我们不是有cnzz,有百度统计，有谷歌统计么？ 这又有啥优势啊？

打开作者关于这个的 [说明](http://ibruce.info/2015/04/04/busuanzi/)。 作者给自己的定义式这样子的。

```text
“不蒜子”与百度统计谷歌分析等有区别：“不蒜子”可直接将访问次数显示在您在网页上（也可不显示）；对于已经上线一段时间的网站，“不蒜子”允许您初始化首次数据。
```

## 安装

按照作者的初衷：`普通用户只需两步走：一行脚本+一行标签，搞定一切。追求极致的用户可以进行任意DIY。`。
所以安装起来会非常简单。唯一复杂的地方可能在于，这些数据要显示到哪里？已经如何更漂亮的显示这些数据了。

### 引入js文件

```javascript
<script async src="//dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
```

至于怎么引入，已经在 html 代码的什么位置引入的话。

简单说一下，上边的代码是使用异步的方式引入的，也就是说在支持异步加载js文件的浏览器来说是不会影响你的页面展示速度的，同样的统计数据也是异步获取展示的。

对于你的博客或者其他网站来说，只需要在公共文件里边加入上边的代码就算引入成功了。

### 安装标签（可选）

安装 js 之后，已经可以正常统计数据了，类似于百度统计之类的东西。

统计站点pv

```html
<span id="busuanzi_container_site_pv">
    本站总访问量<span id="busuanzi_value_site_pv"></span>次
</span>
```

统计站点uv

```html
<span id="busuanzi_container_site_uv">
  本站访客数<span id="busuanzi_value_site_uv"></span>人次
</span>
```

统计页面pv

```html
<span id="busuanzi_container_page_pv">
  本文总阅读量<span id="busuanzi_value_page_pv"></span>次
</span>
```


### 附录（自定义）

不蒜子之所以称为极客的算子，正是因为不蒜子自身只提供标签+数字，至于显示的style和css动画效果，任你发挥。

- busuanzi_value_site_pv （总访问量）
- busuanzi_value_site_uv （总访客数）
- busuanzi_value_page_pv （本文总阅读量）
- busuanzi_container_site_pv （可省略，防止不蒜子服务出现问题显示异常）

如果需要展示统计数据，只需要使用一个 div 然后把它的 id 设置成上边中的一个就好。

如果如果不需要展示数据，引入js之后你就完成了所有的工作。

如果想初始化（重置，装逼）统计数据的话，是需要注册一个账号然后才能修改自己网站数据的。然后毕竟让人 ~~蛋疼~~ 预料不到的状况是，注册需要邀请，不能直接注册。
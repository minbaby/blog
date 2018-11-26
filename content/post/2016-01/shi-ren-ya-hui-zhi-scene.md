---
title: "Shi Ren Ya Hui Zhi Scene"
date: 2016-01-02T20:51:44+08:00
lastmod: 2018-11-26T23:40:44+08:00
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

<p>写这篇日志的起因很简单, 在一天内, 发现了N个窃取别人劳动成果的东东.</p>

<h2 id="toc_0">一号  (<a href="https://github.com/dangcheng/Scene">Scene</a>)</h2>

<pre><code>Scene Framework
======

Scene 是一个开源、全栈、松耦合的、使用 Zephir/PHP 编写的高性能 PHP 框架，并同时发布 C扩展和PHP两个版本。两个版本除了实现方式不同以外，没有其他差异，您可以在没有管理员权限、开发测试环境和对性能要求不高的情况下使用PHP版本，生产环境下想要获得更高的性能，您可以使用C扩展。

License
======
Scene 基于MIT开源协议。
</code></pre>

<p>这段描述是项目 README.MD , 是不是很高大尚. </p>

<p>第一眼也觉得很好高大上, 但是回头一想不对呀, 这么牛逼的东西咋从没听过呢? 看后看了看代码量, 非常大, 不是一天两天能写完的. 这不正常!!!!!! </p>

<p>然后我注意到这个框架不是使用原生 C 写的扩展, 而是使用Zephir, 搜索之.... 得到了 <a href="https://github.com/phalcon/zephir">Phalcon Zephir</a>, 对! 你没看错就是号称, 速度最快, 最完善的, C 实现的 PHP 扩展.  So Search in Repository. 
<img src="media/14517390665391/14517401380753.jpg" alt="Instersting"/>￼</p>

<p>点一个进去看看</p>

<p><img src="media/14517390665391/14517403600944.jpg" alt=""/>￼</p>

<p>打开 Cphalcon 的 event\event.zep 文件看看收获惊人!!!!</p>

<p><img src="media/14517390665391/14517404103588.jpg" alt=""/>￼</p>

<p>看到没有, 惊人的相似, 连 DOC 注释中的空间命名都一样. 我只对作者说: &quot;亲, 试试 <code>grep -inr phlcon *</code> 吧&quot;</p>

<p>后注:
    没什么恶意, 也不去揣测作者的想法.
    cphlcon 是 <code>Phalcon is open source software licensed under the New BSD License. See the docs/LICENSE.txt file for more</code>
    而 Scene 是 <code>Scene 基于MIT开源协议。</code>
    我太不懂开源协议, 也没有正式发过什么开源作品. 但是总觉的这么做不太合适.
    如果侵犯了项目作者, <a href="https://blog.891125.com/about.html">请联系我</a>.</p>

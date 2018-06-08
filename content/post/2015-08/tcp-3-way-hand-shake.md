---
title: "TCP三次握手, 四次挥手"
date: 2015-08-22T12:56:39+08:00
lastmod: 2018-06-08T12:56:39+08:00
draft: true
keywords: []
description: ""
tags: [tcp, network]
categories: [network]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
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

![三次握手][3]

首先Client端发送连接请求报文，Server段接受连接后回复ACK报文，并为这次连接分配资源。

Client端接收到ACK报文后也向Server段发生ACK报文，并分配资源，这样TCP连接就建立了。


![四次挥手][4]

假设Client端发起中断连接请求，也就是发送FIN报文。

Server端接到FIN报文后，意思是说"我Client端没有数据要发给你了"，但是如果你还有数据没有发送完成，则不必急着关闭Socket，可以继续发送数据。
所以你先发送ACK，"告诉Client端，你的请求我收到了，但是我还没准备好，请继续你等我的消息"。

这个时候Client端就进入FIN_WAIT状态，继续等待Server端的FIN报文。

当Server端确定数据已发送完成，则向Client端发送FIN报文，"告诉Client端，好了，我这边数据发完了，准备好关闭连接了"。

Client端收到FIN报文后，"就知道可以关闭连接了，但是他还是不相信网络，怕Server端不知道要关闭，所以发送ACK后进入TIME_WAIT状态，如果Server端没有收到ACK则可以重传。

“Server端收到ACK后，"就知道可以断开连接了"。

Client端等待了2MSL后依然没有收到回复，则证明Server端已正常关闭，那好，我Client端也可以关闭连接了。Ok，TCP连接就这样关闭了！


  [1]: https://blog.891125.com/usr/uploads/2015/08/603326137.png
  [2]: https://blog.891125.com/usr/uploads/2015/08/3287062619.jpg
  [3]: https://dn-blog-891125-com.qbox.me/usr/uploads/2015/08/603326137.png
  [4]: https://dn-blog-891125-com.qbox.me/usr/uploads/2015/08/3287062619.jpg

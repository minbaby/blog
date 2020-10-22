---
title: "Jd K2 Keyboard"
date: 2020-10-22T05:51:06Z
lastmod: 2020-10-22T05:51:06Z
draft: false
keywords: [keyboard, jd, 京造, ubuntu, linux]
description: ""
tags: [keyboard, jd, 京造, ubuntu, linux]
categories: [ubuntu, linux]
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

typora-root-url: ../../../static/
---
## 问题

京造 K2 84键键盘，在ubuntu上遇到了一个神奇的问题，F1-F12 无法使用，按照其说明书使用 `fn+x+l` 进行多媒体和功能键动切换，emmm，没有生效，遂搜之～
<!--more-->
## 解决方法

### 临时解决方法

`echo 0 > /sys/module/hid_apple/parameters/fnmode`

### 永久解决方法

方法一(推荐)：

```bash
echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all
sudo reboot
```

方法二：

```bash
echo "module/hid_apple/parameters/fnmode = 2" | sudo tee -a /etc/sysfs.conf
sudo reboot
```

方法三：

```bash
echo 'echo 2 > /sys/module/hid_apple/parameters/fnmode' | sudo tee -a /etc/rc.local
sudo reboot
```

## 参考

- [https://help.ubuntu.com/community/AppleKeyboard#Change_Function_Key_behavior](https://help.ubuntu.com/community/AppleKeyboard#Change_Function_Key_behavior)
- [https://caosiyang.github.io/posts/2020/07/22/using-keychron-k6-on-manjaro/](https://caosiyang.github.io/posts/2020/07/22/using-keychron-k6-on-manjaro/)
- [https://d6s3.ac.cn/post/keychron-k2-on-linux/](https://d6s3.ac.cn/post/keychron-k2-on-linux/)

---
title: "vscode 快捷键 ctrl+e 在终端里无法使用的问题"
date: 2022-05-25T09:41:15Z
lastmod: 2022-05-25T09:41:15Z
draft: true
keywords: [vscode keybindings]
description: ""
tags: [vscode keybindings]
categories: [vscode keybindings]
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

## 背景介绍
在我配置的工作环境中，终端会自动提示之前输入过的的命令等等，这个时候不需要输入完整的命令，只需要 `ctrl+e` 即可自动输入灰色部分命令。但是在vscode的终端中的时候会呼出`转到文件`对话框。那我这方便的快捷输入方式就直接GG了。
![](/images/2022/05/vscode-ctrl+e/Pasted-image-20220525175028.png)
## 解决方案
1. `Ctrl+K Ctrk+S` 呼出键盘快捷键设置界面
2. `Alt+K` 或者使用录制按键的方式查找对应的 keybindings
3. 在转到文件这一条记录上右键，选择`更改 Wen 表达式` 然后输入 `focusedView != 'terminal'`， 也就是该快捷键只会在非终端中生效。
![](/images/2022/05/vscode-ctrl+e/Pasted-image-20220525174848.png)


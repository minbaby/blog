---
title: "彻底删除 GIT 中的大文件"
date: 2017-11-16T14:42:49+08:00
lastmod: 2018-08-12T14:42:49+08:00
draft: false
keywords: [git, big file]
description: ""
tags: [git]
categories: [git]
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

对于版本管理来说，你的每一个操作都会留下记录，可以在 history 中看到。那么当你提交一个文件，然后在下次提交的时候删除。虽然你再目录中已经看不到它了，但是！！！！！它还在你的仓库中， 像幽灵一样存在着，有名字，占用磁盘大小，占用网络带宽。

所以：请不要直接使用 `删除+提交` 的方式解决这个问题。

解决这个问题的最好方式是： 让它从版本中消失！

## 使用命令，删除文件历史
使用的时候在你仓库的目录中执行如下命令，记得把{path-to-your-remove-file} 替换成你的文件。注意文件要写完整路径，从仓库根目录开始，并且不以 / 头。

```bash
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch {path-to-your-remove-file}' --prune-empty --tag-name-filter cat -- --all
```

好了，当你开始执行上边的命令时候，你可以出去走一圈，喝点茶，跟同事聊聊天了。因为如果你的仓库提交记录非常多的时候，这个操作需要**非常**多的时间。我八千个提交执行了四十分钟。

![](media/15108327087264/15108336401558.jpg)

当你看到如下图的时候，表示你已经执行完成了。![](media/15108327087264/15108336568068.jpg)


## 执行完成之后
当执行完成之后，本地的仓库已经变成我们想象中的那样了。
但是，其他小伙伴的仓库还是老样子的。所以我们还需要如下方法解救他们。
	
### 推送代码到 repo，然后清理本地

```bash
git push origin master --force # 强制覆盖
git reflog expire --expire=now --all # 立刻将所有无法跟踪到的提交标记为已过期（以便垃圾回收工具可以回收）
git gc --prune=now # 执行垃圾回收，删掉无用的（刚刚我们清理掉的文件）
```
### 找到包含这个提交（SHA-1）的分支

```
git branch --contains <commit>
```

找对对应的分支之后，使用如下命令删除这些分支（记得找小伙伴确认一下不使用这些分支了）。

```
git push -d origin <branch_name> # 删除远端分支
git branch -d <branch_name> #删除本地分支
```

这样操作之后其他小伙伴执行 `git fetch -p` 就会自动删除不使用的远端分支。对应的本地分支注意不要再 push 了，不然又有可能吧删除的文件带回去。


### 其他小伙伴使用如下方式

这里使用 develop 分支进行实例操作， 记得替换成对应的分支，如果有多个分支还要使用的话记得。。。都操作一遍。

```
git fetch -f -p ## 拉去更新
git checkout develop ## 切换到提交代码的分支
git reset origin/develop --hard ## 重置代码到服务端版本
git reflog expire --expire=now --all ## 立刻将所有无法跟踪到的提交标记为已过期（以便垃圾回收工具可以回收）
git gc --prune=now  # 执行垃圾回收，删掉无用的（刚刚我们清理掉的文件）

```

## 结尾
似乎到这里已经完美解决了这个问题。不是么？不是！

我们不能保证所有小伙伴的本地分支都不包含该提交了，不然，万一哪一天哪个小伙伴又提交上去了就麻烦了。

所以：必须确保本地和远端没有任何分支可以跟踪到那次误传文件的提交。

参考链接：

- https://walterlv.oschina.io/git/2017/09/18/delete-a-file-from-whole-git-history.html
- http://niuyanjie.gitee.io/blog/%E4%B8%80%E4%B8%AA%E5%8E%8B%E7%BC%A9%E5%8C%85%E5%BC%95%E5%8F%91%E7%9A%84%E8%A1%80%E6%A1%88/
- http://www.hollischuang.com/archives/1708
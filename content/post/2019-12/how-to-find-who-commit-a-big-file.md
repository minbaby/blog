---
title: "如何定位一个大文件是谁提交的"
date: 2019-12-02T08:35:07Z
lastmod: 2019-12-02T08:35:07Z
draft: false
keywords: [find, git, big file]
description: ""
tags: [git]
categories: [git, 备忘]
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
## 背景

无意间发现项目中一个仓库特别大，按照正常的使用是不可能有那么大的文件的。决定探究一下如何排查谁体检了这个文件。

## 思路

### 第一步查找大文件

```bash
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"
```

得到如下结果

![查找大文件](/images/how-to-find-who-commit-a-big-file/1.jpg)

1. composer.lock 比较大完全可以理解，这里边存在很多依赖信息
2. dump.rdb 这个就不用解释了吧，redis 的持久化文件
3. 后三个看起来像是一个 rar 压缩包解压之后的东西

emmm... 这都是些什么呀。我想知道这个有多大，我想知道谁提交的，我想。。。。

### 看看文件有多大

```bash

# 单位是 KB
expr `git cat-file -s 51d6d014c23e2c6daacf79f8ae52b68d598cefd3` / 1024

# 单位是 MB
expr `git cat-file -s 51d6d014c23e2c6daacf79f8ae52b68d598cefd3` / 1024 / 1024
```

通过这个就可以看到如下的文件大小
![查看对应文件的大小](/images/how-to-find-who-commit-a-big-file/2.png)

只有 303k，还算是正常的。那需要关注的就变成了，为什么仓库里有 tar.gz 文件呢？

### 查找这个文件是谁提交的

```bash
#!/bin/sh
obj_name="$1"
shift
git log "$@" --pretty=format:'%T %h %s' \
| while read tree commit subject ; do
    if git ls-tree -r $tree | grep -q "$obj_name" ; then
        echo $commit "$subject"
    fi
done
```

把上边的文件保存到 `/tmp/check.sh`，然后我们就可以很 <s>开心</s> 缓慢的查找了 `/tmp/check.sh 51d6d014c23e2c6daacf79f8ae52b68d598cefd3`。

![查看对应文件的大小](/images/how-to-find-who-commit-a-big-file/3.png)

这个信息是这个 blob 存在于哪些commit中，左边的就是commitId， 右边的是 commit message。任务完成。

### PS

使用过程中出现了一些特殊情况

1. 有可能搜不到commit，具体情况我也不是很清楚
2. 搜索的文件在大量的commit中存在，导致无法有效排查。建议直接找到 master 分支上的commit，追溯即可。

## 如何避免类似事故

1. 不要使用 `git add .` 命令
2. 建议使用 git gui 工具，即使是老鸟在使用命令行的时候也可能犯浑。
3. 提交之前检查一下提交的文件已经修改是不是你需要的。
4. 这个东西删除起来很麻烦，如果真的发生了请参考 [彻底删除 GIT 中的大文件](https://minbaby.github.io/post/2017-11/big-file-in-git/)

## 参考

- [Which commit has this blob?](https://stackoverflow.com/questions/223678/which-commit-has-this-blob/223890#223890)
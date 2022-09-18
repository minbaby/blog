---
title: "yaml 复用"
date: 2022-09-18T03:40:03Z
lastmod: 2022-09-18T03:40:03Z
draft: false
keywords: [yaml yml 复用 继承 docker gitlab-ci k8s 配置文件]
description: ""
tags: [yaml yml 复用 继承 docker gitlab-ci k8s 配置文件]
categories: [备忘 yaml]
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

> 背景: 现在配置文件使用 yaml 的非常多，例如 docker-compose、k8s、gitlab-ci 等等，很多使用配置文件里有很多重复内容，如果简单粗暴的使用 `ctrl+c & ctrl+v` 就不够“优雅了”。

重复的内容可使从参考标记星号( * ) 复制到锚点标记（ & ）。

## 引用&替换

```yaml
---
receipt:     Oz-Ware Purchase Invoice
date:        2012-08-06
customer:
    given:   Dorothy
    family:  Gale
   
items:
    - part_no:   A4786
      descrip:   Water Bucket (Filled)
      price:     1.47
      quantity:  4

    - part_no:   E1628
      descrip:   High Heeled "Ruby" Slippers
      size:      8
      price:     133.7
      quantity:  1

bill-to:  &id001 # 起个名字
    street: | 
            123 Tornado Alley
            Suite 16
    city:   East Centerville
    state:  KS

ship-to:  *id001  # 使用引用的内容更新该节点

specialDelivery:  >
    Follow the Yellow Brick
    Road to the Emerald City.
    Pay no attention to the
    man behind the curtain.
```

## 引用&插入

```yaml
version: "3"

x-redash-service: &redash-service # 给这个节点起个名字，方便使用
  image: redash/redash:8.0.0.b32245
  env_file: env_file
  restart: unless-stopped
  networks: 
    - overlay-network-internal

services:
  server:
    <<: *redash-service # 使用前边定义的名字，把节点信息插入当前节点，这样就达成了复用效果
    command: server
    environment:
      REDASH_WEB_WORKERS: 4
    networks: 
      - overlay-network-internal
    ports:
      - 5000:5000
  scheduler:
    <<: *redash-service
    command: scheduler
    environment:
      QUEUES: "celery"
      WORKERS_COUNT: 1
  scheduled_worker:
    <<: *redash-service
    command: worker
    environment:
      QUEUES: "scheduled_queries,schemas"
      WORKERS_COUNT: 1
  adhoc_worker:
    <<: *redash-service
    command: worker
    environment:
      QUEUES: "queries"
      WORKERS_COUNT: 2

networks: 
    overlay-network-internal:
        external: true

```

## 参考

- [YAML - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/YAML)
- [The Official YAML Web Site](https://yaml.org/)

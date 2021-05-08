---
title: "用工作流的思维方式, 思考 需求/功能 实现"
date: 2021-05-08T05:33:40Z
lastmod: 2021-05-08T05:33:40Z
draft: false
keywords: [workflow, FSM, state machine, symfony, laravel]
description: ""
tags: [php, symfony, laravel, workflow]
categories: [php]
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

> 代码地址：https://github.com/extra-demo/workflow-demo

最近项目流程重构，在思考如何更合理的解耦，方便理解，后续方便扩展和维护。

## FSM（[有限状态机](https://zh.wikipedia.org/wiki/%E6%9C%89%E9%99%90%E7%8A%B6%E6%80%81%E6%9C%BA)）

先简单对这个概念做个解释
> 有限状态机（英语：finite-state machine，缩写：FSM）又称有限状态自动机（英语：finite-state automation，缩写：FSA），简称状态机，是表示有限个状态以及在这些状态之间的转移和动作等行为的数学计算模型。 

1. 状态存储关于过去的信息，就是说：它反映从系统开始到现在时刻的输入变化。转移指示状态变更，并且用必须满足确使转移发生的条件来描述它。
2. 动作是在给定时刻要进行的活动的描述。有多种类型的动作： 
    1. <b>进入动作（entry action）：在进入状态时进行</b>
    2. <b>退出动作（exit action）：在退出状态时进行</b>
    3. <b>输入动作：依赖于当前状态和输入条件进行</b>
    4. <b>转移动作：在进行特定转移时进行</b>

<!--more-->

## 场景虚拟
> 人物：1. 管理员，客户，设计师 <br />
> 操作：1. 设计师上传提案，管理员提交给客户，客户确认，客户拒绝等

### 普通方式
第一步：创建提案，待设计师上传提案 （state=10)
第二步：设计师上传提案，待管理员提交给客户 （state=20)
第三步：管理员提交给客户，待客户确认 （state=30)
第四步：客户确认 or 客户拒绝 or 管理员代操作 （state=40)

然后我们会按照这个逻辑把代码，把相关的条件等等，写在一起。

### 状态机方式
状态机方式等核心是先梳理状态，然后梳理动作，通过动作来完成状态迁移。

状态：
1. 初始状态（已创建，初始态）
2. 提案已上传
3. 提案已提交给客户
4. 提案确认（终止态）
5. 提案失败（终止态）
6. 关闭（终止态）

动作：
1. 上传提案
2. 提交提案给客户
3. 客户确认
4. 客户拒绝
5. 管理员代确认
6. 关闭

动作+状态，对应完成之后可以得到如下状态图

<img src="/images/new-way-to-design-flow/ti_an.png">

## symfony workflow

简介

## 代码实现

代码在：https://github.com/extra-demo/workflow-demo

我们使用的 workflow 组件是 symfony 的 workflow，为了在 laravel 框架使用，使用了一个[适配 laravel-workflow](https://github.com/zerodahero/laravel-workflow)

### 集成 laravel-workflow

以官方文档为准

### 配置 workflow

<img src="/images/new-way-to-design-flow/workflow-config.png" />

### 使用 Listener，来做 Transition 迁移前中后动作，以及守卫动作

当我们执行 Transition 等时候，大多数时候是有条件等，例如这个场景下， `上传提案` 这个Transition触发等时候，需要提案已经被上传。如果使用之前逻辑实现的时候，则需要在执行前，进行判断，当多个相同操作触发或者检测的时候，需要多次调用这个，如果使用 `symfony workflow` 的时候只需要使用事件注册 `guard` 事件，即可 `守卫` 住该 Transition, 所有需要触发这个 Transition 的都会使用 gurad 检测。

注意：listenrer中不能使用异常的方式返回被阻塞的原因，因为不是只有 Trigger Transition 的时候会触发 guard 事件, 当检测 `can` 是否可以执行的时候也会触发这个事件，所以只能使用如下方式完成。

<img src="/images/new-way-to-design-flow/listener.png" />

### 编写方法，根据操作或者定时器等方式，触发 Transition

<img src="/images/new-way-to-design-flow/trigger-transition.png" />


## 参考

- https://github.com/zerodahero/laravel-workflow




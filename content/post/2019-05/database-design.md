---
title: "库表结构设计"
date: 2019-05-13T06:56:20Z
lastmod: 2019-05-25T10:32:20Z
draft: false
keywords: [表结构设计, 库结构设计, 数据库设计, ER图, 范式, 反范式, 字段]
description: ""
tags: [mysql, table design, database design, er]
categories: [mysql, database]
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

## 关系数据库设计范式

> 关系数据库设计范式的目的是：减少数据库中数据冗余，增进数据的一致性

### 三大范式

#### 1NF

第一正规化是为了要排除 重复组 的出现，所采用的方法是要求数据库的每个列的值域都是由原子值组成；每个字段的值都只能是单一值 (关系型数据库一定满足)

常见问题：

1. 单个字段存多个值
2. 用很多字段来表达同一个事实

如图

| 人 | 不喜欢的食物|
| ------ | ------ |
| JIM | Liver, Goat's cheese |
| Alice | Pheasant, Liver, Peas |

| 人 | 不喜欢的食物1 | 不喜欢的食物2 | 不喜欢的食物3 |
| ------ | ------ | ------ | ------ |
| JIM | Liver | Peas| Goat's cheese |
| Alice | Pheasant | Liver, Peas | Liver|

| uid | 地址 |
| ------ | ------ |
| 1 | 北京市朝阳区来广营 |
| 2 | 北京市丰台区小红门 |

#### 2NF

在满足1NF的前提上, 如果依赖于主键，则需要依赖于所有主键，不能存在依赖部分主键的情况

不合理:

| 订单编号| 商品编号 | 商品名称 | 数量 | 单位 | 价格 | 客户  | 所属单位 | 联系方式 |
| ----   | ----   | ----    |  --- | --- | ---   | ---- | ---   | ---     |
|  001   | 1      | 挖掘机   |  1   |台   | 100   | 张三  | 上海农业 | 110    |
|  001   | 2      | 冲击钻   |  8   |把   | 200   | 张三  | 上海农业 | 110    |
|  003   | 3      |  铲车    |  2   |辆   | 500   | 李四  | 北京工业 | 119    |

#### 3NF

在满足1NF和2NF的前提上, 一个数据库表中不包含已在其它表中已包含的非主关键字信息

#### 4、5、6NF 范式，BC 范式

### 反范式

反范式顾名思义，就是出现违反范式的情况，只不过有一些我们主动触发的，有一些是被动触发的。那我们应该至尊寻范式设计吗？

事实是，完全的范式化和完全的反范式化schema都是实验室里才有的东西：在真实世界中很少会这么极端地使用。

那我们什么情况下会主动违反范式设计呢？

> 性能！

遵循范式的优势

- 范式化更新操作通常比反范式化要快。
- 范式化只有很少或者没有重复数据
- 范式化表结构通常更小

劣势

- 分散的数据查询需要连表，性能差
- 部分场景需要使用 sql 聚合函数计算出结果， 性能差 （点赞数，点赞人等）

#### 反范式常见操作

反范式一般违反的是范式三，也就是除了关联主键之外，其他表也存在非主键信息，也就是所谓的冗余。

- 缓存表
- 汇总表
- 冗余字段

## ER 模型

E-R图也称实体-联系图(Entity Relationship Diagram)，提供了表示实体类型、属性和联系的方法，用来描述现实世界的概念模型。ER图分为实体、属性、关系三个核心部分。实体是长方形体现，而属性则是椭圆形，关系为菱形。

### ER图中关联关系有三种：

- 1对1（1:1） ：1对1关系是指对于实体集A与实体集B，A中的每一个实体至多与B中一个实体有关系；反之，在实体集B中的每个实体至多与实体集A中一个实体有关系。

- 1对多（1:N） ：1对多关系是指实体集A与实体集B中至少有N(N>0)个实体有关系；并且实体集B中每一个实体至多与实体集A中一个实体有关系。

- 多对多（M:N） ：多对多关系是指实体集A中的每一个实体与实体集B中至少有M(M>0)个实体有关系，并且实体集B中的每一个实体与实体集A中的至少N（N>0）个实体有关系。

图例：
![ER图](/images/e-r/1.png)

### ER的实体还会细分为弱实体和复合实体

__弱实体__ ：一个实体必须依赖于另一个实体存在，那么前者是弱实体，后者是强实体，弱实体必须依赖强实体存在，例如上图的学生实体和成绩单实体，成绩单依赖于学生实体而存在，因此学生是强实体，而成绩单是弱实体。

弱实体和强实体的联系必然只有1：N或者1：1，这是由于弱实体完全依赖于强实体，强实体不存在，那么弱实体就不存在，所以弱实体是完全参与联系的，因此弱实体与联系之间的联系也是用的双线菱形。

图例：

![弱实体](/images/e-r/2.png)

__复合实体__ ：复合实体也称联合实体或桥接实体，常常用于实现两个或多个实体间的M：N联系，它由每个关联实体的主键组成，用长方体内加一个菱形来表示。

图例：

![复合实体](/images/e-r/3.png)

### ER属性补充

__ER图的属性可以细分为复合属性、多值属性和派生属性、可选属性，同时还有用来表示联系的属性，称为联系属性。__

__复合属性(composite attribute)__ ：复合属性是指具有多个属性的组合，例如名字属性，它可以包含姓氏属性和名字属性：

![复合属性(composite attribute)](/images/e-r/4.png)

__多值属性（multivalued attribute）__：一个实体的某个属性可以有多个不同的取值，例如一本书的分类属性，这本书有多个分类，例如科学、医学等，这个分类就是多值属性， 用双线椭圆表示。

![多值属性（multivalued attribute）](/images/e-r/5.png)

__派生属性(derivers attribute)__：是非永久性存于数据库的属性。派生属性的值可以从别的属性值或其他数据（如当前日期）派生出来，用虚线椭圆表示。

![派生属性(derivers attribute)](/images/e-r/6.png)

__可选属性(optional attribute)__：并不是所有的属性都必须有值，有些属性的可以没有值，这就是可选属性，在椭圆的文字后用（O）来表示，如下图的地址就是一个可选属性。

![可选属性(optional attribute)](/images/e-r/7.png)

__联系属性__：联系属于用户表示多个实体之间联系所具有的属性，一般来讲M:N的两个实体的联系具有联系属性，在1:1和1：M的实体联系中联系属性并不必要。

![联系属性](/images/e-r/8.png)

## 常见优化

### 字段类型

- 数值
![数值](/images/e-r/9.png)

- 字符串

![字符串](/images/e-r/10.png)

- 时间

![时间](/images/e-r/11.png)

- 复合类型

  - ENUM
  - SET

### 选择规则

- 合理范围内最小的
- 数据类型最简单的
- 不要使用 null (???)
- 字段长度固定或者相近则使用 char 代替 varchar

小问题： int(10) 和 int(1) 有什么区别

参考链接：

- [数据库ER图基础概念整理](https://zhuanlan.zhihu.com/p/29029129)
- [Mysql设计与优化专题](https://www.kancloud.cn/thinkphp/mysql-design-optimalize)
- [数据库范式](https://zh.wikipedia.org/wiki/%E6%95%B0%E6%8D%AE%E5%BA%93%E8%A7%84%E8%8C%83%E5%8C%96)
- [E-R图](https://baike.baidu.com/item/E-R%E5%9B%BE)
- [ER模型](https://zh.wikipedia.org/wiki/ER%E6%A8%A1%E5%9E%8B)
---
title: "Mysql Collation 校验对于索引的影响"
date: 2018-07-27T13:21:18+08:00
lastmod: 2018-07-27T13:21:18+08:00
draft: false
keywords: [mysql，collation, index]
description: ""
tags: [mysql，collation, index]
categories: [mysql]
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

## 起因

最近线上出现了一个奇怪的问题：用户昵称字段使用了唯一索引，但是在 sentry 中经常收到昵称冲突的错误。 这种异常错误引起了我的兴趣，决定探一个究竟。

## 探究

我们在使用 mysql 过程中，一般创建表会使用如下：

```sql
CREATE TABLE users
(
    id int PRIMARY KEY AUTO_INCREMENT,
    nick_name varchar(20)
);
CREATE UNIQUE INDEX users_nick_name_uindex ON users (nick_name);
```

我们没有显示声明使用的字符集和校验类型，那么这个表就是使用默认值。我们看一下默认值是什么：

```
mysql> select * from information_schema.SCHEMATA where SCHEMA_NAME='test';
+--------------+-------------+----------------------------+------------------------+----------+
| CATALOG_NAME | SCHEMA_NAME | DEFAULT_CHARACTER_SET_NAME | DEFAULT_COLLATION_NAME | SQL_PATH |
+--------------+-------------+----------------------------+------------------------+----------+
| def          | test        | utf8mb4                    | utf8mb4_general_ci     | NULL     |
+--------------+-------------+----------------------------+------------------------+----------+
1 row in set (0.22 sec)
```

那么字符集为: utf8mb4, 字符校验为: utf8mb4_general_ci。

往表中分别插入 Abcd 和 abcd

```sql
mysql> INSERT INTO `test`.`users` (`nick_name`) VALUES ('Abcd');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO `test`.`users` (`nick_name`) VALUES ('abcd');
ERROR 1062 (23000): Duplicate entry 'abcd' for key 'users_nick_name_uindex'
```

通常意义上来讲，Abcd 和 abcd 肯定不是同一个字符串，但是对于添加了 unique 索引，字符集为 utf8mb4,字符校验为 utf8mb4_general_ci 的表来说，他们是一样的！！！WTF!

再试一下：

```sql
mysql> select * from `test`.`users` where nick_name like '%abcd%';
+----+-----------+
| id | nick_name |
+----+-----------+
|  4 | Abcd      |
+----+-----------+
1 row in set (0.23 sec)

mysql> select * from `test`.`users` where nick_name = 'abcd';
+----+-----------+
| id | nick_name |
+----+-----------+
|  4 | Abcd      |
+----+-----------+
1 row in set (0.02 sec)
```

WTF!!!，完全和预期不一样了啊。到底咋回事呢？

## 解释

### 字符集: utf8mb4

字符集简单说就是数据库用什么编码来存储你的数据，就像我们写代码一般都是用 UTF8存取一样，为了兼容各种字符我们一般会选取utf8格式(注意 mysql 中的 utf8 并不是真正的 utf8, utf8mb4才是)。

### 字符校验: utf8mb4_general_ci。

可以理解为进行特殊比较用的，

| Suffix | Meaning |
| --- | --- |
|_ai  | Accent insensitive |
|_as  | Accent sensitive |
|_ci  | Case insensitive |
|_cs  | case-sensitive |
|_ks  | Kana sensitive |
|_bin | Binary |

按照上表的话，我们默认的字符校验规则就是忽略大小写的。所以出现奇怪问题也不能怪 mysql， 只能说我们知识不足啊。

----


参考：

- [Collation Naming Conventions](https://dev.mysql.com/doc/refman/8.0/en/charset-collation-names.html)
- [mysql case sensitive in utf8_general_ci](https://stackoverflow.com/questions/18737805/mysql-case-sensitive-in-utf8-general-ci)

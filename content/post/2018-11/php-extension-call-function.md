---
title: "如何调用 php 自定义函数或者其他扩展的函数"
date: 2018-11-19T23:19:16+08:00
lastmod: 2018-11-19T23:19:16+08:00
draft: true
keywords: [php extension, "call user function"]
description: ""
tags: [php, extension]
categories: [php-extension]
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

## 前言
> 最近在学习 php extension 开发，在某些情况下需要调用到用户自定义方法或者其他扩展的方法。

## 原理
`call_user_function` 是 php 底层提供的一个方法，可以**动态**的调用**函数**。这里的函数就是说的 php 函数，也就是说要导出成 php 的函数才能被调用。如果是 c 语言函数那么就可以直接在扩展中调用方法了，不需要使用这个方法。

## 解释

我们看一下这个方法的函数原型：　

`call_user_function(function_table, object, function_name, retval_ptr, param_count, params)`

- `function_table` 该函数已经被废弃，之所以没有被移除，应该是为了兼容性。
- `zval *object`, 如果调用的是对象的方法，则这个 object　则是类的实例。反之使用 NULL。
- `zval *function_name`, 调用的函数的名字。
- `zval *retval_ptr`,　函数执行完成之后的返回值。
- `uint32_t param_count`, 执行的函数有几个参数。
- `zval params[]`, 执行的函数的参数。

## 代码示例

```c
PHP_METHOD(Stringy, length)
{
    zval func = {}, args[1] = {}, rv = {};
    zval *value;
    ZVAL_STRING(&func, "mb_strlen");

    value = zend_read_property(stringy_ce, getThis(), "str", strlen("str"), 0, &rv);

    args[0] = *value;

    call_user_function(NULL, NULL, &func, return_value, 1, args);
}
```

## 参考
 
- [php-ext-start](https://github.com/minbaby/php-ext-startup)

<!--more-->

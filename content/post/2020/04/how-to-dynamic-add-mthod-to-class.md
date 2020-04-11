---
title: "如何动态的给类增加方法"
date: 2020-04-11T21:57:50+08:00
lastmod: 2020-04-11T21:57:50+08:00
draft: false
keywords: [php, closure, dynamic, class, method, function, bind, bindTo]
description: ""
tags: [php]
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


## 前言

之所以写这篇博客，是因为写 http demo 的时候的时候，用到了 `laravel` 里边的 `validation` 组件，按照老版本的方式调用 `$this->validate()` 的时候，找不到这个方法了，所以就看了一下文档，发现 `laravel >= 5.5` 之后，调用方法转移到 `Request` 实例去了，即 [framework/Request.php at 7.x · laravel/framework · GitHub](https://github.com/laravel/framework/blob/7.x/src/Illuminate/Http/Request.php)。有一个细节是这个方法是用 `phpdoc` 的方式标注出来的, 也就是说这个方法不是直接放置在类中的，找了一下确实没有找到。 经过 `grep` 之后找到了 ([framework/FoundationServiceProvider.php at 7.x · laravel/framework · GitHub](https://github.com/laravel/framework/blob/7.x/src/Illuminate/Foundation/Providers/FoundationServiceProvider.php)), 发现这个是通过 `macro` 方式动态添加进去的, 那如何动态添加一个方法到类里边呢？


## 开工探索

### First Try, 直接动态赋值给对象
作为一个动态语言，第一想法就是实例化的时候动态赋值进去。其实这样是不可以的，因为我们使用 `$obj->echo = function () {}` 的时候其实是给一个变量赋值了一个方法。

1. 声明一个类

```php
<?php
class FirstClass {

}
```

2. 一个单元测试

```php
<?php
class FirstClassTest extends TestCase
{
    /**
     * @var FirstClass
     */
    private $obj;

    protected function setUp(): void
    {
        $this->obj = new FirstClass();
        $this->obj->hello = function () {
            return '我是动态添加的';
        };
    }

    protected function tearDown(): void
    {
        $this->obj = null;
    }

    public function testMethodNotFound()
    {
        $this->expectExceptionMessage('Call to undefined method');
        $this->obj->hello();
    }

    public function testCallMethod()
    {
        $func = $this->obj->hello;
        $this->assertSame(true, is_callable($func));

        $this->assertSame('我是动态添加的', ($this->obj->hello)());
    }
}

```

从单元测试中可以看出来，`$this->hello` 其实就是一个 `closure`, 并不是一个 `method`。


### Second Try 使用 `__call` 动态调用

1. 声明一个类

```php
<?php
class SecondClass
{
    protected static $macros = [];

    protected $current;

    public function __construct($current = null)
    {
        $this->current = $current ?? time();
    }

    /**
     * @param string $name
     * @param callable $callable
     * @throws Exception
     */
    public static function macro(string $name, $callable)
    {
        static::$macros[$name] = $callable;
    }

    public function __call($name, $arguments)
    {
        if (!isset(static::$macros[$name])) {
            throw new Exception("method $name not found");
        }

        /** @var Closure $macro */

        $macro = static::$macros[$name];

        if ($macro instanceof Closure) {
            return call_user_func($macro, ...$arguments);
        }


        return $macro(...$arguments);
    }
}
```


2. 来一个单元测试

测试一下是否可行

```php
<?php
class SendClassTest extends TestCase
{

    public function testCallEcho()
    {
        SecondClass::macro('echo', function () {
            return 'hello world!';
        });

        $obj = new SecondClass();
        $this->assertSame('hello world!', $obj->echo());
    }

    public function testCallEchoWithArgs()
    {
        SecondClass::macro('echo', function (...$args) {
            $arg = implode("|", $args);
            return "hello world!\nargs: {$arg}";
        });

        $args = [];
        foreach (range(0, 100) as $y) {
            $args[] = rand(0, 100);
        }

        $obj = new SecondClass();
        $this->assertSame(
            "hello world!\nargs: " . implode("|", $args),
            $obj->echo(...$args)
        );
    }
}
```


似乎成功了是不是？如果不是所有 `$this` 的话，确实成功了, 我们来看下边这个测试

```php
<?php
class SendClassTest extends TestCase
{
    /**
     * @throws \Exception
     */
    public function testCallEchoAndUseThisInFunc()
    {
        SecondClass::macro('echo', function () {
            $current = date("Y-m-d H:i:s", $this->current);
            return "hello world! now: $current";
        });

        $obj = new SecondClass();
        $this->expectException(Notice::class);
        // 注意，这里报错的类是本测试类， SendClassTest, 也是就 this 绑定异常 了
        $this->expectExceptionMessage('Undefined property: Minbaby\ExtraDemo\Blog\Test\BindMethodToClass\SendClassTest::$current');
        $obj->echo();
    }
    }
}
```

当我们在动态添加的函数中，试图获取成员属性的时候提示未定义，且 `$this` 是指向单元测试这个类的，而不是实例化的类。

一脸问号？？？

### Third Try binding of $this

为啥和我们预期都不一样的，明明直接在类中写匿名函数的时候 `$this` 回绑定到实例上，动态附加上去的跟我们预期的不一样呢？

> Automatic binding of $this

因为 php 偷偷帮你做了一个 `$this` 绑定，但是当你动态添加的时候，因为匿名函数不是在类中声明的，所以不会做这个绑定，也就是如果我们加上这个绑定，`$this` 指向就对了。

```php
<?php
class ThirdClass
{
    protected static $macros = [];

    protected $current;

    public function __construct($current = null)
    {
        $this->current = $current ?? time();
    }

    /**
     * @param string $name
     * @param callable $callable
     * @throws Exception
     */
    public static function macro(string $name, $callable)
    {
        static::$macros[$name] = $callable;
    }

    public function __call($name, $arguments)
    {
        if (!isset(static::$macros[$name])) {
            throw new Exception("method $name not found");
        }

        /** @var Closure $macro */

        $macro = static::$macros[$name];

        if ($macro instanceof Closure) {
            $macro = Closure::bind($macro, $this, static::class);
            return call_user_func($macro, ...$arguments);
        }


        return $macro(...$arguments);
    }
}
```
测试代码

```php
<?php

class ThirdClassTest extends TestCase
{
    /**
     * @throws \Exception
     */
    public function testCallEchoAndUseThisInFunc()
    {
        ThirdClass::macro('echo', function () {
            $current = date("Y-m-d H:i:s", $this->current);
            return "hello world!now: {$current}";
        });

        $current = time();

        $obj = new ThirdClass($current);
        $current = date("Y-m-d H:i:s", $current);
        $this->assertSame("hello world!now: $current", $obj->echo());
    }
}
```


## 后记



其实我不是太喜欢这种"黑魔法", 核心问题就是会把类搞得了乱七八杂，导致找一个方法的时候很麻烦。

## 参考

- laravel macro
- [PHP: Closure - Manual](https://www.php.net/manual/zh/class.closure.php)
- [PHP: 匿名函数 - Manual](https://www.php.net/manual/zh/functions.anonymous.php)
- [php-demo-for-blog/src/BindMethodToClass at master · extra-demo/php-demo-for-blog · GitHub](https://github.com/extra-demo/php-demo-for-blog/tree/master/src/BindMethodToClass)

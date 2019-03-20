---
title: "Design Pattern"
date: 2019-03-20T02:47:14Z
lastmod: 2019-03-20T02:47:14Z
draft: false
keywords: [设计模式, design-pattern]
description: ""
tags: [php, design-pattern]
categories: [php, design-pattern]
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

## 设计模式是什么？

设计模式（design pattern）是对软件设计中普遍存在（反复出现）的各种问题，所提出的解决方案。

所以设计模式不是固定的，也不是一成不变的，会根据实际项目的演变而演变。也不是说某些大牛制定的设计师模式是什么样子的，而是在实际项目中，为解决普遍存在的问题而总结的经验。

## 常见设计模式

### 创建型模式

- 抽象工厂
- 构造器
- 工厂方法
- 原型
- 单例模式

### 结构型模式

- 适配器
- 桥接
- 组合
- 装饰
- 外观
- 享元
- 代理

### 行为型模式

- 职责链
- 命令
- 翻译器
- 迭代器
- 中介者
- 回忆
- 观察者
- 状态机
- 策略
- 模板方法
- 参观者

## 详解

### 单例模式

单例的核心思想是什么？

```php
<?php

class TestSingleton {
    private static $instance;

    public function getInstance()
    {
        if (!static::$instance) {
            return static::$instance;
        }

        return static::$instance = new static();
    }

    private function __construct(){}

    private function __clone(){}

    private function __sleep(){}
}
```

```java
public class Singleton {
    private static Singleton instance = null;

    private Singleton() {

    }

    public static Singleton getInstance() {
        if(instance == null){
            synchronized(Singleton.class){
                if(instance == null){
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

### 适配器

是什么，怎么用，什么场景用。

iPhone 手机， Android micro-usb, Android type-c 手机。分别需要 lighting接口, micro-usb, type-c 各种接口。

现在我有一个 usb 充电头， 一个 micro-usb 充电线，如果想给手机充电，要判断设备型号，然后使用适配器来搞定。

```php
<?php

interface LightingChargingIf 
{
    function chargeWithLighting();
}

interface TypeCIf 
{
    function chargeWithTypeC();
}


class AppleCharger implements LightingChargingIf 
{
    public function chargeWithLighting() 
    {
        echo "charge use lighting.", PHP_EOL;
    }
}

class AndroidChargerUseTypeC implements TypeCIf 
{
    public function chargeWithTypeC()
    {
        echo "charge use type-c.", PHP_EOL;
    }
}

abstract class Phone 
{
    abstract function charge();
}

class Mi8 extends Phone
{
    /**
     * @var TypeCIf
     */
    private $charger;

    public function __construct(TypeCIf $charger)
    {
        $this->charger = $charger;
    }

    public function charge()
    {
        $this->charger->chargeWithTypeC();
    }
}

class Iphone8 extends Phone
{
    private $charger;

    public function __construct(LightingChargingIf $charger)
    {
        $this->charger = $charger;
    }

    public function charge()
    {
        $this->charger->chargeWithLighting();
    }
}

class TypeCToLightingAdapter implements LightingChargingIf
{
    private $charger;

    public function __construct(TypeCIf $charger)
    {
        $this->charger = $charger;
    }

    public function chargeWithLighting() 
    {
        $this->charger->chargeWithTypeC();
        echo "charge use lighting with type-c adapter.", PHP_EOL;
    }
}


$appleCharger = new AppleCharger();
$typeCCharger = new AndroidChargerUseTypeC();

echo str_repeat('-', 100), PHP_EOL;
$myPhone = new Iphone8($appleCharger);
$myPhone->charge();
echo str_repeat('-', 100), PHP_EOL;
$myPhone = new Iphone8(new TypeCToLightingAdapter($typeCCharger));
$myPhone->charge();
```

### 观察者模式

```php
<?php

abstract class BaseSubject implements SplSubject
{
    private $objectList;

    public function __construct()
    {
        $this->objectList = new SplObjectStorage();
    }

    public function attach(SplObserver $observer): void 
    {
        $this->objectList->attach($observer);
    }
    public function detach (SplObserver $observer): void
    {
        $this->objectList->detach($observer);
    }
    public function notify(): void
    {
        foreach ($this->objectList as $observer) {
            $observer->update($this);
        }
    }
}

class UserRegisterSubject extends BaseSubject
{
    public $user;

    public function __construct(User $user)
    {
        $this->objectList = new SplObjectStorage();
        $this->user = $user;
    }

    public function attach(SplObserver $observer): void 
    {
        $this->objectList->attach($observer);
    }
    public function detach (SplObserver $observer): void
    {
        $this->objectList->detach($observer);
    }
    public function notify(): void
    {
        foreach ($this->objectList as $observer) {
            $observer->update($this);
        }
    }
}

class UserLogoutSubject extends BaseSubject
{
    private $objectList;

    public $user;

    public function __construct(User $user)
    {
        $this->objectList = new SplObjectStorage();
        $this->user = $user;
    }

    public function attach(SplObserver $observer): void 
    {
        $this->objectList->attach($observer);
    }
    public function detach (SplObserver $observer): void
    {
        $this->objectList->detach($observer);
    }
    public function notify(): void
    {
        foreach ($this->objectList as $observer) {
            $observer->update($this);
        }
    }
}

class SendRegisterObserver implements SplObserver
{
    public function update(SplSubject $subject)
    {
        echo sprintf("[sms] Hi guys, register success. id:%s, name: %s\n", $subject->user->id, $subject->user->name);
    }
}

class SendEmailObserver implements SplObserver
{
    public function update(SplSubject $subject)
    {
        echo sprintf("[email] Hi guys, register success. id:%s, name: %s\n", $subject->user->id, $subject->user->name);
    }
}

class User 
{
    public $id;
    public $name;

    public function __construct(int $id, string $name)
    {
        $this->id = $id;
        $this->name = $name;
    }
}


$user = new User(110, '抓人');
$user2 = new User(120, '救人');

# 注册两个人
$subject = new UserRegisterSubject($user);
$subject2 = new UserRegisterSubject($user2);

$smsObserver = new SendRegisterObserver();
$emailObserver = new SendEmailObserver();

// 110 发邮件 + 发短信
$subject->attach($smsObserver);
$subject->attach($emailObserver);

// 120 发短信
$subject2->attach($smsObserver);

# if 110 注册, 触发
$subject->notify();
# endif 

# if 120 注册, 触发
$subject2->notify();
# endif
```

## 参考资料

- [设计模式 (计算机)](https://zh.wikipedia.org/wiki/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F_(%E8%AE%A1%E7%AE%97%E6%9C%BA))
- [反面模式/反模式](https://zh.wikipedia.org/wiki/%E5%8F%8D%E9%9D%A2%E6%A8%A1%E5%BC%8F)
- [设计模式：可复用面向对象软件的基础](https://zh.wikipedia.org/wiki/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F%EF%BC%9A%E5%8F%AF%E5%A4%8D%E7%94%A8%E9%9D%A2%E5%90%91%E5%AF%B9%E8%B1%A1%E8%BD%AF%E4%BB%B6%E7%9A%84%E5%9F%BA%E7%A1%80)

----
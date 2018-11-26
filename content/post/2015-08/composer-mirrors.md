---
title: "Packagist / Composer  镜像"
date: 2015-08-05T08:52:18+08:00
lastmod: 2018-11-26T23:05:18+08:00
draft: false
keywords: [php, compsoer, packagist, laravel china, php composer]
description: ""
tags: [php, compsoer, packagist]
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

---

> 注意：http://packagist.phpcomposer.com 这个似乎出问题了，现在的建议使用这个https://packagist.laravel-china.org/

# 国外镜像太慢了, 太慢了, 慢了, 了

在全局或项目中添加

```json
{
    "repositories": [
        {"type": "composer", "url": "http://packagist.phpcomposer.com"},
        {"packagist": false}
    ]
}
```

## 例一 修改 composer 的全局配置文件

命令行中执行

```json
composer config -g repositories.packagist composer http://packagist.phpcomposer.com
```


## 例二 修改项目中的 composer.json 配置文件(laravel, 最后一个节点)

```json
{
    "name": "laravel/laravel",
    "description": "The Laravel Framework.",
    "keywords": ["framework", "laravel"],
    "license": "MIT",
    "type": "project",
    "require": {
        "php": ">=5.5.9",
        "laravel/framework": "5.1.*"
    },
    "require-dev": {
        "fzaninotto/faker": "~1.4",
        "mockery/mockery": "0.9.*",
        "phpunit/phpunit": "~4.0",
        "phpspec/phpspec": "~2.1"
    },
    "autoload": {
        "classmap": [
            "database"
        ],
        "psr-4": {
            "App\\": "app/"
        }
    },
    "autoload-dev": {
        "classmap": [
            "tests/TestCase.php"
        ]
    },
    "scripts": {
        "post-install-cmd": [
            "php artisan clear-compiled",
            "php artisan optimize"
        ],
        "pre-update-cmd": [
            "php artisan clear-compiled"
        ],
        "post-update-cmd": [
            "php artisan optimize"
        ],
        "post-root-package-install": [
            "php -r \"copy('.env.example', '.env');\""
        ],
        "post-create-project-cmd": [
            "php artisan key:generate"
        ]
    },
    "config": {
        "preferred-install": "dist"
    },
    "repositories": [
        {"type": "composer", "url": "http://packagist.phpcomposer.com"},
        {"packagist": false}
    ]
}
```

参考: [composer镜像][1]

  [1]: http://pkg.phpcomposer.com/

---
title: "Hyperf Metrics"
date: 2020-06-07T12:29:09Z
lastmod: 2020-06-07T12:29:09Z
draft: true
keywords: [hyperf, metrics, php, swoole, prometheus, grafana]
description: ""
tags: [hyperf, php, swoole]
categories: [hyperf, php, swoole]
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

## 代码地址

> [GitHub - extra-demo/hyperf-metrics-demo: hyperf-metrics-demo](https://github.com/extra-demo/hyperf-metrics-demo)


## 创建项目并集成组件

1. 创建 hyperf 项目
```bash
composer create-project hyperf/hyperf-skeleton hyperf-metrics-demo
```

一路默认即可，等待它安装完成

2. 集成组件

```bash
composer require hyperf/metric
```

3.  发布配置文件

```
php bin/hyperf.php vendor:publish hyperf/metric
```

4. 修改配置文件

修改 `/config/autoload/metric.php` 文件

```php
//before
'default' => env('METRIC_DRIVER', 'prometheus'),

//after
'default' => env('METRIC_DRIVER', 'noop'),

```

PS: 因为我们开发测试等环境是不需要进行监控的，所以修改默认配置为，不上报(noop do nothing)

PS2：如果你已经有了一个 hyperf 的项目，请检查一下版本是否为 ">=1.1.0"

## 快速启动 prometheus 监控系统

在项目 `docker` 目录中放置了用到的 `docker-compose.yml` 配置文件，和 `grafana` 图标配置文件。

1. 执行 `docker-compose up -d` 
   稍等一会，如果没有报错，就可以打开 `http://127.0.0.1:3000`了，首次打开需要自己配置一下账号密码
2. 添加数据源
  1
  ![4d427aa3.png](/images/hyperf-metrics-demo/4d427aa3.png)
  2
  ![5a44b02a.png](/images/hyperf-metrics-demo/5a44b02a.png)

3. 导入 `grafana.json`
   1
   ![00a5cebd.png](/images/hyperf-metrics-demo/00a5cebd.png)
   配置参数（app name 中的 `-` 会被替换成 `_`）
   ![646a5b46.png](/images/hyperf-metrics-demo/646a5b46.png)
4. 导入成功
   因为还没上报数据，所以这里会提示错误，先忽略就好。
   
   ![9f51068a.png](/images/hyperf-metrics-demo/9f51068a.png)

## 配置 hyperf

下边修改环境变量均是修改 `.env` 文件, 修改完成之后，需要重启 hyperf server。

1. `APP_NAME` 修改为 `extra-demo` 
2. 增加配置 `METRIC_DRIVER=prometheus`
3. 启动 server `php -f bin/hyperf.php start`

  这个时候我们就可以看到统计数据了
  
 ![17cd5fbd.png](/images/hyperf-metrics-demo/17cd5fbd.png)

### 启动 `MetricMiddleware`

在 `/config/autoload/middlewares.php` 中添加 `\Hyperf\Metric\Middleware\MetricMiddleware::class,`。

这个中间件能够记录 http 请求的 `status`, `path`, `method`， 如果你的路由太多，建议重写改中间件，否则可能会出现内存溢出错误。

![0eaa8a8c.png](/images/hyperf-metrics-demo/0eaa8a8c.png)


### 启动 `Mysql` 和 `Redis` 连接池监控

在 `/config/autoload/listeners.php` 中添加

- `\Hyperf\Metric\Listener\DBPoolWatcher::class,`
- `\Hyperf\Metric\Listener\RedisPoolWatcher::class,`


![3f1d54df.png](/images/hyperf-metrics-demo/3f1d54df.png)


## PS

docker compose 使用了 `host` 模式， 原因是，我们 docker 方式启动了 prometheus， 无法直接使用 `127.0.0.1` 访问在本机上的项目，如果不使用 `host` 模式, 要么项目也以 docker 方式启动，且使用和 prometheus 在同一个网段内。要么使用内网 ip 来访问项目。

## 参考文章

- [Hyperf](https://hyperf.wiki/#/zh-cn/metric)

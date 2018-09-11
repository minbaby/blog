---
title: "Laravel 框架记录执行时间并进行相关处理"
date: 2017-07-31T14:55:01+08:00
lastmod: 2018-08-12T14:55:01+08:00
draft: false
keywords: [laravel, execute time]
description: ""
tags: [laravel, php]
categories: [php, laravel]
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

只需要把下边的方法放在 bootstrap/app.php 文件即可。

```php
/*
|--------------------------------------------------------------------------
| 记录执行时间， 如果大于 3s 则把信息更新到 sentry
|--------------------------------------------------------------------------
*/

app()->terminating(function () {
    $handleCliInfo = function () {
        // 哪些命令不进行记录
        $except = [
            'queue:work'
        ];

        $info = with(new \Symfony\Component\Console\Input\ArgvInput())->getFirstArgument();

        return in_array($info, $except) ? '' : $info;
    };
    $start = request()->server('REQUEST_TIME_FLOAT'); // 脚本开始时间
    $end = microtime(true); // 当前方法执行时间，可以认为是结束时间
    $diff = $end - $start;
    if (env('MAX_EXECUTE_TIME', 3) <= $diff) { // 如果执行时间超过三秒则执行下边代码
        $info = app()->runningInConsole() ? $handleCliInfo() : app('request')->getPathInfo(); // 如果是
        if (!empty($info)) {
            app('sentry')->captureMessage(
                'Execute current is %ss (path: %s)',
                [
                    intval($diff),
                    $info
                ],
                [
                    'fingerprint' => [$info] // !!! 这里使用 fingerprint 参数解决所有 sentry message 都被集合在一条记录的问题
                ]
            );
        }
    }
});
```
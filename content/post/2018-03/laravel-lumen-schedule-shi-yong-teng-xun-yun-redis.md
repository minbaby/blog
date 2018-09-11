---
title: "laravel(lumen) schedule 使用腾讯云 redis 作为缓存出现的问题"
date: 2018-03-16T14:34:27+08:00
lastmod: 2018-08-12T14:34:27+08:00
draft: false
keywords: [php, laravel, lumen, schedule, redis, qcloud, 腾讯云]
description: ""
tags: [php, laravel, lumen, redis]
categories: [php, laravle, lumen, redis]
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

api 项目上线之后 sentry 上收集到了一个奇怪的问题。

```text
Predis\Response\ServerExceptionvendor/predis/predis/src/Client.php in onErrorResponse

errorERR unknown command ' EVAL 'php
```

看到这个 `EVAL` 这个命令，感觉是因为使用 lua 的原因，但是项目中我们又没有在 redis 中使用  lua 脚本，这个就很奇怪了。（腾讯的 redis 服务阉割了许多命令： https://cloud.tencent.com/document/product/239/13419）

排查调用栈如下:

```text
Predis\Response\ServerException: ERR unknown command ' EVAL '
#24 vendor/predis/predis/src/Client.php(370): onErrorResponse
#23 vendor/predis/predis/src/Client.php(335): executeCommand
#22 vendor/predis/predis/src/Client.php(315): __call
#21 vendor/illuminate/redis/Connections/Connection.php(72): eval
#20 vendor/illuminate/redis/Connections/Connection.php(72): command
#19 vendor/illuminate/redis/Connections/Connection.php(84): __call
#18 vendor/illuminate/cache/RedisStore.php(129): eval
#17 vendor/illuminate/cache/RedisStore.php(129): add
#16 vendor/illuminate/cache/Repository.php(219): add
#15 vendor/illuminate/console/Scheduling/CacheMutex.php(37): create
#14 vendor/illuminate/console/Scheduling/Event.php(170): run
#13 vendor/illuminate/console/Scheduling/ScheduleRunCommand.php(59): fire
#12 vendor/illuminate/console/Scheduling/ScheduleRunCommand.php(0): call_user_func_array
#11 vendor/illuminate/container/BoundMethod.php(30): Illuminate\Container\{closure}
#10 vendor/illuminate/container/BoundMethod.php(87): callBoundMethod
#9 vendor/illuminate/container/BoundMethod.php(31): call
#8 vendor/illuminate/container/Container.php(539): call
#7 vendor/illuminate/console/Command.php(182): execute
#6 vendor/symfony/console/Command/Command.php(252): run
#5 vendor/illuminate/console/Command.php(168): run
#4 vendor/symfony/console/Application.php(946): doRunCommand
#3 vendor/symfony/console/Application.php(248): doRun
#2 vendor/symfony/console/Application.php(148): run
#1 vendor/laravel/lumen-framework/src/Console/Kernel.php(84): handle
#0 artisan(35): null
```

看起来是 `Schedule` 的 `CacheMutex` 类中的 `create` 方法 使用了某些 lua 脚本导致的。

继续往下追踪的话会发现, 这个是使用了 `Illuminate\Contracts\Cache\Repository` 中的 `add` 方法。 这个方法的描述为 `Store an item in the cache if the key does not exist.`。 不存在 key 的话，就把数据存进去。

追踪进实现之后发现了有这么个逻辑, 缓存驱动可以实现一个 `add` 方法， 来实现原子性操作。

```text
        // If the store has an "add" method we will call the method on the store so it
        // has a chance to override this logic. Some drivers better support the way
        // this operation should work with a total "atomic" implementation of it.
        if (method_exists($this->store, 'add')) {
            return $this->store->add(
                $this->itemKey($key), $value, $minutes
            );
        }
```

因为我们使用了 Redis 作为缓存， 那么只需要看 `Illuminate\Cache\RedisStore` 中的 add 方法。

```text
    /**
     * Store an item in the cache if the key doesn't exist.
     *
     * @param  string  $key
     * @param  mixed   $value
     * @param  float|int  $minutes
     * @return bool
     */
    public function add($key, $value, $minutes)
    {
        $lua = "return redis.call('exists',KEYS[1])<1 and redis.call('setex',KEYS[1],ARGV[2],ARGV[1])";

        return (bool) $this->connection()->eval(
            $lua, 1, $this->prefix.$key, $this->serialize($value), (int) max(1, $minutes * 60)
        );
    }
```

到这里问题已经很明朗了。剩下的问题就是如何解决了。

我想到的方案：

方案一：继承 `Illuminate\Cache\RedisStore` 把其中的 `add` 方法设置为 `private`。试了一下 `method_exists` 对于 `private` 的判定是 `true`。 惊不惊喜?意不意外? 这样的话就不能通过简单的继承来完成该方法了。

方案二：继承 `Illuminate\Console\Scheduling\CacheMutex` 类重写其中的 `create` 方法。判断 `Store` 如果是 `RedisStore` 则把 `Illuminate\Contracts\Cache\Repository` 的中 `add` 方法提到 create 方法中并删除原子操作判断

```php
<?php

namespace App\Console;

use Carbon\Carbon;
use DateTime;
use Illuminate\Cache\RedisStore;
use Illuminate\Console\Scheduling\Event;
use Illuminate\Contracts\Cache\Repository as Cache;

/**
 * Class CacheMutex
 * @package App\Console
 * 修复腾讯云 redis 不支持 lua 脚本的问题
 */
class CacheMutex extends \Illuminate\Console\Scheduling\CacheMutex
{
    /**
     * @inheritDoc
     */
    public function __construct(Cache $cache)
    {
        parent::__construct($cache);
        dd();
    }
    
    /**
     * @inheritDoc
     */
    public function create(Event $event)
    {
        $key = $event->mutexName();
        $minutes = $event->expiresAt;
        $value = true;
        
        if ($this->cache->getStore() instanceof RedisStore) {
            if (is_null($minutes = $this->getMinutes($minutes))) {
                return false;
            }
    
            // If the value did not exist in the cache, we will put the value in the cache
            // so it exists for subsequent requests. Then, we will return true so it is
            // easy to know if the value gets added. Otherwise, we will return false.
            if (is_null($this->cache->get($key))) {
                $this->cache->put($key, $value, $minutes);
        
                return true;
            }
    
            return false;
        }
        
        return parent::create($event);
    }
    
    /**
     * Calculate the number of minutes with the given duration.
     *
     * @param  \DateTime|float|int  $duration
     * @return float|int|null
     */
    protected function getMinutes($duration)
    {
        if ($duration instanceof DateTime) {
            $duration = Carbon::now()->diffInSeconds(Carbon::instance($duration), false) / 60;
        }
        
        return (int) ($duration * 60) > 0 ? $duration : null;
    }
}
```
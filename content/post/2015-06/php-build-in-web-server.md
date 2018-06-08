---
title: "php 内置 web server"
date: 2015-06-07T08:57:55+08:00
lastmod: 2018-06-08T08:57:55+08:00
draft: false
keywords: []
description: ""
tags: ["php", "build-in", "web server"]
categories: ["php"]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
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

PHP 5.4.0起， CLI SAPI 提供了一个内置的Web服务器。
这个内置的Web服务器主要**用于本地开发使用**，**不可用于线上产品环境**。

URI请求会被发送到PHP所在的的工作目录（Working Directory）进行处理，除非你使用了-t参数来自定义不同的目录。

如果请求未指定执行哪个PHP文件，则默认执行目录内的index.php 或者 index.html。如果这两个文件都不存在，服务器会返回404错误。

当你在命令行启动这个Web Server时，如果指定了一个PHP文件，则这个文件会作为一个“路由”脚本，意味着每次请求都会先执行这个脚本。如果这个脚本返回 FALSE ，那么直接返回请求的文件（例如请求静态文件不作任何处理）。否则会把输出返回到浏览器。

## 启动 web server

```shell
$ cd ~/public_html
$ php -S localhost:8000
```

终端回显
```
PHP 5.4.0 Development Server started at Thu Jul 21 10:43:28 2011
Listening on localhost:8000
Document root is /home/me/public_html
Press Ctrl-C to quit
```

接着访问 http://localhost:8000/ 和 http://localhost:8000/myscript.html 窗口会显示：

终端回显
```
PHP 5.4.0 Development Server started at Thu Jul 21 10:43:28 2011
Listening on localhost:8000
Document root is /home/me/public_html
Press Ctrl-C to quit.
[Thu Jul 21 10:48:48 2011] ::1:39144 GET /favicon.ico - Request read
[Thu Jul 21 10:48:50 2011] ::1:39146 GET / - Request read
[Thu Jul 21 10:48:50 2011] ::1:39147 GET /favicon.ico - Request read
[Thu Jul 21 10:48:52 2011] ::1:39148 GET /myscript.html - Request read
[Thu Jul 21 10:48:52 2011] ::1:39149 GET /favicon.ico - Request read
```

## 启动时指定根目录

```
$ cd ~/public_html
$ php -S localhost:8000 -t foo/
```

终端回显
```
PHP 5.4.0 Development Server started at Thu Jul 21 10:50:26 2011
Listening on localhost:8000
Document root is /home/me/public_html/foo
Press Ctrl-C to quit
```

## 使用路由（Router）脚本
请求图片直接显示图片，请求HTML则显示“Welcome to PHP”

```php
<?php
// router.php
if (preg_match('/\.(?:png|jpg|jpeg|gif)$/', $_SERVER["REQUEST_URI"]))
    return false;    // 直接返回请求的文件
else { 
    echo "<p>Welcome to PHP</p>";
}
```

```
$ php -S localhost:8000 router.php
```

回显
```
PHP 5.4.0 Development Server started at Thu Jul 21 10:53:19 2011
Listening on localhost:8000
Document root is /home/me/public_html
Press Ctrl-C to quit.
[Thu Jul 21 10:53:45 2011] ::1:55801 GET /mylogo.jpg - Request read
[Thu Jul 21 10:53:52 2011] ::1:55803 GET /abc.html - Request read
[Thu Jul 21 10:53:52 2011] ::1:55804 GET /favicon.ico - Request read
```

## 判断是否是在使用内置web服务器
通过程序判断来调整同一个PHP路由器脚本在内置Web服务器中和在生产服务器中的不同行为：
```
<?php
// router.php
if (php_sapi_name() == 'cli-server') {
    /* route static assets and return false */
}
    /* go on with normal index.php operations */
?>
```

```
$ php -S localhost:8000 router.php
```

这个内置的web服务器能识别一些标准的MIME类型资源，它们的扩展有：.css, .gif, .htm, .html, .jpe, .jpeg, .jpg, .js, .png, .svg, and .txt。对.htm 和 .svg 扩展到支持是在PHP 5.4.4之后才支持的。

## 处理不支持的文件类型
```
<?php
// router.php
$path = pathinfo($_SERVER["SCRIPT_FILENAME"]);
if ($path["extension"] == "ogg")
{
    header("Content-Type: video/ogg");
    readfile($_SERVER["SCRIPT_FILENAME"]);
}
else
{
    return FALSE;
}
```

```
$ php -S localhost:8000 router.php
```

## 远程访问这个内置Web服务器
```
$ php -S 0.0.0.0:8000
```



参考：
[内置Web Server][1]
[PHP 5.4 内置web服务器][2]


  [1]: http://php.net/manual/zh/features.commandline.webserver.php
  [2]: http://www.vaikan.com/php-5-4-built-in-web-server/

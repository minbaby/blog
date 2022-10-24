---
title: "k8s 配置 ingress-nginx 默认 https 证书"
date: 2022-10-11T08:45:33Z
lastmod: 2022-10-11T08:45:33Z
draft: false
keywords: [k8s,ingress-nginx,https]
description: ""
tags: [k8s,ingress-nginx,https]
categories: [k8s]
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

> ingress-nginx 默认会生成 https 证书，但是自己签名的证书，这里我们更换成我们自己的证书
<!--more-->
## 操作步骤

1. 使用 https 证书文件生成 secret `kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n kube-system`
2. 修改 ingress-nginx 的配置文件
    1. 查看 ingress 的名字 `kubectl get all -A | grep ingress`
    2. 查看 ingress-nginx 是否已经配置 `kubectl describe -n ingress daemonset.apps/nginx-ingress-microk8s-controller | grep --default-ssl-certificate`
    3. 编辑配置 `kubectl edit -n ingress daemonset.apps/nginx-ingress-microk8s-controller`
    4. 修改/增加 `--default-ssl-certificate=kube-system/tls`

## 参考

- [TLS/HTTPS - NGINX Ingress Controller (kubernetes.github.io)](https://kubernetes.github.io/ingress-nginx/user-guide/tls/#default-ssl-certificate)
<!--more-->

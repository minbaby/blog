---
title: "k8s 使用 ingress 转发 dashboard"
date: 2022-10-11T08:40:58Z
lastmod: 2022-10-11T08:40:58Z
draft: false
keywords: [k8s ingress dashboard microk8s]
description: ""
tags: [k8s ingress dashboard microk8s]
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

## Backend Protocol

使用 `backend-protocol` 注解可以配置 Nginx 使用哪种协议转发给 `backend service`

有效值: `HTTP`, `HTTPS`, `GRPC`, `GRPCS`, `AJP` and `FCGI`

Nginx 默认使用 `HTTP`。

Example:

`nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"`

## yaml example

因为 k8s-dashboard 默认使用 https 协议，所以需要使用

`nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-dashboard
  namespace: kube-system
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  rules:
    - host: dashboard.example.com
      http:
        paths:
          - backend:
              service:
                name: kubernetes-dashboard
                port:
                  number: 8443
            path: /
            pathType: Prefix
```

<!--more-->

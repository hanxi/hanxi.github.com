---
layout: post
title: "记录解决sshd服务配置不能使用公钥登录的问题"
tagline: ""
description: ""
tags: ["sshd", "ssh", "linux"]
categories: ["技术"]
---
{% include JB/setup %}

1. 服务查看log

```
    tail -1f /var/log/secure
```

因为搜索了好多sshd的配置都是一样的，不能解决问题，就想到了查看log显示更确切的报错什么的。

2. 客户端执行命令

```
    time scp -v t.lua hlm-devel@192.168.16.234:/home/hlm-devel/t.lua
```

这句话是搜着搜着找到的。来自这里：http://bbs.chinaunix.net/forum.php?mod=viewthread&tid=3744661
可以总结出，一般命令都有debug模式，以后出现问题就直接去查找命令的debug参数就是了。

3. 查看服务器输出的log

```
    Dec  3 09:49:19 localhost sshd[15272]: Authentication refused: bad ownership or modes for directory /home/hlm-devel
    Dec  3 09:49:19 localhost sshd[15272]: Authentication refused: bad ownership or modes for directory /home/hlm-devel
```

输出了sshd的日志，根据log提示认证拒绝，权限问题，然后就搜 bad ownership or modes for directory
然后就找到了这个 http://blog.itpub.net/137293/viewspace-896312/


到此就解决了ssh公钥登录问题。


---
layout: post
title: "记录解决scp服务器配置不能使用的问题"
tagline: ""
description: ""
tags: ["sftp", "scp", "linux"]
categories: ["技术"]
---
{% include JB/setup %}

1. ssh hlm-devel@192.168.16.234 可以进入服务器

2. scp hlm-devel@192.168.16.234:~/t.lua t.lua 失败，无错误提示，无百分比输出。

3. 查看/var/log/secure 无明显错误

4. scp root@192.168.16.234:~/t.lua t.lua 正常

5. 查看/etc/ssh/sshd_config 没异常配置，开始怀疑是sftp的问题

6. 执行 sftp hlm-devel@192.168.16.234。出现下面错误

```
sftp Received message too long 458961715
```

搜到这个方案

http://prystash.blogspot.com/2009/12/sftp-message-received-message-too-long.html

和这个方案

http://www.linuxquestions.org/questions/slackware-14/sftp-received-message-too-long-887856/

文中提到~/.bashrc的问题。于是查看自己的配置看看。里面有一条命令：

```
sh /home/develop/2.log
```

注释该命令。一切正常。

2.log 文件是用来登录时输出欢迎文字的。随后把该命令移到/etc/profile后一切正常。


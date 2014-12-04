---
layout: post
title: "[原创]py+js实现markdown编辑器"
tagline: "simple markdown editor"
description: "使用python搭建http服务器，结合js实现的markdown编辑器"
tags: ["python", "js", "markdown", "编辑器"]
categories: ["技术"]
---

{% include JB/setup %}

### 借用现成工具

[Markdown](http://daringfireball.net/projects/markdown/) 是由 John Gruber 和 Aaron Swartz 共同创建的一种轻量级标记语言

[showdown.js](http://yanghao.org/tools/markdown.html) 是一个 javascript 写的 markdown 渲染库

[codemirror](http://codemirror.net)  是一款“Online Source Editor”，基于Javascript，短小精悍，实时在线代码高亮显示，他不是某个富文本编辑器的附属产品，他是许多大名鼎鼎的在线代码编辑器的基础库。

[python接收上传文件](http://my.oschina.net/leejun2005/blog/71444) 解析http POST form

### python 所做的事情

* httpd服务器，主要是用于接收ajax请求，做相应的处理，特别是上传图片

* tohtml.py 批量将md文件转成html，采用Markdown.pl

### js 所做的事情

* md编辑区使用codemirror

* ajax请求

* md实时预览使用showdown.js

* 图片上传插件

### 源码

* <https://github.com/hanxi/markdown>

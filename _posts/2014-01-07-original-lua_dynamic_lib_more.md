---
layout: post
title: "lua动态链接库之单个so文件包含多个模块（luaL_requiref函数的使用）"
tagline: "lua dynamic library more module"
description: "将多个动态链接库打包进一个so文件，动态加载"
tags: ["lua", "代码阅读"]
categories: ["技术"]
---
{% include JB/setup %}


在[hive][]的hive.lua文件中，第一行就是local c = require "hive.core"。

根据上一篇文章所说的，它是调用的hive文件夹下的core.so文件。

然而在其他hive文件夹下的system.lua前两行是

local cell = require "cell"，local system = require "cell.system"，

但没有看到这两个so文件。

这个是怎么回事呢？查看src下的hive_*_lib.c都含有luaL_Reg这样类似于hive.c中的用法。

然后找到hive.start()函数对应的scheduler_start()，看到了和cell.system相关的一行代码luaL_requiref(sL, "cell.system", cell_system_lib, 0);

接着去网上搜了下luaL_requiref()函数的作用，找到了lua源代码的实现，作用就是调用cell_system_lib然后把该模块绑定到cell.system模块名字下。

下面我就实现了一个so库包含两个模块。

<script src="https://gist.github.com/hanxi/8299600.js"></script>

lua动态链接库就到这里了，接下来会继续阅读[hive][]代码

[hive]: https://github.com/cloudwu/hive

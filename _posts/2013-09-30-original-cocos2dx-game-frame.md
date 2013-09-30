---
layout: post
title: "使用cocos2dx搭建手游基本框架"
tagline: "using cocos2dx setup phone game frame"
description: "把coccos2dx作为手游工程的一个库,完成跨平台手游的框架结构"
tags: ["linux", "cocos2dx"]
categories: ["技术"]
---
{% include JB/setup %}

###工程源码结构
<pre class="prettyprint lang-bsh">
HXGame
├── Classes
├── HXModules
│   ├── HXEngine
│   │   ├── HXEngine.cpp
│   │   └── HXEngine.h
│   ├── HXLuaModules.cpp
│   ├── HXLuaModules.h
│   ├── HXModules.h
│   ├── proj.android
│   │   └── Android.mk
│   └── proj.linux
│       ├── Makefile
│       ├── modules.mk
│       └── obj
├── lib
├── libs
│   ├── cocos2dx
│   ├── CocosDenshion
│   ├── extensions
│   ├── external
│   ├── Makefile
│   └── scripting
│       └── lua
├── LICENSE
├── proj.android
├── proj.ios
├── proj.linux
├── proj.mac
├── proj.win32
├── README.md
├── Resources
│   ├── audio
│   ├── fonts
│   ├── image
│   └── luaScript
│       ├── conf.lua
│       ├── include.lua
│       ├── main.lua
│       └── util
│           ├── HXUtil.lua
│           └── util.lua
└── tools
    └── tolua++
        ├── basic.lua
        ├── build.sh
        ├── Cocos2d.pkg
        ├── HXModules.lua
        ├── HXModules.pkg
        └── tolua++.bin
</pre>

HXModules文件夹自己主要需要完成的模块,包括手游中需要完成的通用代码都在此以模块的方式实现.其中HXLuaModules.cpp是tolua++生成的文件. 现在只实现了一个功能,执行lua脚本和重启lua脚本(在lua中可以重启lua脚本).

libs文件夹是从cocos2dx工程拷贝过来的,减去了不需要的文件,里面的工程文件也做了修改(现在完成了安卓工程和linux的编译和运行).

lib文件夹是用来放libs和HXMoules生成的lib文件(linux 工程下).

proj文件夹是从cocos2dx拷贝过来的,修改了安卓工程和linux工程.完美编译运行.

Resources文件夹就是资源和脚本的存放处了.lua脚本目录格式也是有规则的.每个lua模块一个文件夹,并在include中包含他们.

tools文件夹中的tolua++用来生成luabing文件...

这样设计目录结构的目的是为了方便工程的扩展,而不是所有文件都放在Classes文件夹.把通用的代码可以放到Modules文件夹,程序逻辑放在lua中实现.C++只实现一些通用模块.可能在Modules文件下还要添加platform文件夹用来存放和平台相关的代码,比如需要添加一个微博分享模块,那就得用java实现安卓相关的代码,用objc实现ios相关代码,然后提供公共的C++接口给lua.

### 框架设计来源

架构思想来自[关中刀客][]

<img src="/assets/media/2013-09-30-original-cocos2dx-game-frame.1.jpg" alt="Sanjose" class="img-center">

[关中刀客]:http://guan-zhong-dao-ke.blog.163.com/blog/static/465446372012031114657379/

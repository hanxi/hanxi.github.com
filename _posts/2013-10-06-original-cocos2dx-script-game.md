---
layout: post
title: "使用cocos2dx的lua脚本写游戏逻辑"
tagline: "using cocos2dx lua binding to program game logic"
description: "阅读他人用lua实现的三消游戏,改进代码逻辑"
tags: ["linux", "cocos2dx"]
categories: ["技术"]
---
{% include JB/setup %}

### 脚本代码文件结构
<pre class="prettyprint lang-bsh">
luaScript
├── conf.lua
├── global.lua
├── include.lua
├── logic
│   ├── HXGameBoardLogic.lua
│   ├── HXGameIcon.lua
│   ├── HXGameScene.lua
│   ├── HXMainMenuScene.lua
│   └── logic.lua
├── main.lua
└── util
    ├── AudioEngine.lua
    ├── HXUtil.lua
    └── util.lua
</pre>

项目地址: [使用cocos2dx引擎为基础完成一个手机游戏的基本框架][]

游戏资源和逻辑脚本来自[crosslife][], 真应该感谢他开源了这套脚本逻辑. 国庆这几天都在修改这套代码, 收获还挺多的.

###游戏逻辑分类
因为游戏比较小,所以把所有的逻辑都放到了logic文件夹下面,其中HXGameBoardLogic.lua文件用来实现与游戏数据结构相关的逻辑,比如坐标点和图标位置转换,检测某个图标是否可以被消除等等跟图形界面没关的都放这里了.

HXGameIcon.lua用来读取图标.

HXMainMenuScene.lua用来实现开始菜单界面.

HXGameScene.lua就是游戏的主场景了.包含创建场景,各种游戏操作逻辑能看得到的都在这里实现了.


[使用cocos2dx引擎为基础完成一个手机游戏的基本框架]:https://github.com/hanxi/HXGame
[crosslife]:https://github.com/crosslife/LoveClear

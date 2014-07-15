---
layout: post
title: "[原创]使用cocos2d-x v3.1开发小游戏（基本框架）"
tagline: "小游戏的基本框架"
description: "讲解小游戏的组成和cocos2d-x v3.1框架的精简模块"
tags: ["cocos2d-x", "lua", "c++"]
categories: ["技术","游戏"]
---
{% include JB/setup %}

[原创]使用cocos2d-x v3.1开发小游戏（基本框架）

## 小游戏的组成

* ### 欢迎界面

> 在游戏资源未全部加载完之前就需要载入，避免进入游戏会有一段黑屏时间。

> 可以用来展示游戏名称或者开发者logo。

* ### 开始菜单界面

> 一般用于显示游戏名称和关卡选择（或者称游戏难度选择）。

> 可以外加一些设置性功能，如声音开关，帮助入口等等。

> 如果游戏设置内容较多可以把设置作为一个单独界面，在开始菜单上提供入口即可。

> 有的小游戏是以弹窗方式的菜单

* ### 主游戏界面

> 游戏的中心部分，比如2048游戏的格子滑动界面，扫雷游戏的扫雷界面，贪吃蛇游戏的蛇移动的界面，等等。

> 小游戏拥有这一个界面也能算一个小游戏，但是没有其他界面会使游戏缺少更多选择。

> 游戏的主要逻辑都是在完成这个界面。

* ### 游戏结束界面

> 游戏结束一般都会有个分数，用于展示本次游戏得分和历史最高得分对比。

> 在这个界面上可以添加再玩一次的按钮，让玩家重新玩一次。

> 大多数小游戏都是以弹窗的方式展示游戏结果。

* ### 排行榜界面 （可选）

> 游戏中有分数这个概念就会有排名。

> 可以是单机的排行榜，也可以是联机的排行榜（需要服务器保存数据）。

> 排行榜可以促进玩家拿到更高的分数（也是有缺点的，看到其他玩家玩的分数太高了而放弃了）。

## cocos2d-x v3.1 lua 框架的使用

* ### lua代码结构

<pre class="prettyprint">
src
├── conf.lua                  # 配置文件，一些不变的配置保存在这里
├── GameOverScene.lua         # 游戏结束的界面
├── GameScene.lua             # 游戏主逻辑界面
├── HelloScene.lua            # 欢迎界面，在这里做资源更新检测
├── main.lua                  # 游戏lua脚本的入口
├── MainMenuScene.lua         # 游戏主菜单界面
├── RankScene.lua             # 排行榜界面
└── util.lua                  # 通用功能函数实现
</pre>

每个XXOOScene.lua 文件的样子如下：

<pre class="prettyprint lang-lua">
local XXOOScene = {}

XXOOScene.newScene = function ()
    local scene = cc.Scene:create()
    -- do other XXOO things
    return scene
end

return XXOOScene
</pre>

关于Scene界面跳转，在util中封装一个通用函数用于界面跳转。

<pre class="prettyprint lang-lua">
function util.toScene(scene)
    -- 增加一个统一的界面跳转动画
    scene = cc.TransitionSlideInR:create(0.5, scene)
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end
</pre>

main.lua用户进入HelloScene界面
<pre class="prettyprint lang-lua">
HelloScene = require("src/HelloScene")
 
local function main()
    cc.FileUtils:getInstance():addSearchResolutionsOrder("src")
    cc.FileUtils:getInstance():addSearchResolutionsOrder("res")
 
    HelloScene.newScene()
end
 
 
local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
</pre>

* ### 游戏启动logo的Scene特殊处理

> 因为加载lua资源需要时间，待所有资源都加载完再创建游戏启动界面会出现启动的时候黑屏。我在1G的安卓机上测试需要5秒才能进入到lua创建的Scene。

> 解决方案：在 C++ 中创建启动画面,HelloScene.lua中不做创建Scene的操作，直接getRunningScene。

<pre class="prettyprint lang-cpp">
AppDelegate::applicationDidFinishLaunching () {

    // ... other xxoo things

    auto scene = Scene::create();
    auto s = Director::getInstance()->getWinSize();
    auto layer = LayerColor::create(Color4B(255, 255, 255, 255), s.width, s.height);
    auto logo = Sprite::create("res/logo.png");
    layer->addChild(logo);
    logo->setPosition(Vec2(s.width*0.5,s.height*0.7));
    scene->addChild(layer,0);
    director->runWithScene(scene);
 
    // 特殊处理，延迟加载lua（创建好logoScene再加载）
    auto action = CallFunc::create(startLua);
    layer->runAction(action);

    return true;
}
</pre>

* ### cocos2d-x v3.1 引擎的精简

> 起因： 引擎编译完之后发现lib文件相比2.x版本的大了不少。由于是做小游戏，一般都会有用不到的引擎部分，比我我就没用到ui编辑器，所以就想办法不编译ui编辑器部分。

> 步骤：

> * 找到mk文件: $ find . -name "Android.mk"

> * 修改mk文件，把与ui编辑器相关的语句注释掉。

> * 编译，在编译错误提示中找出还有什么需要注释的代码。我遇到的问题主要是CCB那些。需要在lua_cocos2dx_extension_manual.cpp中把CCB的代码注释。

> * CCLuaStack.cpp中也需要注释几个注册函数。

> 我还精简了物理引擎，刚开始是用到了的，但后面看小游戏用不上就把它也干掉了（大概省下1M）。


* ### cocos/scripting/lua-bindings/auto/ 下的文件生成

> 看README后执行生成命令，遇到了一些问题：

> * #### 问题1：官方只提供ubuntu 64位的libclang.so文件，在32位机子上跑会报下面这个错误

> > * LibclangError: libclang.so: wrong ELF class: ELFCLASS64. To provide a path to libclang use Config.set_library_path() or Config.set_library_file().

> > * 解决方法：在llvm官网下载4.3版本的llvm和clang。编译生成libclang.so.3.4。拷贝到bindings-generator/libclang/下覆盖libclang.so文件。怎么编译的那个博客现在找不到了，步骤大概是：

> > * clang-3.4.src.tar.gz 和 llvm-3.4.src.tar.gz 。解压，然后把clang目录拷贝到llvm-3.4/tools/下。编译，在llvm-3.4同一个目录下建一个build文件夹，进入到build，执行cmake ../llvm-3.4/CMakeLists.txt

> 文字描述可能不清晰，目录结构如下：

> <pre class="prettyprint">
> . -> build
> | ->llvm-3.4  -> tools -> clang -> CMakeLists.txt 
>              |-> CMakeLists.txt
> </pre>

> * #### 问题2： 找不到头文件，报错出现unkown type name ，原因是官方配置的android_headers路径和我电脑上的不一样，主要是gcc的版本，我的是4.8的，官方配置是4.7。如下：

> > * details = "unknown type name '__locale_t'"

> > * 解决方法：修改cocos2dx.ini中的android_headers 的值把/cxx-stl/gnu-libstdc++/4.7/ 改成/cxx-stl/gnu-libstdc++/4.8/ 。有两个地方要修改。这个问题要看自己的安卓ndk的配置情况，也许你的还是4.6呢，自己可以去ndk对应的路径下找找看自己的ndk版本。


## 全民顶爆菊花

> 应用宝：<http://android.myapp.com/myapp/detail.htm?apkName=com.hanxi.runtodie>

> 百度手机助手：<http://as.baidu.com/a/item?docid=6678809>

> 豌豆荚：<http://www.wandoujia.com/apps/com.hanxi.runtodie>

> 代码地址：<https://github.com/hanxi/cocos2d-x-v3.1>



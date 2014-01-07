---
layout: post
title: "lua动态链接库（luaopen_*函数的使用）"
tagline: "lua dynamic lib"
description: "介绍如何生成lua可用的c动态链接库来扩展lua库"
tags: ["lua", "代码阅读", "Linux"]
categories: ["技术"]
---
{% include JB/setup %}


lua中使用c动态库，像luacjson（支持unicode），luasocket,都是以动态链接库的形式在lua中使用的，至于怎么写这些动态链接库很少有教程说到，下面我就说说如何把c文件编译成动态库。

首先，假设需要在lua中调用一个在c中实现的求和函数，函数名add(a,b)。

我给这个测试库取名为dylib，它包含一个函数add。lua中这样使用：

<pre class="prettyprint lang-lua">
    local dylib = require "dylib.test"
    local c = dylib.add(1,2)
    print(c)
</pre>

上面的dylib.test就是我编译生成的dylib/test.so文件。这个文件该怎么生成？如下：

<pre class="prettyprint lang-cpp">
    int
    luaopen_dylib_test(lua_State* L) {
        luaL_Reg l[] = {
           { "add", *dylib_add* },
           { NULL, NULL },
        };
        luaL_checkversion(L);
        luaL_newlib(L,l);

        return 1;
    }
</pre>

这个函数名有个命名规则，前缀为luaopen_，后面就是lua中require的字符串（将'.'转换成'_'）。当执行到require "dylib.test"时，lua解析器会去dylib/test.so文件中寻找并执行函数名为luaopen_dylib_test的函数。找不到则报错：

<pre class="prettyprint lang-bsh">
    lua: error loading module 'dylib.test' from file './dylib/test.so':
        ./dylib/test.so: undefined symbol: luaopen_dylib_test
    stack traceback:
        [C]: in ?
        [C]: in function 'require'
        test.lua:1: in main chunk
        [C]: in ?
</pre>

注意到dylib_add就是就是要实现的dylib.add函数。现在实现它：

<pre class="prettyprint lang-cpp">
    int
    dylib_add(lua_State* L) {
        int a = lua_tonumber(L,1);
        int b = lua_tonumber(L,2);
        int c = a+b;
        lua_pop(L,2);
        lua_pushnumber(L,c);
        return 1;
    }
</pre>

这函数就是把两参数加起来，然后返回和。最后编译生成so文件：

<pre class="prettyprint lang-bsh">
    gcc -g -Wall --shared -fPIC -o dylib/test.so dylib_test.c
</pre>

注意要给它建一个文件夹dylib。因为require的时候会把"dylib.test"转成"dylib/test"默认去该路径下寻找so或者lua文件。当然，你修改了搜索路径那是另外一回事了。

基本的就是这样子了。正在看云风的[hive](https://github.com/cloudwu/hive)游戏服务器框架（skynet的精简版，不是[apache hive](http://en.wikipedia.org/wiki/Apache_Hive)）。

下一篇会讲到luaL_requiref函数，实现一个动态库so文件中包含多个库。因为直接用两个luaopen函数是有问题的，一般一个luaopen函数对应一个so文件。

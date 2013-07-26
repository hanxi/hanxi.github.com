---
layout: post
title: "[原创]lua嵌入C中实例"
tagline: "the lua for c"
description: "一个简单的helloworld的例子,如何在C中嵌入lua脚本"
tags: ["C/C++", "lua"]
categories: ["技术"]
---
{% include JB/setup %}

### 目录结构
编译出来为我所需的文件,以及代码文件
<pre class="prettyprint">
├── bin
│   ├── test
│   └── test.lua
├── build
├── CMakeLists.txt
├── lua
│   ├── include
│   │   ├── lauxlib.h
│   │   ├── lua.h
│   │   ├── lua.hpp
│   │   ├── luaconf.h
│   │   └── lualib.h
│   └── lib
│       └── liblua.a
└── src
    └── main.cpp
</pre>

### 源代码
<pre class="prettyprint lang-cpp">
//main.cpp
#include &lt;stdio.h>

extern "C"{
#include &lt;lua.h>
#include &lt;lualib.h>
#include &lt;lauxlib.h>
}

int main(int argc, char ** argv) {
    lua_State * L = luaL_newstate() ;        //创建lua运行环境
    if (!L) {
        printf("error for luaL_newstate\n");
    }
    luaopen_base(L);                         // 加载Lua基本库
    luaL_openlibs(L);                        // 加载Lua通用扩展库

    int ret = luaL_loadfile(L,"test.lua") ;  //加载lua脚本文件
    if (ret) {
        printf("error for luaL_loadfile\n");
    }
    ret = lua_pcall(L,0,0,0) ;
    if (ret) {
        printf("error for lua_pcall\n");
    }
    lua_getglobal(L,"printmsg");
    ret = lua_pcall(L,0,0,0);
    if (ret) {
        printf("error for lua_pcall\n");
    }

    return 0;
}
</pre>

<pre class="prettyprint lang-lua">
-- test.lua

function printmsg()
    print("hello word")
end
</pre>

<pre class="prettyprint lang-shell">
#CMakeLists.txt
PROJECT(test)
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

set(EXECUTABLE_OUTPUT_PATH ../bin)

## libs
link_directories(/usr/local/lib)
link_directories(/usr/lib)

## includes
include_directories(/usr/local/include)
include_directories(./src SRC_DIR)
include_directories(./lua/include)

aux_source_directory(./src SRC_DIR)

## apps
add_executable(test
    ${SRC_DIR}
)

## link libs
target_link_libraries(test lua m dl)
</pre>



### 编译运行
<pre class="prettyprint lang-shell">
    $ cd build
    $ cmake ..
    $ make
    $ cd ../bin
    $ ./test
</pre>



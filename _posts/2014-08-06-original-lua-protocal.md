---
layout: post
title: "使用lua表设计简单RPC协议"
tagline: "lua protocol"
description: "简单的RPC协议"
tags: ["lua", "c"]
categories: ["技术"]
---
{% include JB/setup %}


## 协议设计

* 协议类型：schema

* 支持类型：int, string, array

* 采用lua table定义协议

> <pre class="prettyprint lang-lua">
>    p = {
>        name = "hanxi",
>        tel = 1383838,
>        addresslist = {
>            address = "gz",
>            addtype = "work",
>        },
>    }
> </pre>

> p 是定义一个协议格式，其中，addresslist是array类型，定义的内容表示array的元素的格式。协议的实际内容格式如下：
> <pre class="prettyprint lang-lua">
>   p = {
>       name = "hanxi",
>       tel = 1383838,
>       addresslist = {
>           {
>               address = "gz",
>               addtype = "work",
>           },
>           { 
>               address = "jj",
>               addtype = "home", 
>           },
>   }
> </pre>
  
## 协议打包

* 只打包value，key不打包

* 协议模板做预处理，把key排序，添加字段_keysort.

> <pre class="prettyprint lang-lua">
> p = {
>       _keysort = {"addresslist","name","tel"},
>       name = "hanxi",
>       tel = 1383838,
>       addresslist = {
>           _keysort = {"addtype","address"},
>           address = "gz",
>           addtype = "work",
>       },
> }
> </pre>


## 协议解包

* 根据协议模板，解析协议

* 遍历顺序按照_keysort

## 实现

在c中提供接口：

<pre class="prettyprint lang-c">
    luaL_Reg l[] ={
        { "packinit", lpackinit },
        { "write", lwrite },
        { "getpack", lgetpack },
        { "unpackinit", lunpackinit },
        { "read", lread },
        { NULL, NULL },
    };
</pre>

packinit, write, getpack三个函数用于打包协议

unpackinit, read 两个函数用于解包协议

* 打包int时分64位，32位，16位，8位。第一个字节存储int位数和正负数标志

* 打包sting时，先存储字符串长度，按int的方式打包，然后打包string

全部代码： <https://github.com/hanxi/lproto>



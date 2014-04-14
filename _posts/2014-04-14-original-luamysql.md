---
layout: post
title: "mysql driver for lua"
tagline: ""
description: "lua 操作 mysql"
tags: ["lua", "mysql"]
categories: ["技术"]
---
{% include JB/setup %}

### 在lua中操作mysql，封装基本的操作接口。

操作接口：

>* 创建连接：mysql.connect (host,user,pass,dbname,dbport)
>* * return db object 

>* 关闭连接：db:close()

>* 查询：db:query(sql)
>* * return result table 

>* 插入：db:insert(sql)
>* * return result insert id

>* 更新：db:update(sql)
>* * return 0 if right

>* 设置语言：db:character_set(character_type)

### query 执行结果示例

<pre class="prettyprint lang-lua">
local mysql = require "mysql"
local db = mysql.connect("192.168.1.25","root","root","mysql",3306)
print ("db=",db)
local tbl = db:query("select * from user")
for k,v in pairs(tbl) do
    print(k,v.Host,v.User)
end
</pre>

### 实现原理

1. 在c中创建MYSQL指针，然后push到lua中，每次操作第一个参数都为MYSQL指针（在lua中为lightuserdata）。
2. 将接口导出到lua后,使用lua的metatable将接口封装成一个对象的成员函数形式。
3. 使用mysql.connect创建db对象，然后通过db对象去调用操作函数起到隐藏MYSQL指针的效果，防止误操作导致的内存泄露。


[源码地址](https://github.com/hanxi/luamysql)


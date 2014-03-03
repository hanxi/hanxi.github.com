---
layout: post
title: "使用python搭建http服务器,供cocos2dx的AssetsManager更新"
tagline: "use python setup http server for cocos2dx AssetsManager update"
description: "介绍python搭建http服务器，如何下载zip文件"
tags: ["python", "http", "Linux"]
categories: ["技术"]
---
{% include JB/setup %}

### 1. 简单http服务器

使用python开http服务很简单，执行

<pre class="prettyprint bsh">
    python -m SimpleHTTPServer 8080
</pre>

就可以开一个简单http服务了。它会已当前目录为web目录。有index.html则打开它。没有则显示文件目录。

### 2. 功能加强的http服务器

这个python服务器太简单，不能满足我的需求。我需要通过网页操作完成一些打包zip和更新svn代码的工作。则可以使用python提供的BaseHTTPRequestHandler, HTTPServer即可实现。

基本代码如下：具体需求就可以慢慢加进去了。

<pre class="prettyprint python">
class MyRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.process(2)

    def do_POST(self):
        self.process(1)

    def process(self,type):
        # 在这里处理get和post。。。

        # 获取get的参数
        query = urllib.splitquery(self.path)
        action = query[0]
        queryParams = {}
        if '?' in self.path:
            if query[1]:#接收get参数
                for qp in query[1].split('&'):
                    kv = qp.split('=')
                    queryParams[kv[0]] = urllib.unquote(kv[1]).decode("utf-8", 'ignore')

        
        # 这里处理对应需要直行的shell命令并返回需要的http的contentType,和文件
        content_type,f = page(action,queryParams)
        self.send_response(200)
        self.send_header("Content-type", content_type)
        #self.send_header("Content-Length", str(len(content)))
        self.end_headers()
        shutil.copyfileobj(f,self.wfile)

server = HTTPServer(('', 8081), MyRequestHandler)

</pre>

### 3. 具体操作的实现

现在主要工作都交给的了 page 函数处理,根据对应的action和参数做出对应的操作，并返回对应的file给客户端。

比如我接收到action=="/" 则返回index.html

<pre class="prettyprint python">
    #index.html我直接放在执行脚本时的目录下
    if action=="/": #主页index.html
        f = open('index.html')
        f.seek(0)
        content_type = "text/html"
</pre>

### 4. 完整代码

我还用到了打包zip文件,获取zip文件以及获取版本号的操作。全部代码请移步到[github](https://github.com/hanxi/py_http)

参考资料：

[非常简单的Python HTTP服务](http://coolshell.cn/articles/1480.html)

[Python执行系统命令并获得输出的几种方法](http://blog.csdn.net/dingyaguang117/article/details/7236296)

[Python的http服务(SimpleHTTPServer,BaseHTTPServer,CGIHTTPServer)](http://www.lifeba.org/arch/python_http_simplehttpserver_basehttpserver_cgihttpserver.html)


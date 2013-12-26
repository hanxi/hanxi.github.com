---
layout: post
title: "Buck快速入门"
tagline: "Buck: Quick Start"
description: "Buck快速入门 翻译"
tags: ["翻译 ", "杂文"]
categories: ["杂文"]
---
{% include JB/setup %}

原文地址：[http://facebook.github.io/buck/setup/quick_start.html](http://facebook.github.io/buck/setup/quick_start.html)

*注意：Buck仅支持Mac OS X和Linux，不支持Windows。*

这是一份使用Back的快速入门手册。为了更容易开始使用，Back提供了buck quickstart命令创建一个简单的Android工程，它是已配置的且使用Buck就可开箱即用的。

如果你不习惯使用命令来生成一个项目,那么你可以通过这个快速入门指南提供的一步一步的指示来创建您的第一个项目。这个项目中的每个文件的用途都将在这里介绍。

##第1步：安装Buck

因为这是一个快速入门说明书，我们假定你的电脑上已经安装好Ant和Android SDK，如果你没安装它们，请移步到[下载和安装Back](http://facebook.github.io/buck/setup/install.html)



执行下面的命令从GitHub中checkout Back。编译，添加Back到$PATH:
    
<pre class="prettyprint lang-bsh">
    git clone git@github.com:facebook/buck.git
    cd buck
    ant
    sudo ln -s ${PWD}/bin/buck /usr/bin/buck
</pre>


同样的，你也可能想设定[buckd](http://facebook.github.io/buck/command/buckd.html)。

<pre class="prettyprint lang-bsh">
    sudo ln -s ${PWD}/bin/buckd /usr/bin/buckd
</pre>    

当前没有办法下载预编译好的Buck二进制文件。

##第2步：执行"buck quickstart"


现在你已经安装好Buck了，我们来使用它编译一个简单的Android应用程序。

我们需要在一个空的目录下开始，所以创建一个新文件夹，进入到新建的文件夹，执行命令：

<pre class="prettyprint lang-bsh">
    buck quickstart
</pre>    

你将看到下面的提示，输入你安装好的Android SDK的本地路径。如果你的Android SDK安装在~/android-sdk-macosx，那么你将会看到下面的提示：

<pre class="prettyprint lang-bsh">
    Enter the directory where you would like to create the project: .
    Enter your Android SDK's location: ~/android-sdk-macosx
</pre>    

作为选择，你可以指定参数中输入SDK的路径来跳过提示。

<pre class="prettyprint lang-bsh">
    buck quickstart --dest-dir . --android-sdk ~/android-sdk-macosx
</pre>    
    
看到下面的输入说明你的命令成功了：

<pre class="prettyprint lang-bsh">
    Thanks for installing Buck!
    
    In this quickstart project, the file apps/myapp/BUCK defines the build rules. 
    
    At this point, you should move into the project directory and try running:
    
        buck build //apps/myapp:app
    
    or:
    
        buck build app
    
    See .buckconfig for a full list of aliases.
    
    If you have an Android device connected to your computer, you can also try:
    
        buck install app
    
    This information is located in the file README.md if you need to access it
    later.
</pre>    


##第3步：编译和安装你的App
上面操作正确之后，你可以执行下面的命令编译你的程序：

<pre class="prettyprint lang-bsh">
    buck build app
</pre>    

如果你开启了Android模拟器或者有设备通过usb连接（你可以执行*adb devices*验证一下），然后你可以安装，运行这个app：

<pre class="prettyprint lang-bsh">
    buck install app 
</pre>    

这个app的名字是一个[生成目标](http://facebook.github.io/buck/concept/build_target.html)的别名，[编译规则](http://facebook.github.io/buck/concept/build_rule.html)的一个标识，作为编译你的*app*。你可以[.buckconfig](http://facebook.github.io/buck/concept/buckconfig.html)文件中（在你工程的根目录）修改它.


##第4步：修改App

现在你知道如何使用Buck生成APK了，你大概想要修改这个示例代码来编译你想要的app。Java代码在*java/*目录下，建议使用目录结构和包结构相匹配，这是Java的一贯风格。

比较起来，Android 资源需要放在*res/*目录下，你可以多个Java包在*java/*目录下，你同样可以拥有多个*[android_resource](http://facebook.github.io/buck/rule/android_resource.html)*在*res/*目录下。这样就更容易在需要的时候处理Android资源目录和Java代码之间的映射。

现在你应该从你需要的一切开始，如果你的项目变得越来越复杂而且你想利用Buck的更多先进但不复杂的共，你将会从头开始探索更多的Buck的文档。

当前，使用[buck](http://facebook.github.io/buck/command/project.html)生成的IntelliJ工程导入到IntelliJ不是那么的方便，查看[answers to our questions](http://stackoverflow.com/questions/19326675/how-do-i-fix-or-debug-error-android-packager-app-cannot-create-new-key-or-k)会有所帮助。


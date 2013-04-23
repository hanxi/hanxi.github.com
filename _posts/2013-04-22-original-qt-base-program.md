---
layout: post
title: "[原创]Qt基本编程"
tagline: "Qt base program"
description: "介绍基本的qt编程入门，包括如何使用qt助手，使用cmake编译工程"
tags: ["Qt", "内核", "编译源码"]
---
{% include JB/setup %}

计划了好久想要写个入门教程的，今天才开始写。

###环境搭建(以ubuntu12.04lts 为例)
* 执行下面命令：
<pre class="prettyprint lang-bsh">
$ sudo apt-get install qt4-dev-tools qt4-doc qt4-qtconfig qt4-demos qt4-designer
</pre>

* 当代码中含有
<pre class="prettyprint lang-cpp">
#include &lt;QSqlDatabase>
</pre>
需要用到mysql数据库需要执行下面命令(自带sqlite驱动),
<pre class="prettyprint lang-bsh">
$ sudo apt-get install libqt4-sql-mysql
</pre>

###来一个helloworld程序
1.  建立工程目录：我的目录在/home/hanxi/tmp/
<pre class="prettyprint lang-bsh">
$ mkdir -p helloworld/src helloworld/ui helloworld/build helloworld/bin
</pre>

2.  打开qt designer（qt 设计器），新建一个helloworld.ui文件。（菜单：文件->新建，弹出新建窗体对话框，点击创建，保存为helloworld/ui/helloworld.ui）

3.  建立src/main.cpp
<pre class="prettyprint lang-cpp">
#include &lt;QApplication>
#include "mainwindowimpl.h"

int main(int argc, char ** argv)
{
    QApplication app(argc, argv);
    MainWindowImpl win;
    win.show();
    app.connect( &app, SIGNAL( lastWindowClosed() ), &app, SLOT( quit() ) );
    app.exec();

    return 0;
}
</pre>


4.  建立src/mianwindowimpl.h
<pre class="prettyprint lang-cpp">
#ifndef MAINWINDOWIMPL_H
#define MAINWINDOWIMPL_H

#include &lt;QDialog>
#include "ui_helloworld.h"

class MainWindowImpl : public QDialog, public Ui::Dialog
{
Q_OBJECT
public:
    MainWindowImpl( QWidget * parent = 0, Qt::WFlags f = 0 );
    virtual ~MainWindowImpl() {};
};
#endif
</pre>

5.  建立src/MainWindowImpl.cpp
<pre class="prettyprint lang-cpp">
#include "mainwindowimpl.h"

MainWindowImpl::MainWindowImpl( QWidget * parent, Qt::WFlags f)
: QDialog(parent, f)
{
    setupUi(this);
}
</pre>


6.  建立helloworld/CMakeLists.txt
<pre class="prettyprint lang-bsh">
PROJECT(helloworld)
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
FIND_PACKAGE(Qt4 REQUIRED)

#########################################
set(EXECUTABLE_OUTPUT_PATH ../bin)
set(LIBRARY_OUTPUT_PATH ../libs)

add_definitions (${QT_DEFINITIONS})

# 使用net模块
# set(QT_USE_QTNETWORK true)

## libs
link_directories(/usr/local/lib)
link_directories(/usr/lib)

## includes
include(${QT_USE_FILE})
# 包含文件夹：${CMAKE_CURRENT_BINARY_DIR}和${CMAKE_CURRENT_SOURCE_DIR}用于确保moc产生的文件能正确编译。
include_directories(${QT_INCLUDES} ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
include_directories(./src SRC_DIR)

## sources
aux_source_directory(./src SRC_DIR)

# 对于含有Q_OBJECT一类宏的代码（主要是头文件），需要列出以备交给moc处理
set(qt_HDRS ./src/mainwindowimpl.h)

# UI文件
set(qt_UI ./ui/helloworld.ui)

## QT
qt4_wrap_cpp(qt_MOCS ${qt_HDRS})
qt4_wrap_ui(qt_UIS ${qt_UI})

## apps
add_executable(helloworld
    ${SRC_DIR}
    ${qt_MOCS}
    ${qt_UIS}
)

## link libs
target_link_libraries(helloworld ${QT_LIBRARIES})
</pre>

7.  进入build目录，执行
<pre class="prettyprint lang-bsh">
$ cmake ..
$ make
$ ../bin/helloworld
</pre>



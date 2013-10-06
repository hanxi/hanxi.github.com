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

###游戏数据结构
* 二维数组GameBoard是一个7X7的用于存放每个格子图标的index
* 没有单独建立表来存放每个node的引用,而是直接使用scene场景来管理每一个格子图标的精灵,并使用tag来索引它,由于是7X7的,所以就使用二位数来表示横纵位置.如果格子定在10X10以上那得修改代码了,没有做兼容.

###主要的算法
* 判断P(x,y)能否被消除: x,y为1到7的数字.算法1是像扫雷游戏那样判断,搜集周围节点状态一起判断,3个连在一起就可消除的就需要判断周围横纵8个节点的状态.我用的是另外一种算法2:从P点开始搜索,先横向搜索左右两边的节点状态,如果左边相同左边继续搜寻,不相同则停止左边的搜索,右边的节点和左边搜索过程是一样的,所以我就在一个循环里头完成这两个操作的判断.比算法1有个好处就是可以在判断完后得到可消除的节点.而算法1还需要重新搜索可一消除的节点数.
* 检测棋盘有无可移动消除棋子:用的是全部遍历测试方法,逐个节点左右上下互换位置后判断能否被消除来检测.这算法效率很定是不行的,太耗时间了,打算优化的,还没有想到更好的方法.

###节点下落填充

(思想来自一个csdn的人写的,忘记在哪了)

* 根据需要消除的节点,计算出每一列里有多少个需要消除的节点,计算的时候从下网上开始计算,可以得出每个节点下面可以有几个被消除的节点.根据这个就可算出它需要下移的位置了,然后就可以调用moveto了.
* 为每列生成新节点,根据每列需要消除的节点数生成新节点,和计算出掉落位置,然后掉用moveto.
* 在最后一个节点掉落完成之后弄个回调函数,完成掉下来的节点(前两步做好记录)能否被消除的检测.
* 在检测函数最后面判断是否还有节点在往下掉,如果没有往下掉的格子了,再检测现在的棋盘能否可以有棋子移动,不可以移动就掉落闪烁节点.

###掉落动画保护处理
为了玩家看到的动画效果是完整的,我屏蔽了掉落动画时的屏幕touch事件.如果不这样做的画会出现棋子掉落位置出错的情况.还有一种解决办法是立即结束动画(但是需要立即完成moveto事件.要不然棋子就不在目标位置了.),但对cocos2dx不熟,导致没有成功实现这种方法.

####游戏后续补充
现在这个游戏只是能玩,有个分数在那里显示着,但还不像个游戏.后面我给他添加闯关模式,无尽模式什么的...在玩法上添加点东西,比如最高记录保存.

####顺便添加一点apk打包知识
无需安装eclipse,只需要ant就足矣.

* 生成keystore文件
<pre class="prettyprint lang-bsh">
keytool -genkey -alias hanxigame.keystore -keyalg RSA -keystore hanxigame.keystore
</pre>

* 修改ant.properties文件

<pre class="prettyprint lang-bsh">
key.store=./hanxigame.keystore
key.alias=hanxigame.keystore
key.store.password=hanxigame
key.alias.password=hanxigame
</pre>

* 执行ant release

* 如果出现环境变量问题,需要把一些必要的环境变量设置好.ant需要用到NDK_ROOT这个变量
<pre class="prettyprint lang-bsh">
#set android environment
export ANDROID_SDK_ROOT=/home/hanxi/Lib/android-sdk
export NDK_ROOT=/home/hanxi/Lib/android-ndk
export COCOS2DX_ROOT=/home/hanxi/Lib/cocos2d-x
export PATH=$PATH:$ANDROID_SDK_ROOT:$ANDROID_SDK_ROOT/tools
export PATH=$PATH:$NDK_ROOT
</pre>

* 这个游戏第一版就这样子结束吧,编译一个release包放到百度网盘里面了.可以下载玩玩的.自适应屏幕的(具体怎么适应可去网上找资料,或者直接阅读我的代码). [安卓安装包下载地址]

[使用cocos2dx引擎为基础完成一个手机游戏的基本框架]:https://github.com/hanxi/HXGame
[crosslife]:https://github.com/crosslife/LoveClear
[安卓安装包下载地址]:http://pan.baidu.com/s/1bywbw

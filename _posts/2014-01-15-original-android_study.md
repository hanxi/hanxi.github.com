---
layout: post
title: "android开发入门之luaIDE"
tagline: "android develope, a luaIDE for android "
description: "根据开发一个在安卓上运行的luaIDE，简单讲述所需的安卓知识点"
tags: ["android", "lua"]
categories: ["技术"]
---
{% include JB/setup %}

## 1. TextView高亮关键字

可以使用*android.text.SpannableStringBuilder* 的 *setSpan(Object what, int start, int end, int flags)* 来实现高亮关键字。

SpannableStringBuild用于经常变动的字符串，SpannableString则用于不变的字符串。例如：

<pre class="prettyprint lang-java">
    String str="SpannableStringBuilder class";
    SpannableStringBuilder sp=new SpannableStringBuilder(str);
    sp.setSpan(new ForegroundColorSpan(Color.RED), 1, 4, Spannable.SPAN_EXCLUSIVE_INCLUSIVE); //把str的前4个字符的前景色设置为红色
</pre>
    
这个类还可以用来完成类似于QQ表情的功能。具体用法参考[android api](http://developer.android.com/reference/android/text/Spannable.html)吧。我只用来修改颜色，用正则匹配关键字。可以浏览源代码：[KeywordHighlight.java](https://github.com/hanxi/lua_run/blob/master/src/com/hanxi/luarun/KeywordHighlight.java)。根据[Jota](https://github.com/jiro-aqua/Jota-Text-Editor)修改而来。

## 2. Activity界面跳转

界面跳转用到了*android.content.Intent*。

<pre class="prettyprint lang-java">
    // MainActivity 中这样写
    btn.setOnClickListener(new View.OnClickListener() { // 点击按钮，从MainActivity跳转到ResultActivity
        @Override
        public void onClick(View arg0) {
            Intent intent = new Intent();
            intent.setClass(MainActivity.this,ResultActivity.class);
            Bundle bundle = new Bundle();               // 跳转参数传递
            bundle.putString("result", res);
            intent.putExtras(bundle); 
            startActivity(intent);
        }
    });
    
    // ResultActivity 中这样写
    Bundle bunde = this.getIntent().getExtras();        // 取参数
    String str=bunde.getString("result").toString();
    btn.setOnClickListener(new View.OnClickListener(){  // 自定义返回按钮
        @Override
        public void onClick(View arg0) {
            finish(); //停止当前的Activity,返回上一个Activity
        }            
    });
</pre>
    
代码写完之后需要在AndroidManifest.xml中添加

<pre class="prettyprint lang-xml">
    &lt;application
        android:allowBackup="true"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name">
        &lt;activity
            android:name="com.hanxi.luarun.MainActivity"
            android:label="@string/app_name"
            android:theme="@style/MyTheme">
             &lt;intent-filter>
                &lt;action android:name="android.intent.action.MAIN" />
                &lt;category android:name="android.intent.category.LAUNCHER" />
            &lt;/intent-filter>
        &lt;/activity>
        &lt;activity
            android:name=".ResultActivity"
            android:label="@string/app_name"
            android:theme="@style/MyTheme">
        &lt;/activity>
    &lt;/application>
</pre>

#### 跳转动画 ： TODO

## 3. luajava的使用

    为了在安卓上解释lua，采用了现成的luajava库，编译luajava可以参考 [集成Lua到你的Android游戏](http://www.cnblogs.com/astin/archive/2011/07/26/2117590.html)。luajava.h可以使用javah生成。后台我找到了现成[AndroLua](https://github.com/mkottman/AndroLua)。直接把它集成到我的项目中的了。
    
<pre class="prettyprint lang-java">
    import org.keplerproject.luajava.*;
    
    LuaState L = LuaStateFactory.newLuaState();
    L.openLibs();
    L.LdoString("text = 'Hello Android, I am Lua.'");
    L.getGlobal("text");
    String text = L.toString(-1);
</pre>
    
看上去和c与lua交互很类似的。


## 4. WebView的使用

    最初以为高亮代码很难自己实现，就试着找现成的源码，结果没找到。就想着看看有没有js实现的代码编辑器，后面找到了一个不错的[codemirror](https://github.com/marijnh/CodeMirror)。并且集成到我的项目中在android4.0以上设备显示还不错，但是在2.3的设备上不能滑动（webview不支持div的滑动），底层的硬伤，试过修改codemirror和使用iscroll都没搞定，最后才找到jota（2年前见过这玩意，用过一两次没注意到它是开源的），然后研究它的源代码，就有了现在的高亮了。

    WebView控件很简单的。js和java交互网上也找到很多教程[](http://blog.csdn.net/wangtingshuai/article/details/8631835)。
    
<pre class="prettyprint lang-java">
    WebView webView = new WebView(this); 
    webView.getSettings().setJavaScriptEnabled(true);   // 开启js，不打开这个设置，就只能显示静态的html网页
    webView.loadUrl("http://www.baidu.com/");           // 远程网页
    //webView.loadUrl("file:///android_asset/demo.html"); // 本地assert目录下demo.html
</pre>
    
差不多就这样子，我打算用这个来显示about.html的东西。

## 5. 文件浏览

    这个功能一开始就不打算自己实现，现在开发安卓的这么多，一定能找到这种源码，结果一下子就找到了现成的文件选择对话框[Android开发 打开文件 选择文件对话框](http://blog.csdn.net/trbbadboy/article/details/7899424)。已经集成到我的项目中了，我还模仿它完成了保存文件对话框的功能。
    
    实现保存文件对话框的时候难点就在于如何在静态的layout中添加动态的layout，[android: 静态XML和动态加载XML混合使用，以及重写Layout控件](http://blog.csdn.net/lzx_bupt/article/details/5600187) 这篇文章对我帮助挺大的。
    
    封装静态的layout，其中预留动态layout的位置，方便添加动态layout的时候整理布局不变。
    
<pre class="prettyprint lang-java">
        static public class SaveDialogLayout extends LinearLayout{ 
            public SaveDialogLayout(Context context) {
                super(context);
                ((Activity) getContext()).getLayoutInflater().inflate(R.layout.dialog, this); 
            }        
        }
        
        public static Dialog createSaveDialog(int id, Context context, ... ){
            AlertDialog.Builder builder = new AlertDialog.Builder(context);
            final SaveDialogLayout saveDialogLayout = new SaveDialogLayout(context);   
            LinearLayout openLayout = (LinearLayout) saveDialogLayout.findViewById(R.id.openLayout); // 预留放文件列表
            FileSelectView fileListView = new FileSelectView(context, id, callback, suffix, images,path); // 文件列表
            openLayout.addView(fileListView); // 添加到预留位置
            builder.setView(saveDialogLayout);
            ...        
        }    
</pre>

### TODO:

6. 添加设置

7. 添加广告

8. 优化界面

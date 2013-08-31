---
layout: post
title: "[原创]C++指向成员函数的函数指针随想"
tagline: "The point to member function think about"
description: "关于指向成员函数的指针所想到的:类函数指针成员,指向成员函数的类成员指针"
tags: ["C++", "函数指针", "成员函数"]
categories: ["技术"]
---
{% include JB/setup %}

### 指向成员函数的函数指针
首先看一个指向成员函数的函数指针的例子,比较常用,代码如下:
<pre class="prettyprint lang-cpp">
    class A {
    public:
        void func() {
            cout << "func" << endl;
        }
    };
    int main(int argc, char * argv[]) {
        void (A::pf)() = &A::func;
        A a;
        (a.*pf)();
        return 0;
    }
</pre>
可以看到,定义指向类A的成员函数A::func()的函数指针定义pf的格式必须带上A::,给pf赋值不能使用对象a的func赋值,而必须使用A::,且必须加上&(普通的c函数是可以不加&的).<br>
使用&a.func对pf赋值时,我使用g++编译,给出的错误提示很明确易懂:<br>
错误： ISO C++ 不允许通过取已绑定的成员函数的地址来构造成员函数指针。请改用‘&A::funcB’ [-fpermissive]<br>

ps: 网上有人说clang给出的提示更好,但现在测试出来clang给出的提示很模糊:<br>
error: cannot create a non-constant pointer to member function<br>
    p = &a.funcB;<br>
        ^~~~~~~~<br>
g++给出错误位置是多少行多少列,clang则是用波浪线标出来的.

### 类成员为函数指针
<pre class="prettyprint lang-cpp">
    class A {
    public:
        void (*pq)();
    };
    void func() {
        cout << "func " << endl;
    }
    int main(int argc, char * argv[]) {
        A a;
        a.pq = func;
        a.pq();
        return 0;
    }
</pre>
这个例子也验证了第一个例子所说的,c函数指针赋值是不用加&的. 这个例子学习C语言的时候就见过了,写出来只是为了过度到第三个更加复杂例子的.

### 类成员函数指针指向类成员
<pre class="prettyprint lang-cpp">
    class A {
    public:
        void func() {
            cout << "func " << endl;
        }
        void (A::*p)();  //  必须加A::
        A () { // 更加但痛的调用方式
            p = &A::func; // 必须加A::
            (this->*p)();
        }
    };
    int main(int argc, char * argv[]) {
        A a;
        a.p = &A::func;
        (a.*(a.p))(); // 和第一个例子有点像,使用a.p替换pf就是了.
        return 0;
    }
</pre>
首先是函数指针的定义,指向自己所在类的成员函数,定义的时候必须加A::前缀.然后在给p赋值的时候必须和第一个例子一样加A::(成员函数内部使用也不例外).然后就是使用p的时候.在成员函数内部使用(this->*p)();.在A的对象中使用(a.*(a.p))();的方式.

函数指针的作用就是为了实现多态吧.下面是我的全部测试代码.在gcc4.7,clang3.0测试通过.没在网上找啥资料,全靠编译器的错误提示完成这段代码,错误之处还望读者提出来.

<script src="https://gist.github.com/hanxi/6399464.js"></script>

---
layout: post
title: "[原创]C++对象模型概述"
tagline: "C++ object model summary"
description: "对C++对象模型的一个概述，提供以对象为基础的观念背景，以及由C++提供的面向对象程序设计典范"
tags: ["C++", "对象模型", "读书笔记"]
categories: ["技术"]
---
{% include JB/setup %}

###C++额外负担
C++在布局以及存取时间上主要的额外负担是由virtual引起，包括：

* virtual function机制，用以支持一个有效率的执行期绑定（runtime binding）
* virtual base class，用以实现多次出现在继承体系中的base class，有一个单一而被共享的实体

###3种对象模型
####简单对象模型
一个对象是一系列的slots，每一个slots指向一个members，members按其声明次序，各被指定一个slot。每个成员数据或成员函数都有自己的一个slot。
该观念用在C++的指向成员的指针（point-to-member）观念之中。

####表格驱动对象模型
对象本身内含一个指向data member table 的指针和一个指向member function table的指针，member function table 是一系列的slots，每一个slot指向一个member function; data member table 直接含有data本身。

* 缺点：时间和空间效率低
* 优点：有弹性

member function table 这个观念用在virtual function。

####C++对象模型
非静态成员数据（nonstatic data members）被配置在每一个对象（class object）之内，静态成员数据（static data members）则被存储在对象之外。静态(static)和非静态成员函数（nonstatic function members）被放在所有的对象之外。虚函数则根据下面两个步骤实现：

1.每个类产生一堆指向虚函数的指针，放在vtbl（virtual table）表中。

2.每个对象被添加一个指针，指向相关的vtbl表，通常这个指针被称为vptr，vptr的设定（setting）和重置（resetting）都由每个类的构造函数，析构函数和赋值运算符自动完成，每个类所关联的type_info对象（用于支持RTTI）也经由vtbl被指出来，通常放在表中第一个slot处。

* 缺点：如果应用程序代码没有改变，但所用到的对象的类非静态成员有所修改（增加，移除或更改），那么应用程序的代码同样需要重新编译。

* 优点：空间和存取时间的效率高。

###struct
为兼容c而存在的struct关键字，将C与C++组合在一起的做法：
1.从C struct 中派生C++部分：

<pre class="prettyprint lang-cpp">
struct C_point { ... };
class Point : public C_point { ... };
</pre>

于是C和C++两种用法都可以得到支持：

<pre class="prettyprint lang-cpp">
extern void draw_line( Point, Point);
extern "C" void draw_rect(C_point, C_point);

draw_line(Point(0,0),Point(100,100));
draw_rect(Point(0,0),Point(100,100));
</pre>

2.第一种方法已不再推荐，而使用组合代替继承：

<pre class="prettyprint lang-cpp">
struct C_point { ... };

class Point {
public:
    operator C_point() { return _c_point;}
    // ...
private:
    C_point _c_point;
    // ...
};
</pre>

故，C struct在C++中的一个合理用途，是你要传递“一个复杂的class object的全部或部分”到某个C函数中去，struct声明可以将数据封装起来，并保证拥有与C兼容的空间布局。然而这项保证只在组合（composition）的情况下存在。如果是继承而不是组合，编译器会决定是否应该有额外的data members 被安插在base struct subobject之中。

###三种程序设计典范（programing paradigms）
#### 程序模型
函数式编程，就像C一样。
#### 抽象数据类型模型（abstract data type model，ADT）
抽象是指和一组表达式一起提供，而其运算定义仍然隐而未明。封装类型使其像基本类型一样使用，如string类。
#### 面向对象模型（object-oriented model， OO）
一些相关类型通过一个抽象的基类（共通接口）被封装起来。只有通过指针和引用的间接处理，才支持OO程序设计所需要的多态性质。

###C++通过下列方法支持多态：
* 经由一组隐含的转化操作，例如把一个derived class指针转化为一个指向其public base type的指针：
<pre class="prettyprint lang-cpp">
    shape *ps = new circle();
</pre>
* 经由virtual function机制：
<pre class="prettyprint lang-cpp">
    ps->rotate();
</pre>
* 经由dynamic_cast和typeid运算符：
<pre class="prettyprint lang-cpp">
    if (circle *pc = dynamic_cast<circle* >(ps) ) ...
</pre>

###对象的内存大小
1. 非静态成员数据的总和大小。
2. 加上由于alignment（将数值调整到某数的倍数）的需求而填补上去的空间（存在members之间或集合体末尾）。
3. 加上为支持virtual而由内部产生的任何额外负担。

C++通过class的指针和引用来支持多态，这种程序设计风格就称为面向对象。
在弹性（OO）和效率（OB）之间存在取舍，一个人在能够有效选择其一之前，必须先清楚两者的行为和应用领域的需求。


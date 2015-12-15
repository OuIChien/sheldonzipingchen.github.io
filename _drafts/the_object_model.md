---
layout: post
title: "Ruby 对象模型"
date: 2015-09-22 11:15:00 +0800
description: Ruby 元编程学习笔记
categories: ruby rails
---

元编程（metaprogramming）就是操控语言构件，比如类（class）、模块（module）以及实例变量（instance variable）等。所有这些语言构件存在于其中的系统称为对象模型（object model）。在对象模型中，你可以找到诸如“这个方法来自哪个类”和“当我包含这个模块时会发生什么”此类问题的答案。

对象模型是 Ruby 的灵魂，认真钻研它不仅能学到一些功能强大的技术，还能避免陷入某些陷阱。

# 打开类

一个例子，打开 String 类并且在其中植入了 to_alphanumeric() 方法：

{% highlight ruby %}
class String
    def to_alphanumeric
        gsub /[^\w\s]/, ''
    end
end
{% endhighlight %}

## 类定义揭秘

从某种意义上来说， Ruby 的 class 关键字更像是一个作用域操作符而不是类型声明语句。它的确可以创建一个还不存在的类，不过也可以把这看成是一种副作用。对于 class 关键字，其核心任务是把你带到类的上下文中，让你可以在其中定义方法。

对 class 关键字的剖析并非只有学术意义，它还具有重要的实践意义：你总是可以重新打开已经存在的类并对它进行动态修改，即使是像 String 或者 Array 这样标准库中的类也不例外。这种技术，可以简单称之为打开类（Open Class）技术。

## 打开类所带来的问题

在使用打开类定义自己的方法的时候，无意中覆盖了原来的方法，而程序中的某些部分依赖于原有的这个方法，这会导致 bug。一些人对这种修订类的鲁莽方式深感不悦，他们给这种方式起了一个不太好听的名字：猴子补丁（Monkey Patch）。

# 类的真相

## 对象中有什么

这里先创建一些基本的东西，在 irb 里输入如下代码：

{% highlight ruby %}
class MyClass
    def my_method
        @v = 1
    end
end

obj = MyClass.new
obj.class     # => MyClass
{% endhighlight %}

如果查看 obj 对象，如果打开 Ruby 的解释器来查看 obj 对象内部，那么会看到什么呢？

### 实例变量

最重要的是，对象包含了实例变量。虽然不一定要知道它们是什么，但非要这么做的话，可以调用 Object#instance_variables() 方法。在上面的例子中， obj 对象只有一个实例变量：

{% highlight ruby %}
obj.my_method
obj.instance_variables
{% endhighlight %}

Ruby 中的对象的类和它的实例变量没有关系，当给实例变量赋值时，它们就生成了。因此，对同一个类，你可以创建具有不同实例变量的对象。

### 方法

除了实例变量，对象还有方法。通过调用 Object#methods() 方法，可以获得一个对象的方法列表。绝大多数的对象（包括上面示例代码中的 obj 对象）都从 Object 类中继承了一组方法，因此这个列表会很长。可以使用 Array#grep() 方法向你展示了 my\_method() 方法确实在 obj 对象方法列表中： obj.methods.grep(/my/)  # => [:my_method]

如果可以撬开 Ruby 解释器并查看 obj ,那么你会注意到这个对象其实并没有真正存放一组方法。在其内部，一个对象仅仅包含它的实例变量以及一个对自身类的引用。那么，方法在哪里呢？

共享同一个类的对象也共享同样的方法，因此方法必须存放在类中，而非对象中。如下图所示：

<img src="/assets/images/instance_class.png"/>

为了消除二义性，应该说 my_method() 是 MyClass 的一个实例方法（而不是简单的“方法”）。这意味着这个方法定义在 MyClass 中，需要定义一个 MyClass 的实例才能调用它。还是那个方法，不过在讨论类的时候，需要说明这是一个实例方法：在讨论对象的时候，就可以说它是一个方法。记住这个区别，这样在写像下面这样的自省方法时就不会感到困惑：

{% highlight ruby %}
String.instance_methods == "abc".methods   # => true
String.methods == "abc".methods   # => false
{% endhighlight %}

总结：一个对象的实例变量存在于对象本身，而一个对象的方法存在于对象自身的类。这就是为什么同一个类的对象共享同样的方法，但不共享实例变量的原因。

这些就是你需要知道的关于对象、实例变量和方法的内容。

# 重访类

类自身也是对象。既然类是对象，那么适用于对象的规则也适用于类。类和其他任何对象一样，也有自己的类，它的名字叫做 Class ：

{% highlight ruby %}
"hello".class  # => String
String.class  # => Class
{% endhighlight %}

象其他任何对象一样，类也有方法。一个对象的方法也是其类的实例方法。这意味着一个类的方法就是 Class 的实例方法：

{% highlight ruby %}
inherited = false
Class.instance_methods(inherited)   # => [:superclass, :allocate, :new]
{% endhighlight %}

new() 方法，总是用它来创建对象。 allocate() 方法是 new() 方法的支撑方法。 superclass() 方法就像其名字所暗示的，返回一个类的超类。

{% highlight ruby %}
String.superclass        # => Object
Object.superclass        # => BasicObject
BasicObject.superclass   # => nil
{% endhighlight %}

所有的类最终都继承于 Object，Object 本身又继承了 BasicObject，BasicObject 是 Ruby 对象体系中的根节点。下面演示了 Class 的超类：

{% highlight ruby %}
Class.superclass        # => Module
Module.superclass       # => Object
{% endhighlight %}

因此，一个类只不过是一个增强的 Module，增加了三个方法 —— new()、 allocate() 和 superclass() 而已。这几个方法可以让你创建对象并可以把它们纳入到类体系架构中。除此之外，类和模块基本上是一样的。绝大多数适用于类的内容也同样适用于模块，反之亦然。

类和普通的对象可以和谐相处的，它们的关系如下图所示：

<img src="/assets/images/object_class.png" />

正如普通的对象那样，也是通用引用来访问类。回顾上面的代码，你会发现 obj1 和 MyClass 都是引用 —— 唯一的区别在于， obj1 是一个变量，而 MyClass 是一个常量。换句话说，就像类是对象一样，类名也无非就是常量。

# 常量

任何以大写字母开头的引用（包类类名和模块名），都是常量。常量的作用域不同于变量的作用域，它有自己独特的规则。

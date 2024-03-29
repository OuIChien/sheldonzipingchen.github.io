---
layout: post
title: "如何成为Python高手"
date: 2015-06-20 00:41:00 +0800
description: 学习 Python 的资料总结
categories: python 读书笔记
---

原文来源于：[如何成为Python高手](http://blogread.cn/it/article/3892?f=wb)

这篇文章主要是对我收集的一些文章的摘要。因为已经有很多比我有才华的人写出了大量关于如何成为优秀Python程序员的好文章。

我的总结主要集中在四个基本题目上：

<!--more-->

1. 函数式编程，
2. 性能，
3. 测试，
4. 编码规范。

如果一个程序员能将这四个方面的内容知识都吸收消化，那他/她不管怎样都会有巨大的收获。

## 函数式编程

命令式的编程风格已经成为事实上的标准。命令式编程的程序是由一些描述状态转变的语句组成。虽然有时候这种编程方式十分的有效，但有时也不尽如此(比如复杂性) ―― 而且，相对于声明式编程方式，它可能会显得不是很直观。

如果你不明白我究竟是在说什么，这很正常。这里有一些文章能让你脑袋开窍。但你要注意，这些文章有点像《骇客帝国》里的红色药丸 ―― 一旦你尝试过了函数式编程，你就永远不会回头了。

* [http://www.amk.ca/python/writing/functional](http://www.amk.ca/python/writing/functional)
* [http://www.secnetix.de/olli/Python/lambda_functions.hawk](http://www.secnetix.de/olli/Python/lambda_functions.hawk)
* [http://docs.python.org/howto/functional.html](http://docs.python.org/howto/functional.html)

## 性能

你会看到有如此多的讨论都在批评这些“脚本语言”(Python，Ruby)是如何的性能低下，可是你却经常的容易忽略这样的事实：是程序员使用的算法导致了程序这样拙劣的表现。

这里有一些非常好的文章，能让你知道Python的运行时性能表现的细节详情，你会发现，通过这些精炼而且有趣的语言，你也能写出高性能的应用程序。而且，当你的老板质疑Python的性能时，你别忘了告诉他，这世界上第二大的搜索引擎就是用Python写成的 ―― 它叫做Youtube(参考Python摘录)

* [http://jaynes.colorado.edu/PythonIdioms.html](http://jaynes.colorado.edu/PythonIdioms.html)
* [http://jaynes.colorado.edu/PythonIdioms.html](http://jaynes.colorado.edu/PythonIdioms.html)

## 测试

如今在计算机科学界，测试可能是一个最让人不知所措的主题了。有些程序员能真正的理解它，十分重视TDD(测试驱动开发)和它的后继者BDD(行为驱动开发)。而另外一些根本不接受，认为这是浪费时间。那么，我现在将告诉你：如果你不曾开始使用TDD/BDD，那你错过了很多最好的东西！

这并不只是说引入了一种技术，可以替换你的公司里那种通过愚蠢的手工点击测试应用程序的原始发布管理制度，更重要的是，它是一种能够让你深入理解你自己的业务领域的工具 ―― 真正的你需要的、你想要的攻克问题、处理问题的方式。如果你还没有这样做，请试一下。下面的这些文章将会给你一些提示：

* [http://www.oreillynet.com/lpt/a/5463](http://www.oreillynet.com/lpt/a/5463)
* [http://www.oreillynet.com/lpt/a/5584](http://www.oreillynet.com/lpt/a/5584)
* [http://wiki.cacr.caltech.edu/danse/index.php/Unit_testing_and_Integration_testing](http://wiki.cacr.caltech.edu/danse/index.php/Unit_testing_and_Integration_testing)
* [http://docs.python.org/library/unittest.html](http://docs.python.org/library/unittest.html)

## 编码规范

并非所有的代码生来平等。有些代码可以被另外的任何一个好的程序员读懂和修改。但有些却只能被读，而且只能被代码的原始作者修改 ―― 而且这也只是在他或她写出了这代码的几小时内可以。为什么会这样？因为没有经过代码测试(上面说的)和缺乏正确的编程规范。

下面的文章给你描述了一个最小的应该遵守的规范合集。如果按照这些指导原则，你将能编写出更简洁和漂亮的代码。作为附加效应，你的程序会变得可读性更好，更容易的被你和任何其他人修改。

* [http://www.python.org/dev/peps/pep-0008/](http://www.python.org/dev/peps/pep-0008/)
* [http://www.fantascienza.net/leonardo/ar/python_best_practices.html](http://www.fantascienza.net/leonardo/ar/python_best_practices.html)

那就去传阅这这些资料吧。从坐在你身边的人开始。也许在下一次程序员沙龙或编程大会的时候，也已经成为一名Python编程高手了！

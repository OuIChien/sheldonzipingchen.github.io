---
title: "语法最佳实践 —— 低于类级"
date: 2015-06-20 00:42:40 +0800
description: Python 学习笔记，列表推导，生成器模式的总结
---


## 列表推导
编写如下所示的代码是令人痛苦的。

~~~ python
    In [4]: numbers = range(10)

    In [5]: size = len(numbers)

    In [6]: evens = []

    In [7]: i = 0

    In [8]: while i < size:
       ...:     if i % 2 == 0:
       ...:         evens.append(i)
       ...:     i += 1
       ...:

    In [9]: evens
    Out[9]: [0, 2, 4, 6, 8]
~~~

这对于C语言而言或许是可行的，但是在 Python 中它确实会使程序的执行速度变慢了，因为：

<!--more-->

* 它使解释程序在每次循环中都要确定序系中的哪一个部分被修改；
* 它使得必须通过一个计数器来跟踪必须处理的元素。

List comprehensions 是这种场景下的正确选择，它使用编排好的特性来前述语法中的一部分进行了自动化处理，如下所示：

~~~ python 使用列表推导
    In [10]: [i for i in range(10) if i % 2 == 0]
    Out[10]: [0, 2, 4, 6, 8]
~~~

这种编写方法除了高效之外，也更加简短，涉及的元素也更少。在更大的程序中，这意味着引入的缺陷更少，代码更容易阅读和理解。

Python 风格的语法的另一个典型例子是使用 enumerate。这个内建函数为在循环中使用序列时提供了更加便利的获得索引的方式，例如下面这个代码块。

~~~ python 使用 enumerate
    In [11]: i = 0

    In [12]: seq = ["one", "two", "three"]

    In [13]: for element in seq:
       ....:     seq[i] = '%d: %s' % (i, seq[i])
       ....:     i += 1
       ....:

    In [14]: seq
    Out[14]: ['0: one', '1: two', '2: three']
~~~

它可以用以下简短的代码块代替。

~~~ python 使用 enumerate，结合列表推导
    In [1]: seq = ['one', 'two', 'three']

    In [2]: def _treatment(pos, element):
       ...:     return '%d: %s' % (pos, element)
       ...:

    In [3]: [_treatment(i, el) for i, el in enumerate(seq)]
    Out[3]: ['0: one', '1: two', '2: three']
~~~

最后，这个版本的代码更容易矢量化，因为它共享了基于序列中单个项目的小函数。

==Python 风格的语法意味着什么==

Python 风格的语法是一种对小代码模式最有效的语法。这个词也适用于诸如程序库这样的高级别的事物上。在那种情况下，如果程序库能够很好地使用 Python 的风格，它就被认为是 Python 化（Phthonic）的。在开发社群中，这个术语有时被用来对代码块进行分类。

每当要对序列中的内容进行循环处理时，就应该尝试用 List comprehensions 来代替它。

## 迭代器和生成器

迭代器只不过是一个实现迭代器协议的容器对象。它基于两个方法：

* next 返回容器的下一个项目；
*  _iter__ 返回迭代器本身。

迭代器可以通过使用一个 iter 内建函数和一个序列来创建，示例如下：

~~~ python 迭代器示例
    In [15]: i = iter('abc')

    In [16]: i.next()
    Out[16]: 'a'

    In [17]: i.next()
    Out[17]: 'b'

    In [18]: i.next()
    Out[18]: 'c'

    In [19]: i.next()
    ---------------------------------------------------------------------------
    StopIteration                             Traceback (most recent call last)
    <ipython-input-19-e590fe0d22f8> in <module>()
    ----> 1 i.next()

    StopIteration:
~~~

当序列遍历完时，将抛出一个 StopIteration 异常。这将使迭代器与循环兼容，因为它们将捕获这个异常以停止循环。要创建定制的迭代器，可以编写一个具有 next 方法的类，只要该类能够提供返回迭代器实例的 \__iter__ 特殊方法。

~~~ python 自定义迭代器
    In [20]: class MyIterator(object):
       ....:     def __init__(self, step):
       ....:         self.step = step
       ....:     def next(self):
       ....:         """ Returns the next element."""
       ....:         if self.step == 0:
       ....:             raise StopIteration
       ....:         self.step -= 1
       ....:         return self.step
       ....:     def __iter__(self):
       ....:         """ Returns the iterator itself."""
       ....:         return self
       ....:

    In [21]: for el in MyIterator(4):
       ....:     print el
       ....:
    3
    2
    1
~~~

迭代器本身是一个底层的特性和概念，在程序中可以没有它们。但是它们为生成器这一更有趣的特性提供了基础。

## 生成器

生成器提供了一种出色的方法，使得需要返回一系列元素的函数所需的代码更加简单、高效。基于 yield 指令，可以暂停一个函数并返回中间结果。该函数将保存执行环境并且可以在必要时恢复。

例如（这是PEP中关于迭代器的实例），Fibonacci 数列可以用一个迭代器来实现，如下所示。

~~~ python 生成器示例
    In [22]: def fibonacci():
       ....:     a, b = 0, 1
       ....:     while True:
       ....:         yield b
       ....:         a, b = b, a + b
       ....:

    In [23]: fib = fibonacci()

    In [24]: fib.next()
    Out[24]: 1

    In [25]: fib.next()
    Out[25]: 1

    In [26]: fib.next()
    Out[26]: 2

    In [27]: [fib.next() for i in range(10)]
    Out[27]: [3, 5, 8, 13, 21, 34, 55, 89, 144, 233]
~~~

该函数返回一个特殊的迭代器，也就是 generator 对象，它知道如何保存执行环境。对它的调用是不确定的，每次都将产生序列中的下一个元素。这种语法很简洁，算法的不确定特性并没有影响代码的可读性。不必提供使函数可停止的方法。实际上，这看上去像是用伪代码设计的序列一样。

PEP 的含义是 Python 增强建议（Python Enhancement Proposal）。它是在 Python 上进行修改的文件，也是开发社团讨论的一个出发点。

进一步的信息参见 [http://www.python.org/dev/peps/pep-0001](http://www.python.org/dev/peps/pep-0001) 。

当需要一个将返回一个序列或在循环中执行的函数时，就应该考虑生成器。当这些元素将被传递到另一个函数中以进行后续处理时，一次返回一个元素能够提高性能。

例如，来自标准程序库的 tokenize 模块将在文本之外生成令牌，并且针对每个处理过的行返回一个迭代器，这可以被传递到一些处理中，如下所示：

~~~ python 迭代器的使用
    In [1]: import tokenize

    In [2]: reader = open('config.py').next

    In [3]: tokens = tokenize.generate_tokens(reader)

    In [4]: tokens.next()
    Out[4]: (53, '# -*- coding: UTF-8 -*-', (1, 0), (1, 23), '# -*- coding: UTF-8 -*-\n')

    In [5]: tokens.next()
    Out[5]: (54, '\n', (1, 23), (1, 24), '# -*- coding: UTF-8 -*-\n')

    In [6]: tokens.next()
    Out[6]:
    (3,
     '""" \xe7\xb3\xbb\xe7\xbb\x9f\xe9\x85\x8d\xe7\xbd\xae\xe6\x96\x87\xe4\xbb\xb6 """',
     (2, 0),
     (2, 26),
     '""" \xe7\xb3\xbb\xe7\xbb\x9f\xe9\x85\x8d\xe7\xbd\xae\xe6\x96\x87\xe4\xbb\xb6 """\n')
~~~

在此我们看到， open 函数遍历了文件中的每个行，而 generate_tokens 则在一个管道中对其进行遍历，完成一些额外的工作。

生成器对降低程序复杂性也有帮助，并且能够提升基于多个序列的数据转换算法的性能。把每个序列当作一个迭代器，然后将它们合并到一个高级别的函数中，这是一种避免函数变得庞大、丑陋、不可理解的好办法。而且，这可以给整个处理链提供实时的反馈。

在下面的示例中，每个函数用来在序列上定义一个转换。然后它们被链接起来应用。每次调用将处理一个元素并返回其结果，如下所示：

~~~ python 生成器的使用
    In [7]: def power(values):
       ...:     for value in values:
       ...:         print 'powing %s' % value
       ...:         yield value
       ...:

    In [8]: def adder(values):
       ...:     for value in values:
       ...:         print 'adding to %s' % value
       ...:         if value % 2 == 0:
       ...:             yield value + 3
       ...:         else:
       ...:             yield value + 2
       ...:

    In [9]: elements = [1, 4, 7, 9, 12, 19]

    In [10]: res = adder(power(elements))

    In [11]: res.next()
    powing 1
    adding to 1
    Out[11]: 3

    In [12]: res.next()
    powing 4
    adding to 4
    Out[12]: 7

    In [13]: res.next()
    powing 7
    adding to 7
    Out[13]: 9
~~~

==保持代码简单，而不是数据==

拥有许多简单的处理序列值的可迭代函数，要比一个复杂的、每次计算一个值的函数更好一些。

Python 引入的与生成器相关的最后一个特性是提供了与 next 方法调用的代码进行交互的功能。 yield 将变成一个表达式，而一个值可以通过名为 send 的新方法来传递，如下所示：

~~~ python send方法示例
    In [14]: def psychologist():
       ....:     print 'Please tell me your problems'
       ....:     while True:
       ....:         answer = (yield)
       ....:         if answer is not None:
       ....:             if answer.endswith('?'):
       ....:                 print ("Don't ask yourself too much questions")
       ....:             elif 'good' in answer:
       ....:                 print ("A that's good, go on")
       ....:             elif 'bad' in answer:
       ....:                 print ("Don't be so negative")
       ....:

    In [15]: free = psychologist()

    In [16]: free.next()
    Please tell me your problems

    In [17]: free.send('I feel bad')
    Don't be so negative

    In [18]: free.send("Why I shouldn't ?")
    Don't ask yourself too much questions

    In [19]: free.send("ok then i should find what is good fot me")
    A that's good, go on
~~~

send 的工作机制与 next 一样，但 yield 将变成能够返回传入的值。因而，这个函数可以根据客户端代码来改变其行为。同时，还添加了 throw 和 close 两个函数，以完成该行为。它们将向生成器抛出一个错误：

* throw 允许客户端代码传入要抛出的任何类型的异常；
* close 的工作方式是相同的，但是将会抛出一个特定的异常——GeneratorExit，在这种情况下，生成器函数必须再次抛出 GeneratorExit 或 StopIteration 异常。

因此，一个典型的生成器模板应该类似于如下所示：

~~~ python 生成器的通用模板
    In [20]: def my_generator():
       ....:     try:
       ....:         yield 'something'
       ....:     except ValueError:
       ....:         yield 'dealing with the exception'
       ....:     finally:
       ....:         print "ok let's clean"
       ....:

    In [21]: gen = my_generator()

    In [22]: gen.next()
    Out[22]: 'something'

    In [23]: gen.throw(ValueError('mean mean mean'))
    Out[23]: 'dealing with the exception'

    In [25]: gen.close()
    ok let's clean

    In [26]: gen.next()
    ---------------------------------------------------------------------------
    StopIteration                             Traceback (most recent call last)
    <ipython-input-26-b2c61ce5e131> in <module>()
    ----> 1 gen.next()

    StopIteration:
~~~

finally 部分将捕获任何未被捕获的 close 和  throw 调用，是完成清理工作的推荐方式。 GeneratorExit 异常在生成器中是无法捕获的，因为它被编译器用来确定调用 close 时是否正常退出。如果有代码与这个异常关联，那么解释程序将抛出一个系统错误并退出。

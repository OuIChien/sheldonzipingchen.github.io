---
title: "Python 面向对象编程概述"
date: 2015-06-25 00:57:48 +0800
description: Python 面向对象编程入门笔记
---
## 类与实例

类与实例相互关联着：类是对象的定义，而实例是“真正的实物”，它存放了类中所定义的对象的具体信息。

下面的示例展示了如何创建一个类：

~~~ python
class MyNewObjectType(bases):
	' 创建 MyNewObjectType 类'
	class_suite
~~~

关键字是 class，紧接着一个类名。随后是定义类的类代码。这里通常由各种各样的定义和声明组成。新式类和经典类声明的最大不同在于，所有新式类必须继承至少一个父类，参数 bases 可以是一个（单继承）或多个（多重继承）用于继承的父类。

创建一个实例的过程称作实例化，过程如下（注意：没有使用 new 关键字）：

~~~ python
myFirstObject = MyNewObjectType()
~~~

<!--more-->

类名使用我们所熟悉的函数操作符（()），以“函数调用”的形式出现。然后你通常会把这个新建的实例赋给一个变量。赋值在语法上不是必须的，但如果你没有把这个实例保存到一个变量中，它就没用了，会被自动垃圾收集器回收，因为任何引用指向这个实例。这样，你刚刚所做的一切，就是为那个实例分配了一块内存，随即又释放了它。

类既可以很简单，也可以很复杂，这全凭你的需要。最简单的情况，类仅用作名称空间（namespace）。这意味着你把数据保存在变量中，对他们按名称空间进行分组，使得他们处于同样的关系空间中——所谓的关系是使用标准 Python 句点属性标识。例如，你有一个本身没有任何属性的类，使用它仅对数据提供一个名字空间，让你的类拥有像 C 语言中的结构体（structure）一样的特性，或者换句话说，这样的类仅作为容器对象来共享名字空间。

示例如下：

~~~ python
class MyData(object):
	pass

>>> mathObj = MyData()
>>> mathObj.x = 4
>>> mathObj.y = 5
>>> mathObj.x + mathObj.y
9
>>> mathObj.x * mathObj.y
20
~~~

## 方法

在 Python 中，方法定义在类定义中，但只能被实例所调用。也就是说，调用一个方法的最终途径必须是这样的：（1）定义类（和方法）；（2）创建一个实例；（3）最后一步，用这个实例调用方法。例如：

~~~ python
class MyDataWithMethod(object):	# 定义类
	def printFoo(self):	# 定义方法
		print 'You invoked printFoo()!'
~~~

这里的 self 参数，它在所有的方法声明中都存在。这个参数代表实例对象本身，当你用实例调用方法时，由解释器传递给方法的，所以，你不需要自己传递 self 进来，因为它是自动传入的。

举例说明一下，假如你有一个带两参数的方法，所有你的调用只需要传递第二个参数。

下面是实例化这个类，并调用那个方法：

~~~ python
>>> myObj = MyDataWithMethod()
>>> myObj.printFoo()
You invoked printFoo()!
~~~

\_\_init\_\_()，是一个特殊的方法。在 Python 中， \_\_init\_\_() 实际上不是一个构造器。你没有调用“new”来创建一个新对象。（Python 根本就没有“new”这个关键字）。取而代之， Python 创建实例后，在实例化过程中，调用 \_\_init\_\_()方法，当一个类被实例化时，就可以定义额外的行为，比如，设定初始值或者运行一些初步诊断代码——主要是在实例被创建后，实例化调用返回这个实例之前，去执行某些特定的任务或设置。

## 创建一个类（类定义）

~~~ python
class AddrBookEntry(object):
	'address book entry class'
	def __init__(self, nm, ph):	# 定义构造器
		self.name = nm				# 设置 name
		self.phone = ph				# 设置 phone
		print 'Created instance for:', self.name
	def updatePhone(self, newph):	# 定义方法
		self.phone = newph
		print 'Updated phone# for: ', self.name
~~~

在 AddrBookEntry 类的定义中，定义了两个方法： \_\_init\_\_()和updatePhone()。\_\_init\_\_()在实例化时被调用，即，在AddrBookEntry()被调用时。你可以认为实例化是对 \_\_init\_\_()的一种隐式的调用，因为传给AddrBookEntry()的参数完全与\_\_init\_\_()接收到的参数是一样的（除了self,它是自动传递的）。

## 创建实例（实例化）
~~~ python
>>> john = AddrBookEntry('John Doe', '408-555-1212') # 为 John Doe 创建实例
>>> jane = AddrBookEntry('Jane Doe', '650-555-1212') # 为 Jane Doe 创建实例
~~~

这就是实例化调用，它会自动调用 \_\_init\_\_()。 self 把实例对象自动传入\_\_init\_\_()。

另外，如果不存在默认的参数，那么传给 \_\_init\_\_() 的两个参数在实例化时是必须的。

## 访问实例属性

~~~ python
>>> john
>>> john.name
>>> jane.name
>>> jane.phone
~~~

一旦实例被创建后，就可以证实一下，在实例化过程中，我们的实例属性是否确实被 \_\_init\_\_() 设置了。我们可以通过解释器“转储”实例来查看它是什么类型的对象。

## 方法调用（通过实例）

~~~ python
>>> john.updatePhone('415-555-1212')	# 更新 John Doe 的电话
>>> john.phone
~~~

updatePhone()方法需要一个参数（不计 self 在内）：新的电话号码。在 updatePhone()之后，立即检查实例属性，可以证实已生效。

## 创建子类

靠继承来进行子类化是创建和定制新类型的一种方式，新的类将保持已存在类所有的特性，而不会改动原来类的定义。对于新类类型而言，这个新的子类可以定制只属于它的特定功能。除了与父类或基类的关系外，子类与通常的类没有什么区别，也像一般类一样进行实例化。注意下面，子类声明中提到了父类：

~~~ python
class EmplAddrBookEntry(AddrBookEntry):
	'Employee Address Book Entry class' # 员工地址簿类
	def __init__(self, nm, ph, id, em):
		AddrBookEntry.__init__(self, nm, ph)
		self.empid = id
		self.email = em
	def updateEmail(self, newem):
		self.email = newem
		print 'Updated e-mail address for:', self.name
~~~

现在我们创建了第一个子类， EmplAddrBookEntry。 Python 中，当一个类被派生出来，子类就继承了基类的属性，所以，在上面的类中，我们不仅定义了 \_\_init\_\_()，UpdateEmail()方法，而且 EmplAddrBookEntry 还从 AddrBookEntry 中继承了 updatePhone()方法。

如果需要，每个子类最好定义它自己的构造器，不然，基类的构造器会被调用。然而，如果子类重写基类的构造器，基类的构造器就不会被自动调用了——这样，基类的构造器就必须显式写出才会被执行，就像我们上面那样，用AddrBookEntry.\_\_init\_\_()设置名字和电话号码。我们的子类在构造器后面几行还设置了另外两个实例属性：员工ID和电子邮件地址。

注意，这里我们要显式传递 self 实例对象给基类构造器，因为我们不是在该实例中而是在一个子类实例中调用那个方法。因为我们不是通过实例来调用它，这种未绑定的方法调用需要传递一个适当的实例（self）给方法。

## 使用子类

~~~ python
>>> john = EmplAddrBookEntry('John Doe', '408-555-1212', 42, 'john@spam.doe')
>>> john
>>> john.name
>>> john.phone
>>> john.email
>>> john.updatePhone('415-555-1212')
>>> john.phone
>>> john.updateEmail('john@doe.spam')
>>> john.email
~~~

一点笔记：

> 命名类、属性和方法
>
> 类名通常由大写字母打头。这是标准惯例，可以帮助你识别类，特别是在实例化过程中（有时看起来像函数调用）。还有，数据属性听起来应当是数据值的名字，方法名应当指出对应对象或值的行为。另一种表达方式是：数据值应该使用名词作为名字，方法使用谓词（动词加对象）。数据项是操作的对象、方法应当表明程序员想要在对象进行什么操作。在上面我们定义的类中，遵循了这样的方针，数据值像“name”， “phone”和“email”，行为如“updatePhone”， “updateEmail”。这就是常说的“混合记法（mixedCase）”或者“骆驼记法（camelCase）”。“Python Style Guide” 推荐使用骆驼记法的下划线方式，比如，“update_phone”， “update_email”。类也要细致命名，像“AddrBookEntry”、“RepairShop”等就是很好的名字。

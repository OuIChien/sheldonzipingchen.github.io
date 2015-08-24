---
title: "模板"
date: 2015-08-12 16:12:58 +0800
description: Flask 模板的简介和使用方法
---

虽然 Flask 并不强迫我们使用任何一个特定的模板语言，它假设我们要使用 Jinja。在 Flask 社区中大部分开发者使用 Jinja，我建议你们也这样做。有很多的扩展帮助我们使用其它的模板语言，像 Flask-Genshi 和 Flask-Mako。坚持使用默认的模板语言，除非你有更好的理由使用其它的模板语言。还不知道 Jinja 语法不是一个好的理由！你会节省大量的时间和烦恼。

<!-- more -->
<em>
当我们提及到 “Jinja” 的时候，就是在说 Jinja2。存在 Jinja1，但是我们不会与它打交道。我们讨论的是这个：[http://jinja.pocoo.org/](http://jinja.pocoo.org/)。
</em>

## Jinja 快速入门

Jinja 官方文档在解释语法和语言的功能上做出很大的工作。我不会在这里重复，但是我要确保你记得这个重要的注意事项：

<em>
有两种分隔符。{% raw %}{% ... %}{% endraw %} 和 {% raw %}{{ ... }}{% endraw %}。第一个用于执行类似 for 循环或者赋值的声明，后者是用于输出表达的结果到模板中。
</em>

## 如何组织模板

那么模板如何融入到我们的应用程序？如果你一直关注 Flask 的话，你可能注意到了 Flask 是十分灵活，它并没有对其内容进行一些特殊的限制。模板也不例外。你可能也注意到了通常有一个推荐的地方来放置东西（比如，模板）。对于模板而言，那个地方就是在包的目录里。

~~~ bash
myapp/
    __init__.py
    models.py
    views/
    templates/
    static/
run.py
requirements.txt
~~~

~~~ bash
templates/
    layout.html
    index.html
    about.html
    profile/
        layout.html
        index.html
    photos.html
    admin/
        layout.html
        index.html
        analytics.html
~~~

templates 目录的结构是与我们路由结构平行的。对于路由 myapp.com/admin/analytics 的模板就是 templates/admin/analytics.html。在目录里面还有一些额外的模板，它们不会直接地被渲染。layout.html 文件是为了让其它的模板继承。

## 继承

很像蝙蝠侠的背景故事一样，一个组织优秀的模板目录很大程度上依靠继承。父模板 通常定义一个通用的结构，所有 子模板 都能很好的继承它。在我们的例子中，layout.html 就是一个父模板而其它 .html 文件就是子模板。

你通常有一个顶层的 layout.html，它定义了你的应用程序的通用布局以及你的网站的每一部分。如果你看看上面的目录的话，你会看到一个顶层的 myapp/templates/layout.html，同样还有 myapp/templates/profile/layout.html 和 myapp/templates/admin/layout.html。最后两个文件继承和修改第一个文件。

~~~ html
{% raw %}
{# _myapp/templates/layout.html_ #}
{% endraw %}
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>{% raw %}{% block title %}{% endblock %}{% endraw %}</title>
    </head>
    <body>
{% raw %}
    {% block body %}
{% endraw %}
        <h1>This heading is defined in the parent.</h1>
{% raw %}
    {% endblock %}
{% endraw %}
    </body>
</html>
~~~

在子模板中，我们可以扩展父模板并且定义这些块的内容。

~~~ html
{% raw %}
{# _myapp/templates/index.html_ #}

{% extends "layout.html" %}
{% block title %}Hello world!{% endblock %}
{% block body %}
    {{ super() }}
{% endraw %}
    <h2>This heading is defined in the child.</h2>
{% raw %}
{% endblock %}
{% endraw %}
~~~

`super()` 函数让我们渲染父级块的内容。

<em>
关于继承的更多信息，请参阅 [Jinja 模板继承文档](http://jinja.pocoo.org/docs/dev/templates/#template-inheritance)。
</em>

## 创建宏

我们可以在我们模板中坚持 DRY（不要重复自己）的原则，通过抽象出重复出现的代码片段到 宏。如果我们正工作在为我们应用程序导航的 HTML 上，我们需要给一个 “活跃的”链接一个 class（class=”active”）。没有宏的话，我们要编写一大段 if ... else 语句，这些语句检查每一个链接找到正处于活跃的一个。

宏提供了一种模块化代码的方式；它们像函数一样工作。让我们看看如何使用宏标记一个活跃的链接。

~~~ html
{% raw %}
{# myapp/templates/layout.html #}

{% from "macros.html" import nav_link with context %}
{% endraw %}
<!DOCTYPE html>
<html lang="en">
    <head>
    {% raw %}
    {% block head %}
    {% endraw %}
        <title>My application</title>
    {% raw %}
    {% endblock %}
    {% endraw %}
    </head>
    <body>
        <ul class="nav-list">
            {% raw %}
            {{ nav_link('home', 'Home') }}
            {{ nav_link('about', 'About') }}
            {{ nav_link('contact', 'Get in touch') }}
            {% endraw %}
        </ul>
    {% raw %}
    {% block body %}
    {% endblock %}
    {% endraw %}
    </body>
</html>
~~~

在这个模板中我们现在要做的就是调用一个未定义的宏 - nav_link -接着向其传递两个参数：目标端点（例如，目标视图的函数名）以及我们要显示的文本。


* 你可能会注意到在导入语句中我们指定了 `with context`。Jinja 的 context 是由传递到 `render_template()` 函数的参数以及来自我们的 Python 代码的 Jinja 环境上下文组成。对于模板来说，这些变量在模板被渲染的时候是可用的。
* 一些变量是明显地由我们传入，例如，`render_template("index.html", color="red")`，但是还有一些变量和函数是由 Flask 自动地包含在上下文中，例如，`request`, `g` 和 `session`。当我们说 `{% raw %}{% from ... import ... with context %}{% endraw %}` 的时候，就是告诉 Jinja 这些变量对宏也可用。
* 通过 Flask 传入到 Jinja 上下文的所有全局变量： [http://flask.pocoo.org/docs/templating/#standard-context](http://flask.pocoo.org/docs/templating/#standard-context)（中文翻译：[http://www.pythondoc.com/flask/templating.html#id2](http://www.pythondoc.com/flask/templating.html#id2)）。
* 我们可以使用上下文处理器定义我们想要的并且插入到 Jinja 上下文的变量和函数: [http://flask.pocoo.org/docs/templating/#context-processors](http://flask.pocoo.org/docs/templating/#context-processors) （中文翻译：[http://www.pythondoc.com/flask/templating.html#id6](http://www.pythondoc.com/flask/templating.html#id6)）。


现在是时候定义在我们模板中使用的 nav_link 宏。

~~~ html
{% raw %}
{# myapp/templates/macros.html #}

{% macro nav_link(endpoint, text) %}
{% if request.endpoint.endswith(endpoint) %}
{% endraw %}
    <li class="active"><a href="{% raw %}{{ url_for(endpoint) }}{% endraw %}">{% raw %}{{text}}{% endraw %}</a></li>
{% raw %}
{% else %}
{% endraw %}
    <li><a href="{% raw %}{{ url_for(endpoint) }}{% endraw %}">{% raw %}{{text}}{% endraw %}</a></li>
{% raw %}
{% endif %}
{% endmacro %}
{% endraw %}
~~~

现在我们已经在 myapp/templates/macros.html 中定义了宏。在这个宏中我们使用了 Flask 的 `request` 对象 — 默认情况下在 Jinja 上下文中是可用的 — 用来检查传入到 `nav_link` 中的路由的端点是否是当前请求。如果是，我们正在当前页面上，接着我们标记它为活跃的。

* 从 x 导入 y 语句采用了 x 的相对路径。如果我们的模板是 myapp/templates/user/blog.html，我们可以在使用 `from "../macros.html"` 导入 `nav_link`。

## 自定义过滤器

Jinja 过滤器是一个函数，它能够在 `{% raw %}{{ ... }}{% endraw %}` 中用于处理一个表达式的结果。在表达式结果输出到模板之前它就被调用。

~~~ html
<h2>{% raw %}{{ article.title|title }}{% endraw %}</h2>
~~~

在这段代码中，`title` 过滤器接收 `article.title` 作为参数并且返回一个过滤后的标题，接着过滤后的标题将会输出到模板中。这就像 UNIX 的“管道化”一个程序到另一个程序的输出。

* 有很多像 title 一样的内置过滤器。请参阅 Jinja 文档中的 [完整列表](http://jinja.pocoo.org/docs/dev/templates/#builtin-filters)。

我们可以在我们的 Jinja 模板中定义自己的过滤器供使用。举例来说，我们将会实现一个简单 caps 过滤器用来大写一个字符串中所有的字母。

* Jinja 已经有一个 `upper` 过滤器来做这样的事情，并且还有一个 `capitalize` 过滤器，它能用来大写第一个字母，小写其余的字母。这些也能处理 unicode 转换，但是我们会继续我们的示例，让大家目前能够知道如何自定义过滤器。

我们要在 myapp/util/filters.py 中定义我们的过滤器。这里给出一个 util 包，它里面有各种各样的模块。

~~~ python
# myapp/util/filters.py

from .. import app

@app.template_filter()
def caps(text):
    """Convert a string to all caps."""
    return text.uppercase()
~~~

在这段代码中我们使用 @app.template_filter() 装饰器注册我们的函数成一个 Jinja 过滤器。默认的过滤器名称就是函数的名称，但是你可以传入一个参数到装饰器中来改变它。

~~~ python
@app.template_filter('make_caps')
def caps(text):
    """Convert a string to all caps."""
    return text.uppercase()
~~~

现在我们可以在模板中调用 `make_caps` 而不是 `{% raw %}caps：{{ "hello world!"|make_caps }}{% endraw %}`。

为了要让我们的过滤器在模板中可用的话，我们只需要在我们的顶层 \_\_init.py\_\_ 的中导入它。

~~~ python
# myapp/__init__.py

# Make sure app has been initialized first to prevent circular imports.
from .util import filters
~~~

## 摘要

* 使用 Jinja 模板。
* Jinja 有两种分隔符：`{% raw %}{% ... %}{% endraw %}` 和 `{% raw %}{{ ... }}{% endraw %}`。 第一个用于执行类似 for 循环或者赋值的声明，后者是用于输出表达的结果到模板中。
* 模板应该在 myapp/templates/ 中 — 例如，在应用程序包中的一个目录。
* 我建议模板/目录结构反映应用程序的 URL 结构。
* 你应该在 myapp/templates 中有一个顶层的 layout.html，同样网站的每一部分也应该有一个。后者继承并且扩展了前者。
* 宏就像由模板代码构成的函数。
* 过滤器就是有 Python 代码组成的函数并且能在模板中使用。

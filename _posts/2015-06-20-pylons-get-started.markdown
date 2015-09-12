---
layout: post
title: "Pylons 入门"
date: 2015-06-20 00:30:48 +0800
description: Pylons 入门教程
categories: python pylons
---

## 环境要求

至少要求 Python 2.4 以上的版本，现在 Python 3 以上还不支持。

## 安装

最好不要直接安装到系统自带的 Python 库里。可以使用像  virtualenv 这样的工具来创建一个独立的 Python 环境。

1. 安装 virtualenv 环境。
2. 运行 virtualenv --no-site-packages mydevenv
3. 运行 pip install Pylons==1.0

这样， Pylons 的环境就安装好了。

<!--more-->

## 创建 Pylons 工程

可以使用下面的命令创建一个叫 helloworld 的工程:

    paster create -t pylons helloworld

运行过程中你需要做出两个选择：

1. 使用哪个模板引擎
2. 是否需要 SQLAlchemy 的支持

我选择了使用 jinja2 和不需要 SQLAlchemy 的支持。

创建的代码结构如下：

> helloworld
>
> > MANIFEST.in
> >
> > README.txt
> >
> > development.ini - 运行时的配置
> >
> > docs
> >
> > ez_setup.py
> >
> > helloworld - 下面再介绍这个目录
> >
> > helloworld.egg-info
> >
> > setup.cfg
> >
> > setup.py -  应用的安装
> >
> > test.ini

下面是 helloworld 目录的代码结构：

> helloworld
>
> > __init__.py
> >
> > config
> > > environment.py - 环境配置
> > >
> > > middleware.py - 中间件
> > >
> > > routing.py - 路由表
> > >
> > controllers - 控制器
> >
> > lib
> > > app_globals.py
> > >
> > > base.py
> > >
> > > helpers.py
> > >
> > model - 模型
> >
> > public
> >
> > templates - 模板
> >
> > tests - 单元测试和功能测试
> >
> > websetup.py -  运行时配置

## 运行应用

可以使用下面命令运行 web 应用：

~~~ bash
    cd helloworld
    paster serve --reload development.ini
~~~

这个命令会读取工程中的 development.ini 文件并启动 Pylons 应用。

访问 [http://127.0.0.1:5000/](http://127.0.0.1:5000/) 可以看到欢迎页。

## Hello World

我们已经创建好了一个基本的工程，现在先让我们创建一个控制器，来处理请求。可以使用下面的命令来创建控制器：

~~~ bash
    paster controller hello
~~~

打开 helloworld/controllers/hello.py 模块，这个会默认返回一个 'Hello World'。

~~~ python
    import logging

    from pylons import request, response, session, tmpl_context as c, url
    from pylons.controllers.util import abort, redirect

    from helloworld.lib.base import BaseController, render

    log = logging.getLogger(__name__)

    class HelloController(BaseController):

        def index(self):
            # Return a rendered template
            #return render('/hello.mako')
            # or, return a string
            return 'Hello World'
~~~

在模块的顶部，已经导入了一些常用的组件了。

访问  [http://127.0.0.1:5000/hello/index](http://127.0.0.1:5000/hello/index) 会看到 'Hello World‘ 这个短语。

URL 配置解释了怎样从 URL 取得对控制器和他们的方法的映射，其实跟 Ruby on Rails 里的映射一模一样。

添加一个 Pylons 对 jinja2 的配置，在 helloworld/config/environment.py 模块里，添加如下代码：

~~~ python
    from jinja2 import Environment, PackageLoader
    config['pylons.app_globals'].jinja2_env = Environment(
       loader=PackageLoader('helloworld', 'templates')
    )
~~~

修改 helloworld/lib/base.py 模块 ，把 render_mako 改为 render_jinja2。

添加一个 hello.html 的文件到 templates 目录下，内容如下：

~~~ python
    the time is : {{ c.now }}
~~~

修改 controllers/hello.py 模板的内容如下：

~~~ python
    from datetime import datetime
    import logging

    from pylons import request, response, session, tmpl_context as c, url
    from pylons.controllers.util import abort, redirect

    from helloworld.lib.base import BaseController, render

    log = logging.getLogger(__name__)

    class HelloController(BaseController):

        def index(self):
            c.now = datetime.now()
            return render('/hello.html')
~~~

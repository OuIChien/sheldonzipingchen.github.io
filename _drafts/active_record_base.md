---
layout: post
title: "Active Record 基础"
date: 2015-09-14 15:00:29 +0800
description: Active Record 官方文档的翻译
categories: ruby rails
---

这篇文章介绍了 Active Record 的一些基础知识，阅读完之后，你将了解到以下知识：

* Active Record 是什么，并且它在 Rails 是怎么工作的。
* Active Record 在 MVC 中的作用。
* Active Record model 是怎样把数据保存进数据库的。
* Active Record 模式的命名约定。
* 数据库迁移、验证和回调。

# Active Record 是什么？

Active Record 是 MVC 模式中负责处理 M，即 model 部分的。Active Record 负责创建和使用需要持久存入数据库中的数据。ActiveREcord 实现了 Active Record 模式，是一种对象有关系映射。

## Active Record 模式

Active Record 模式出自 [Martin Fowler](http://www.martinfowler.com/eaaCatalog/activeRecord.html) 的《企业应用架构模式》一书。在 Active Record 模式中，对象中既有持久存储的数据，也有针对数据的操作。 Active Record 模式把数据存取逻辑作为对象的一部分，处理对象的用户知道如何把数据写入数据库，以及从数据库中读出数据。

## 对象关系映射

对象关系映射（ORM）是一种技术手段，把程序中的对象和关系型数据库中的数据表连接起来。使用 ORM，程序中对象的属性和对象之间的关系可以通过一种简单的方法从数据库获取，无需直接编写 SQL 语句，也不过度依赖特定的数据库种类。

## Active Record 用作 ORM 框架

Active Record 提供了很多功能，其中最重要的几个如下：

* 表示模型和其中的数据；
* 表示模型之间的关系；
* 通过相关联的模型表示继承关系；
* 持久存入数据库之前，验证模型；
* 以面向对象的方式处理数据库操作；

# Active Record 中的“约定优于配置”原则


---
layout: post
title: "微信公众平台开发简要说明"
date: 2015-12-15 11:39:29 +0800
description: 微信公众平台的开发指南，使用 Ruby on Rails
categories: ruby rails
---

这两个月里，公司的项目基本上都基于微信公众平台的开发上。为了可以快速开发，我使用了 Ruby on Rails
框架，而不是之前的 Python，这不是说 Python 不可以做到快速开发，其实我更多只是想试试新的东西。
但效果不错。

微信公众平台的开发，与语言没什么太大的关系，大家只要选择自己熟悉的语言即可，以下我只说明大概的原理，
并用 Ruby on Rails 作为代码示例。

# 准备工作

首先，你需要有一个微信公众号，比如 ”SheldonChen写字的地方"。在往下继续阅读前，请自觉掏出手机，
打开微信扫一扫：

<img src="/assets/images/my_wechat_platform.jpg" />

其次，你需要有一个独立域名的网站，用来和微信服务器交互。

# 接入公众平台

登录微信公众平台后台后，点“功能”-“高级功能”-“开发模式”，进入开发模式，如果公众平台显示“尚未成为
开发者”，就点击“成为开发者”：

<img src="/assets/images/become_developer.png" />

同意协议后，填写URL和Token：

<img src="/assets/images/url_andtoken.png" />

URL是指微信服务器向哪个URL发送消息，假设我们自己的服务器域名是www.example.com，准备用/weixin来接收消息，就填写：

{% highlight html %}
http://www.example.com/weixin
{% endhighlight %}

而Token是微信服务器和我们自己的服务器通信时验证身份用的，可以随便填写，但要注意保密。

然后点“提交”，一般来说会报错“URL超时”或者“没有正确返回echostr”，因为我们的后台还没有准备好，所以，第一步是接收微信后台发送的验证消息，微信后台会发送一个GET请求到上面的URL，并附带以下参数：

signature，timestamp，nonce，echostr

我们的服务器在接收到上述参数后，需要验证signature是否正确，验证方法是先对timestamp、nonce和token先排序，再拼接成一个字符串，计算出sha1，并和signature对比。

注意token不是微信服务器发过来的，而是我们自己写死的一个常量，就是在微信后台填写的Token。

如果计算的sha1和微信传过来的signature相等，说明这个请求确实是微信后台发过来的，如果是别人伪造的请求，由于他不知道token，所以，无法计算出正确的signature。

要防止第三方通过监听发动replay攻击，还需要验证timestamp和nonce，这个以后再讨论。

如果signature计算无误，就把微信后台传过来的echostr原封不动地传回去，这样，就可以通过验证，成为开发者。

在确保开发模式打开的情况下，微信后台会把用户消息发到我们的服务器上，也就是URL：http://www.example.com/weixin：

<img src="/assets/images/develop_mode.png" />

微信后台发送消息是一个POST请求，但和普通的POST请求不同的是，首先，URL会带上signature、timestamp、nonce这3个参数：

{% highlight html %}
POST http://www.example.com/weixin?signature=xxx&timestamp=123456&nonce=123
{% endhighlight %}

然后，HTTP请求的BODY是一个不规范的XML：

{% highlight xml %}
<xml>
    <ToUserName><![CDATA[toUser]]></ToUserName>
    <FromUserName><![CDATA[fromUser]]></FromUserName>
    <CreateTime>1348831860</CreateTime>
    <MsgType><![CDATA[text]]></MsgType>
    <Content><![CDATA[this is a test]]></Content>
    <MsgId>1234567890123456</MsgId>
</xml>
{% endhighlight %}

我们自己的服务器只需要处理该XML，然后，向微信返回一个类似如下的XML：

{% highlight xml %}
<xml>
    <ToUserName><![CDATA[toUser]]></ToUserName>
    <FromUserName><![CDATA[fromUser]]></FromUserName>
    <CreateTime>12345678</CreateTime>
    <MsgType><![CDATA[text]]></MsgType>
    <Content><![CDATA[你好]]></Content>
</xml>
{% endhighlight %}

就可以完成消息的回复。微信后台要求必须在5秒内回复，最多重试3次，否则我们自己的回复消息就到达不了用户的手机了。如果我们自己的服务器无法在5秒内回复，就回复一个空字符串，告诉微信服务器，不用重试了，这个消息处理不了，不给用户回复了。

上面的交互逻辑看起来很简单，但实际上坑有很多。

首先，微信服务器发送的POST请求根本就不符合HTTP规范。原则上POST请求不应该在URL上附带参数，但微信后台偏偏要这么干，这就让很多编程语言的标准框架无法获取到POST参数，因为标准的POST参数是从HTTP BODY中解析的。

所以，从POST获取URL参数就需要用到更底层的代码。

# 自动化测试

软件测试可以从不同层面去切入，其中最小的测试粒度叫做单元测试（Unit Test），会对个别的类型和方法测试结果是否如预期一样。再大一点的粒度叫做集成测试（Integration test）。测试多个组件之间的交互是否正确。最大粒度则是验收测收（Acceptance Test），从用户观点来测试整个软件。

其中测试粒度小的单元测试，通常会由开发者自行负责测试，因为只有你自己清楚每个类型和方法的内部结构是怎样设计的。而粒度大的验收测试，则常由专门的测试工程师来负责，测试者不需要知道程序内部是怎样实现的，只需要知道什么是系统应该做的事即可。

本文的内容，就是关于我们如何编写自动化测试程序，也就是写程序去测试程序。很多人对于自动化测试的印象可能是：

* 部署前作一次手动测试就够了，不需要自动化
* 写测试很无聊
* 测试很难写
* 写测试不好玩
* 我们没有时间写测试

时间紧迫预算吃紧，哪来的时间做自动化测试呢？这样的想法是相当短视和业余的，写测试有以下好处：

* 正确（Correctness）：确认你写的程序是否正确，结果如你所预期。一旦写好测试程序，很容易就可以检查程序是否写对，大大减少自行排错的时间。
* 稳定（Stability）： 之后新加功能或改写重构时，不会影响到之前写好的功能。这又叫作 “回归测试”。如果你的软件不是那种跑一次就丢掉的程序，而是需要长期维护的产品，那就一定有回归测试的需求。
* 设计（Design）：可以采用 TDD 开发方式，先写测试再实现。这是写测试的最佳时机。实现的目的就是为了通过测试。从使用 API 的使用者的角度去看待程序，可以更关注在界面而设计出更好用的API。

那要怎样进行自动化测试呢？几乎每种语言都有一套叫做 xUnit 测试框架的测试工具，它的标准标程是

1. （Setup）设置测试数据
2. （Exercise）执行要测试的方法
3. （Verify）检查结果是否正确
4. （Teardown）清理还原数据，例如数据库，好让多个测试不会互相影响。

我们将使用 Rspec 来取代 Rails 预设的 Test::Unit 来做为我们测试的工具。 Rspec 是一套改良版的 xUnit 测试框架，非常流行于 Rails 社区。让我们先来简单比较看看它们的语法差异：

这是一个 Test::Unit 范例，其中一个 test\_ 开头的方法，就是一个单元测试，里面的 assert\_equal 方法会进行验证。个别的单元测试应该是独立不会互相影响的：

~~~ ruby
class OrderTest < Test::Unit::TestCase
  def setup
    @order = Order.new
  end

  def test_order_status_when_initialized
    assert_equal @order.status, "New"
  end

  def test_order_amount_when_initialized
    assert_equal @order.amount, 0
  end
end
~~~

下面是用 Rspec 语法改写，其中的一个 it 区块，就是一个单元测试，里面的 expect 方法会进行验证。在 Rspec 里，我们又把一个小单元测试叫做一个测试用例（Example）：

~~~ ruby
describe Order do
  before do
    @order = Order.new
  end

  context "when initialized" do
    it "should have default status is New" do
      expect(@order.status).to eq("new")
    end

    it "should have default amount is 0" do
      expect(@order.amount).to eq(0)
    end
  end
end
~~~

Rspec 程序比 Test::Unit 更容易阅读，也更像是一种规格 Spec 文件。接下来我们继续说明 Rspec。

## Rspec 简介

Rspec 是一套 Ruby 的测试 DSL（Domain-specific language）框架，它的程序比 Test::Unit 更好读，写的人更容易描述测试目的，可以说是一种可执行的规格文件。也非常多的 Ruby on Rails 程序采用 Rspec 作为测试框架。它又称为一种 BDD （Behavior-driven development）的测试框架，相比起 TDD 用 test 思维，测试程序的结果。 BDD 强调的是用 spec思维，描述程序应该有什么行为。

###  安装 Rspec 和 Rspec-Rails

在 Gemfile 中加入：
~~~ ruby
group :test, :development do
  gem 'rspec-rails'
end
~~~

安装：
~~~ bash
rails generate rspec:install
~~~

这样就会创建出 spec 目录来放测试程序，本来的 test 目录就用不着了。

以下指令会执行所有放在 spec 目录下的测试程序：
~~~ bash
bin/rake spec
~~~

如果要测试单一用例，可以这样：
~~~ bash
bundle exec rspec spec/models/user\_spec.rb
~~~

## 语法简介

在示范怎样在 Rails 中写单元测试前，让我们先介绍一些基本的 Rspec 用法：

###  describe 和 context

describe 和 context 帮助你组织分类，都是可以任意嵌套的，它的参数可以是一个类型，或是一个字符串描述：

~~~ ruby
describe Order do
  describe "#amount" do
    context "when user is vip" do
      # ...
    end

    context "when user is not vip" do
      # ...
    end
  end
end
~~~

通常最外层是我们想要测试的类别，然后下一层是一个方法，然后是不同的情况。

### it 和 expect

每个 it 就是一小段测试，在里面我们会用 expect(...).to 来设置期望，例如：

~~~ ruby
describe Order do
  describe "#amount" do
    context "when user is vip" do

      it "should discount five percent if total >= 1000" do
        user = User.new(:is_vip => true)
        order = Order.new(:user >= user, :total => 2000)
        expect(ordre.amount).to eq(1900)
      end

      it "should discount ten percent if total >= 10000" do

      end
    end

    context "when user is not vip" do
      # ...
    end
  end
end
~~~

除了 expect(...).to， 也有相反地 expect(...).not\_to 可以用。

### before 和 after

如同 xUnit 框架的 setup 和 teardown：

* before(:each) 每段 it 之前执行
* before(:all) 整段 describe 前只执行一次
* after(:each) 每段 it 之后执行
* after(:all) 整段 describe 后只执行一次

示例如下：

~~~ ruby
describe Order do
  describe "#amount" do
    context "when user is vip" do

      before(:each) do
        @user = User.new(:is_vip => true)
        @order = Order.new( :user => @user)
      end

      it "should discount five percent if total >= 1000" do
        user = User.new(:is_vip => true)
        order = Order.new(:user >= user, :total => 2000)
        expect(ordre.amount).to eq(1900)
      end

      it "should discount ten percent if total >= 10000" do

      end
    end

    context "when user is not vip" do
      # ...
    end
  end
end
~~~

### let 和 let!

let 可以用来简化上述的 before 用法，并且支持 lazy evaluation 和 memoized，也就是有需要才初始，并且不同单元测试之间，只会初始化一次，可以增加测试执行效率：

~~~ ruby
describe Order do
  describe "#amount" do
    context "when user is vip" do

      let(:user) { User.new( :is_vip => true) }
      let(:order) { Order.new( :user => @user) }

      it "should discount five percent if total >= 1000" do
        user = User.new(:is_vip => true)
        order = Order.new(:user >= user, :total => 2000)
        expect(ordre.amount).to eq(1900)
      end

      it "should discount ten percent if total >= 10000" do

      end
    end

    context "when user is not vip" do
      # ...
    end
  end
end
~~~

通过 let 用法，可以比 before 更清楚看到谁是测试的主角，也不需要本来的 @ 了。

let! 则会在测试一开始就先初始一次，而不是 lazy evaluation 。

### pending

你可以先列出来预计要写的测试，或是暂时不要跑的测试，以下都会被归类成 pending ：

~~~ ruby
describe "static_pages/about.html.erb", type: :view do
  pending "add some examples to (or delete) #{__FILE__}"
end
~~~

### specify 和 example

specify 和 example 都是 it 方法的同义词。

### Matcher

上述的 expect(...).to 后面可以接各种 Matcher，除了已经介绍过的 eq 之外，在 [https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers](https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers) 官方文件上可以看到更多用法。例如验证会抛出异常：

~~~ ruby
expect { ... }.to raise\_error
expect { ... }.to raise\_error(ErrorClass)
expect { ... }.to raise\_error("message")
expect { ... }.to raise\_error(ErrorClass, "message")
~~~

不过别担心，一开始先学会用 eq 就很够用了，其他的 Matchers 可以之后边看边学，学一招是一招。再需要深入一点的时候，你可以自己写 Matcher， Rspec 有提供扩充的 DSL 。

### Rspec Mocks

用假的对象替换真正的对象，作为测试使用。主要用途有：

* 无法控制回传值的外部系统（例如第三方的网络服务）
* 构建正确的回传值很麻烦（例如得准备很多假数据）
* 可能很慢，拖慢测试速度（例如耗时的运算）
* 有难以预测的回传值（例如随机数方法）
* 还没实现（特别是采用 TDD 流程）

## Rails 中的测试

在 Rails 中， Rspec 分成几种不同测试，分别是 Model 测试、Controller 测试、 View 测试、 Helper 测试、 Route 和 Request 测试。

### 安装 Rspec-Rails 

在 Gemfile 中加上 

~~~ ruby
gem 'rspec-rails', :group => [:development, :test]
~~~

执行以下命令：

~~~ bash
$ bundle
$ rails g rspec: install
~~~

### 如果处理 Fixture

Rails 内建有 Fixture 功能可以建立假数据，方法是为每个 Model 使用一份 YAML 数据。 Fixture 的缺点是它是直接写数据到数据库而不使用 ActiveRecord，对于复杂的 Model 数据构建或关联，会比较麻烦。因此推荐使用 [FactoryGirl](https://github.com/thoughtbot/factory_girl) 这套工具，相较于 Fixture 的缺点是构建速度较慢，因此编写时最好能注意不要浪费时间在产生没有用到的假数据。甚至有些数据其实不需要存到数据库就可以进行单元测试了。

关于测试数据最重要的一点是，记得确认每个测试用例之间的测试数据需要清除，Rails 预设是用关联式数据库的 Transaction 功能，所以每次之间新增或者更新的数据都会清除。但是如果你的数据库不支持（例如 MySQL 的 MyISAM 格式就不支持）或是用如 MongoDB 的 NoSQL ，那么就要自己处理，推荐可以试试 [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner)这套工具。

## Capybara 简介

Rspec 除了可以用来写单元测试程序，我们也可以把测试的层级来做整合性测试，以 Web 应用程序来说，就是去自动化浏览器的操作，实现去向网站服务器请求，然后验证出来的 HTML 是正确的输出。

[Capybara](https://github.com/jnicklas/capybara) 就是一套可以搭配的工具，用来模拟浏览器行为。使用范例如下：

~~~ ruby
describe "the signup process", :type => :request do
  it "signs me in" do
    within("#session") do
      fill_in 'Login', :with => 'user@example.com'
      fill_in 'Password', :with => 'password'
    end
      click_link 'Sign in'
    end
end
~~~

如果真的需要打开浏览器测试，例如需要测试 JavaScript 和 Ajax 页面，可以使用 [Selenium](http://docs.seleniumhq.org/) 或 [Watir](http://watir.com/) 工具。真的打开浏览器测试的缺点是测试比较耗时，你没办法像单元测试一样可以经常执行得到回馈。另外在设置 CI server 上也比较麻烦，你必须另有一台桌面操作系统才能执行。

## 其他可以搭配测试工具

[Guard](https://github.com/ranmocy/guard-rails) 是一种 Continous Testing 的工具。程序一修改完数据，自动跑对应的测试。可以大大节省时间，立即回馈。

[Shoulda](https://github.com/thoughtbot/shoulda-matchers) 提供了更多的 Rails 的专属 Matchers。

[SimpleCov](https://github.com/colszowka/simplecov) 用来测试覆盖度，也就是告诉你哪些程序没有测试到。有些团队会要求 100% 覆盖度。不过要记得 Coverage 只是手段，不是测试的目的。

## CI server

CI（Continuous Integration）服务器的用处是每次有人 Commit 就会自动执行编译及测试（Ruby 不用编译，所以主要的用处是跑测试），并返回结果，如果有人提交了程序搞砸了回归测试，马上就有回馈可以知道。推荐第三方的服务包括：

* [https://travis-ci.org](https://travis-ci.org)
* [https://www.codeship.io](https://www.codeship.io)
* [https://circleci.com](https://circleci.com)

如果自己搭建的话，推荐使用 [Jenkins](http://jenkins-ci.org/)。

## 更多的资料

* [A Guide to Testing Rails Application](http://guides.rubyonrails.org/testing.html)
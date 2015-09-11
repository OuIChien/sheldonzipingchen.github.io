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


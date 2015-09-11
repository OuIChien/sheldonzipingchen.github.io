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

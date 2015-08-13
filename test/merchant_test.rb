require_relative 'test_helper'

class MerchantTest < Minitest::Test
  attr_reader :merchant_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @merchant_repo = engine.merchant_repository
  end

  def test_it_has_attributes
    marchant = merchant_repo.find_by_id(84)

    assert_equal 84, merchant.id
    assert_equal "Terry-Moore", merchant.name
    assert_equal "2012-03-27 14:54:07 UTC", merchant.created_at
    assert_equal "2012-03-27 14:54:07 UTC", merchant.updated_at
  end

  def test_it_returns_an_array_of_items
    merchant = merchant_repo.find_by_id(11)

    assert_equal Array, merchant.items.class
    assert merchant.items.all?{|item| item.class == Item}
  end

  def test_it_returns_the_correct_items
    merchant = merchant_repo.find_by_id(11)
    item_ids = merchant.items.map {|item| item.attributes["id"]}
    unit_prices = merchant.items.map {|item| item.attributes["unit_price"]}

    assert_equal [207, 208, 209], item_ids
    assert_equal [32427, 48543, 23092], unit_prices
  end

  def test_it_returns_an_array_of_invoices
    merchant = merchant_repo.find_by_id(50)

    assert_equal Array, merchant.invoices.class
    assert merchant.invoices.all?{|invoice| invoice.class == Invoice}
  end

  def test_it_returns_the_correct_invoices
    merchant = merchant_repo.find_by_id(77)
    invoice_ids = merchant.invoices.map {|invoice| invoice.attributes["id"]}
    customer_ids = merchant.invoices.map do |invoice|
      invoice.attributes["customer_id"]
    end

    expected_invoice_ids = [
                            146, 178, 406, 508, 763, 1106, 1137, 1214, 1219,
                            1595, 1896, 2095, 2106, 2181, 2207, 2335, 2511,
                            2652, 2783, 2812, 2990, 3141, 3146, 3480, 3570,
                            3573, 3653, 3760, 4020, 4025, 4308, 4331, 4400,
                            4524, 4529, 4573, 4610, 4693, 4803, 4815, 4827
                           ]
    expected_customer_ids = [
                             28, 37, 84, 107, 149, 212, 218, 236, 237, 307,
                             372, 415, 416, 432, 437, 469, 510, 532, 556, 560,
                             601, 627, 630, 712, 725, 727, 744, 770, 815, 816,
                             877, 883, 897, 923, 923, 936, 948, 968, 992, 993,
                             996
                            ]

    assert_equal expected_invoice_ids, invoice_ids
    assert_equal expected_customer_ids, customer_ids
  end

  def test_it_finds_total_revenue
    merchant = merchant_repo.find_by_id(4)

    expected = BigDecimal.new("10930155")

    assert_equal expected, merchant.total_revenue
  end

  def test_it_finds_total_items_sold
    merchant = merchant_repo.find_by_id(33)

    expected = BigDecimal.new("298")

    assert_equal expected, merchant.total_items_sold
  end

  def test_it_finds_revenue_by_date
    date = Date.parse("2012-03-27")
    merchant = merchant_repo.find_by_id(4)

    expected = BigDecimal.new('1291.44')

    assert_equal expected, merchant.revenue_on_date(date)
  end

  def test_it_finds_favorite_customer
    merchant = engine.merchant_repository.find_by(:id, 7)

    expected = "Wilfred Emmerich"

    assert_equal expected, merchant.favorite_customer.name
  end

  def test_it_finds_customers_with_pending_invoices
    merchant = merchant_repo.find_by_id(34)

    expected = {"3"=>"Mariah Toy", "169"=>"Valentine Lang", "184"=>"Cyril Kilback"}

    assert_equal expected, merchant.customers_with_pending_invoices
  end

end

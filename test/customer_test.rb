require_relative 'test_helper'

class CustomerTest < Minitest::Test
  attr_reader :customer_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @customer_repo = engine.customer_repository
  end

  def test_it_has_attributes
    customer = customer_repo.find_by_id(3)

    assert_equal 3, customer.id
    assert_equal "Mariah", customer.first_name
    assert_equal "Toy", customer.last_name
    assert_equal "2012-03-27 14:54:10 UTC", customer.created_at
    assert_equal "2012-03-27 14:54:10 UTC", customer.updated_at
  end

  def test_it_returns_an_array_of_invoices
    customer = customer_repo.find_by_id(999)

    assert_equal Array, customer.invoices.class
    assert customer.invoices.all?{|invoice| invoice.class == Invoice}
  end

  def test_it_returns_the_correct_invoices
    customer = customer_repo.find_by_id(21)
    invoice_ids = customer.invoices.map {|invoice| invoice.attributes["id"]}
    merchant_ids = customer.invoices.map do |invoice|
      invoice.attributes["merchant_id"]
    end

    assert_equal [109, 110, 111, 112, 113, 114, 115, 116], invoice_ids
    assert_equal [96, 45, 72, 71, 18, 44, 87, 80], merchant_ids
  end

  def test_it_finds_all_transactions_by_the_customer
    customer = customer_repo.find_by_id(25)

    expected = [146, 147, 148, 149, 150, 151]

    assert_equal expected, customer.transaction_ids
  end

  def test_it_finds_customers_favorite_merchant
    customer = customer_repo.find_by_id(16)

    expected = "Jewess Group"

    assert_equal expected, customer.favorite_merchant
  end

  def test_it_knows_own_type_by_default
    customer = engine.customer_repository.find_by(:id, "16")

    assert_equal :customer, customer.type_name
  end
end

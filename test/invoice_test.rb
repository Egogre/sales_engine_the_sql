require_relative 'test_helper'

class InvoiceTest < Minitest::Test
  attr_reader :invoice_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @invoice_repo = engine.invoice_repository
  end

  def test_it_gets_an_array_of_transactions
    invoice = Invoice.new(invoice_repo.find_by_id(11), db)

    assert_equal Array, invoice.transactions.class
    assert invoice.transactions.all? do |transaction|
      transaction.class == Transaction
    end
  end

  def test_it_gets_the_correct_transactions
    invoice = Invoice.new(invoice_repo.find_by_id(12), db)
    transaction_ids = invoice.transactions.map do |transaction|
      transaction.attributes["id"]
    end
    cc_numbers = invoice.transactions.map do |transaction|
      transaction.attributes["credit_card_number"]
    end

    assert_equal [11, 12, 13], transaction_ids
  	assert_equal [4800749911485986,
                  4017503416578382,
                  4536896898764278], cc_numbers
  end

  def test_it_gets_an_array_of_invoice_items
    invoice = Invoice.new(invoice_repo.find_by_id(12), db)

    assert_equal Array, invoice.invoice_items.class
    assert invoice.invoice_items.all?{|invoice_item| invoice_item.class == InvoiceItem}
  end

  def test_it_gets_the_correct_invoice_items
    invoice = Invoice.new(invoice_repo.find_by_id(12), db)
    invoice_item_ids = invoice.invoice_items.map do |invoice_item|
      invoice_item.attributes["id"]
    end
    item_prices = invoice.invoice_items.map do |invoice_item|
      invoice_item.attributes["unit_price"]
    end

    assert_equal [56, 57, 58, 59, 60, 61], invoice_item_ids
    assert_equal [78031, 41702, 71340, 7196, 41702, 22546], item_prices
  end

  def test_it_gets_an_array_of_items
    invoice = Invoice.new(invoice_repo.find_by_id(34), db)

    assert_equal Array, invoice.items.class
    assert invoice.items.all?{|item| item.class == Item}
  end

  def test_it_gets_the_correct_items
    invoice = Invoice.new(invoice_repo.find_by_id(12), db)
    item_ids = invoice.items.map {|item| item.attributes["id"]}
    item_prices = invoice.items.map {|item| item.attributes["unit_price"]}

    assert_equal [127, 134, 150, 156, 160], item_ids
    assert_equal [41702, 22546, 78031, 71340, 7196], item_prices
  end

  def test_it_can_pull_a_customer
    invoice = Invoice.new(invoice_repo.find_by_id(97), db)

    assert_equal Customer, invoice.customer.class
  end

  def test_it_pulls_the_correct_customer
    invoice = Invoice.new(invoice_repo.find_by_id(67), db)

    assert_equal "Katrina", invoice.customer.attributes["first_name"]
  end

  def test_it_can_pull_a_merchant
    invoice = Invoice.new(invoice_repo.find_by_id(103), db)

    assert_equal Merchant, invoice.merchant.class
  end

  def test_merchant__it_pulls_the_correct_merchant
    invoice = Invoice.new(invoice_repo.find_by_id(22), db)

    result = invoice.merchant.attributes["name"]

    assert_equal "Pacocha-Mayer", result
  end

  def test_it_knows_type_name
    invoice = Invoice.new(invoice_repo.find_by_id(1), db)

    assert_equal :invoice, invoice.type_name
  end
end

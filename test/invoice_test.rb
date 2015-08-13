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
    invoice = invoice_repo.find_by_id(11)

    assert_equal Array, invoice.transactions.class
    assert invoice.transactions.all? do |transaction|
      transaction.class == Transaction
    end
  end

  def test_it_gets_the_correct_transactions
    invoice = invoice_repo.find_by_id(12)
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
    invoice = invoice_repo.find_by_id(12)

    assert_equal Array, invoice.invoice_items.class
    assert invoice.invoice_items.all?{|invoice_item| invoice_item.class == InvoiceItem}
  end

  def test_it_gets_the_correct_invoice_items
    invoice = invoice_repo.find_by_id(12)
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
    invoice = invoice_repo.find_by_id(34)

    assert_equal Array, invoice.items.class
    assert invoice.items.all?{|item| item.class == Item}
  end

  def test_it_gets_the_correct_items
    invoice = invoice_repo.find_by_id(12)
    item_ids = invoice.items.map {|item| item.attributes["id"]}
    item_prices = invoice.items.map {|item| item.attributes["unit_price"]}

    assert_equal [127, 134, 150, 156, 160], item_ids
    assert_equal [41702, 22546, 78031, 71340, 7196], item_prices
  end

  def test_it_can_pull_a_customer
    invoice = invoice_repo.find_by_id(97)

    assert_equal Customer, invoice.customer.class
  end

  def test_it_pulls_the_correct_customer
    invoice = invoice_repo.find_by_id(67)

    assert_equal "Katrina", invoice.customer.attributes["first_name"]
  end

  def test_it_can_pull_a_merchant
    invoice = invoice_repo.find_by_id(103)

    assert_equal Merchant, invoice.merchant.class
  end

  def test_merchant__it_pulls_the_correct_merchant
    invoice = invoice_repo.find_by_id(22)

    result = invoice.merchant.attributes["name"]

    assert_equal "Pacocha-Mayer", result
  end

  def test_it_knows_type_name
    invoice = invoice_repo.find_by_id(1)

    assert_equal :invoice, invoice.type_name
  end

  def test_it_charges_card_for_transaction
    invoice = engine.invoice_repository.find_by_id(3)
    prior_transaction_count = invoice.transactions.count

    invoice.charge(credit_card_number: '1111222233334444',
                   credit_card_expiration_date: "10/14",
                   result: "success")

    invoice = engine.invoice_repository.find_by_id(invoice.id)
    assert_equal invoice.transactions.count, prior_transaction_count.next
  end
end

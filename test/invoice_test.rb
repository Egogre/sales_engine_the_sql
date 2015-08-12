require_relative 'test_helper'

class InvoiceTest < Minitest::Test

  @@engine = SalesEngine.new
  @@engine.startup

  def engine
    @@engine
  end

  def test_transactions__it_gets_an_array_of_them
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal Array, invoice.transactions.class
    assert invoice.transactions.all?{|transaction| transaction.class == Transaction}
  end

  def test_transactions__it_gets_the_correct_ones
    invoice = engine.invoice_repository.find_by(:id, "12")
    transaction_ids = invoice.transactions.map {|transaction| transaction.id}
    cc_numbers = invoice.transactions.map {|transaction| transaction.credit_card_number}

    assert_equal ['11', '12', '13'], transaction_ids
  	assert_equal ['4800749911485986', '4017503416578382', '4536896898764278'], cc_numbers
  end

  def test_transactions__it_returns_an_empty_array_when_no_transactions_are_associated_with_the_invoice
    invoice = engine.invoice_repository.find_by(:id, "999")

    assert_equal [], invoice.transactions
  end

  def test_invoice_items__it_gets_an_array_of_them
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal Array, invoice.invoice_items.class
    assert invoice.invoice_items.all?{|invoice_item| invoice_item.class == InvoiceItem}
  end

  def test_invoice_items__it_gets_the_correct_ones
    invoice = engine.invoice_repository.find_by(:id, "12")
    invoice_item_ids = invoice.invoice_items.map {|invoice_item| invoice_item.id}
    item_prices = invoice.invoice_items.map {|invoice_item| invoice_item.unit_price}

    assert_equal ['56', '57', '58', '59', '60', '61'], invoice_item_ids
    assert_equal ['78031', '41702', '71340', '7196', '41702', '22546'], item_prices
  end

  def test_invoice_items__it_returns_an_empty_array_when_no_invoice_items_are_associated_with_the_invoice
    invoice = engine.invoice_repository.find_by(:id, "999")

    assert_equal [], invoice.invoice_items
  end

  def test_items__it_gets_an_array_of_items
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal Array, invoice.items.class
    assert invoice.items.all?{|item| item.class == Item}

  end

  def test_items__it_gets_the_correct_items
    invoice = engine.invoice_repository.find_by(:id, "12")
    item_ids = invoice.items.map {|item| item.id}
    item_prices = invoice.items.map {|item| item.unit_price}

    assert_equal ['150', '127', '156', '160', '134'], item_ids
    assert_equal ['78031', '41702', '71340', '7196', '22546'], item_prices
  end

  def test_items__it_returns_an_empty_array_when_no_items_are_associated_with_the_invoice
    invoice = engine.invoice_repository.find_by(:id, "999")

    assert_equal [], invoice.items
  end

  def test_customer__it_can_pull_a_customer
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal Customer, invoice.customer.class
  end

  def test_customer__it_pulls_the_correct_customer
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal "Mariah", invoice.customer.first_name
  end

  def test_merchant__it_can_pull_a_merchant
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal Merchant, invoice.merchant.class
  end

  def test_merchant__it_pulls_the_correct_merchant
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal "Osinski, Pollich and Koelpin", invoice.merchant.name
  end

  def test_it_knows_type_name
    invoice = engine.invoice_repository.find_by(:id, "12")

    assert_equal :invoice, invoice.type_name
  end
end

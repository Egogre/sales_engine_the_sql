gem 'minitest', '~> 5.7.0'
require 'minitest/autorun'
require 'minitest/pride'
require_relative 'test_helper'

class InvoiceItemTest < Minitest::Test

  @@engine = SalesEngine.new
  @@engine.startup

  def engine
    @@engine
  end

  def test_it_can_pull_an_invoice
    invoice_item = engine.invoice_item_repository.find_by(:id, "13")

    assert_equal Invoice, invoice_item.invoice.class
  end

  def test_it_pulls_the_correct_invoice
    invoice_item = engine.invoice_item_repository.find_by(:id, "13")

    assert_equal '3', invoice_item.invoice.id
  	assert_equal '78', invoice_item.invoice.merchant_id
  end

    def test_it_returns_nil_when_invoice_is_not_found
      invoice_item = engine.invoice_item_repository.find_by(:id, "4521")

      assert_nil invoice_item.invoice
    end

  def test_it_can_pull_an_item
    invoice_item = engine.invoice_item_repository.find_by(:id, "8")

    assert_equal Item, invoice_item.item.class
  end

  def test_it_pulls_the_correct_item
    invoice_item = engine.invoice_item_repository.find_by(:id, "8")

    assert_equal '534', invoice_item.item.id
    assert_equal '76941', invoice_item.item.unit_price
  end

  def test_it_returns_nil_when_item_is_not_found
    invoice_item = engine.invoice_item_repository.find_by(:id, "13")

    assert_nil invoice_item.item
  end

  def test_it_knows_type_name
    invoice_item = engine.invoice_item_repository.find_by(:id, "13")

    assert_equal :invoice_item, invoice_item.type_name
  end
end

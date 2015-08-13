require_relative 'test_helper'

class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @invoice_item_repo = engine.invoice_item_repository
  end

  def test_it_can_pull_an_invoice
    invoice_item = invoice_item_repo.find_by_id(11)

    assert_equal Invoice, invoice_item.invoice.class
  end

  def test_it_pulls_the_correct_invoice
    invoice_item = invoice_item_repo.find_by_id(13)

    assert_equal 3, invoice_item.invoice.attributes["id"]
  	assert_equal 78, invoice_item.invoice.attributes["merchant_id"]
  end

  # def test_it_can_pull_an_item
  #   invoice_item = engine.invoice_item_repository.find_by(:id, "8")
  #
  #   assert_equal Item, invoice_item.item.class
  # end
  #
  # def test_it_pulls_the_correct_item
  #   invoice_item = engine.invoice_item_repository.find_by(:id, "8")
  #
  #   assert_equal '534', invoice_item.item.id
  #   assert_equal '76941', invoice_item.item.unit_price
  # end
  #
  # def test_it_returns_nil_when_item_is_not_found
  #   invoice_item = engine.invoice_item_repository.find_by(:id, "13")
  #
  #   assert_nil invoice_item.item
  # end
  #
  # def test_it_knows_type_name
  #   invoice_item = engine.invoice_item_repository.find_by(:id, "13")
  #
  #   assert_equal :invoice_item, invoice_item.type_name
  # end
end

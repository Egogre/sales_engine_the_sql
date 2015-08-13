require_relative 'test_helper'

class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @invoice_item_repo = engine.invoice_item_repository
  end

  def test_it_has_attributes
    invoice_item = invoice_item_repo.find_by_id(7)

    assert_equal 7, invoice_item.id
    assert_equal 530, invoice_item.item_id
    assert_equal 1, invoice_item.invoice_id
    assert_equal 4, invoice_item.unit_price
    assert_equal 66747, invoice_item.invoice_id
    assert_equal "2012-03-27 14:54:09 UTC", invoice_item.created_at
    assert_equal "2012-03-27 14:54:09 UTC", invoice_item.updated_at
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

  def test_it_can_pull_an_item
    invoice_item = engine.invoice_item_repository.find_by(:id, 8)

    assert_equal Item, invoice_item.item.class
  end

  def test_it_pulls_the_correct_item
    invoice_item = engine.invoice_item_repository.find_by(:id, 8)

    assert_equal 534, invoice_item.item.id
    assert_equal 76941, invoice_item.item.unit_price
  end

end

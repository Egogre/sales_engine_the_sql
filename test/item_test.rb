require_relative 'test_helper'

class ItemTest < Minitest::Test
  attr_reader :item_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @item_repo = engine.item_repository
  end

  def test_it_has_attributes
    item = item_repo.find_by_id(61)

    assert_equal 61, item.id
    assert_equal "Item Quas Maiores", item.name
    assert_equal 141, item.description.length
    assert_equal 26172, item.unit_price
    assert_equal 3, item.merchant_id
    assert_equal "2012-03-27 14:53:59 UTC", item.created_at
    assert_equal "2012-03-27 14:53:59 UTC", item.updated_at
  end

  def test_it_returns_an_array_of_invoice_items
    item = item_repo.find_by_id(11)

    assert_equal Array, item.invoice_items.class
    assert item.invoice_items.all? do |invoice_item|
      invoice_item.class == InvoiceItem
    end
  end

  def test_invoice_items__it_returns_the_correct_invoice_items
    item = item_repo.find_by_id(127)
    invoice_item_ids = item.invoice_items.map do |invoice_item|
      invoice_item.attributes["id"]
    end
    quantities = item.invoice_items.map do |invoice_item|
      invoice_item.attributes["quantity"]
    end

    assert_equal [57, 60, 3856, 4585, 13495, 13497, 21229], invoice_item_ids
    assert_equal [2, 3, 7, 3, 9, 1, 4], quantities
  end

  def test_merchant__it_can_pull_a_merchant
    item = item_repo.find_by_id(9)

    assert_equal Merchant, item.merchant.class
  end

  def test_merchant__it_pulls_the_correct_merchant
    item = item_repo.find_by_id(302)

    assert_equal 18, item.merchant.attributes["id"]
    assert_equal "Koepp LLC", item.merchant.attributes["name"]
  end

  def test_it_knows_best_day_for_sales
    item = engine.item_repository.find_by(:id, 127)

    expected = Date.parse(2012-03-27)

    assert_equal expected, item.best_day
  end

end

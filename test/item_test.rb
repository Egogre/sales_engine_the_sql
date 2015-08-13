require_relative 'test_helper'

class ItemTest < Minitest::Test
  attr_reader :item_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @item_repo = engine.item_repository
  end

  def test_it_returns_an_array_of_invoice_items
    item = item_repo.find_by_id(11)

    assert_equal Array, item.invoice_items.class
    assert item.invoice_items.all?{|invoice_item| invoice_item.class == InvoiceItem}
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

  # def test_it_knows_best_day_for_sales
  #   item = engine.item_repository.find_by(:id, "127")
  #
  #   expected = "best day for Item Ut Illum sales is 2012-03-27 with 5 units sold"
  #
  #   assert_equal expected, item.best_day
  # end
  #
  # def test_it_knows_own_type_name
  #   item = engine.item_repository.find_by(:id, "127")
  #
  #   assert_equal :item, item.type_name
  # end
end

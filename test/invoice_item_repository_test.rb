require_relative 'test_helper'

class InvoiceItemRepositoryTest < Minitest::Test
attr_reader :invoice_item_repo

def setup
  engine = SalesEngine.new
  engine.startup
  @invoice_item_repo = engine.invoice_item_repository
end

  def test_it_exists
    assert invoice_item_repo
  end

  def test_all_returns_all_invoice_items
    assert_equal 21687, invoice_item_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << invoice_item_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

  def test_find_by_id
    invoice_item = invoice_item_repo.find_by_id(2)

    assert_equal 528, invoice_item[0]["item_id"]
  end

  def test_find_all_by_item_id
    assert_equal 17, invoice_item_repo.find_all_by_item_id(3).count
  end

  def test_find_all_by_invoice_id
    assert_equal 4, invoice_item_repo.find_all_by_invoice_id(5).count
  end

  def test_find_all_by_quantity
    invoice_item_array = invoice_item_repo.find_all_by_quantity(10)

    assert_equal 2140, invoice_item_array.count
  end

  def test_find_all_by_unit_price
    invoice_item_array = invoice_item_repo.find_all_by_unit_price(34873)

    assert_equal 10, invoice_item_array.count
  end

end

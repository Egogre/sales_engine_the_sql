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
    invoice_item1 = invoice_item_repo.find_by_id(2)
    invoice_item2 = invoice_item_repo.find_by_id(302)

    assert_equal 528, invoice_item1["item_id"]
    assert_equal 64747, invoice_item2["unit_price"]
  end

  def test_find_all_by_item_id
    assert_equal 17, invoice_item_repo.find_all_by_item_id(3).count
    assert_equal 35, invoice_item_repo.find_all_by_item_id(211).count
  end

  def test_find_all_by_invoice_id
    assert_equal 4, invoice_item_repo.find_all_by_invoice_id(5).count
    assert_equal 6, invoice_item_repo.find_all_by_invoice_id(103).count
  end

  def test_find_all_by_quantity
    invoice_item_array1 = invoice_item_repo.find_all_by_quantity(10)
    invoice_item_array2 = invoice_item_repo.find_all_by_quantity(4)

    assert_equal 2140, invoice_item_array1.count
    assert_equal 2231, invoice_item_array2.count
  end

  def test_find_all_by_unit_price
    invoice_item_array1 = invoice_item_repo.find_all_by_unit_price(34873)
    invoice_item_array2 = invoice_item_repo.find_all_by_unit_price(3590)

    assert_equal 10, invoice_item_array1.count
    assert_equal 111, invoice_item_array2.count
  end

end

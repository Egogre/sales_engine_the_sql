require_relative 'test_helper'

class InvoiceItemRepositoryTest < Minitest::Test
attr_reader :invoice_item_repo

  def setup
    csv_table = [{
                  :id => 1,
                  :item_id => 3,
                  :invoice_id => 5,
                  :quantity => 7,
                  :unit_price => 1500
                 },
                 {
                  :id => 2,
                  :item_id => 4,
                  :invoice_id => 5,
                  :quantity => 20,
                  :unit_price => 730
                 },
                 {
                  :id => 3,
                  :item_id => 13,
                  :invoice_id => 6,
                  :quantity => 10,
                  :unit_price => 4999
                 }]
    engine = "Pretend Engine"
    @invoice_item_repo = InvoiceItemRepository.new(csv_table, engine)
  end

  def test_it_exists
    assert invoice_item_repo
  end

  def test_it_converts_to_hash
    assert_kind_of Hash, invoice_item_repo.records
  end

  def test_all_returns_all_invoice_items
    assert_equal 3, invoice_item_repo.all.length
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

    assert_equal 4, invoice_item[:item_id]
  end

  def test_find_all_by_item_id
    invoice_item_repo.load_invoice_item_searches

    assert_equal 1, invoice_item_repo.find_all_by_item_id(3).count
  end

  def test_find_all_by_invoice_id
    invoice_item_repo.load_invoice_item_searches

    assert_equal 2, invoice_item_repo.find_all_by_invoice_id(5).count
  end

  def test_find_all_by_quantity
    invoice_item_repo.load_invoice_item_searches
    invoice_item_array = invoice_item_repo.find_all_by_quantity(20)

    assert_equal 2, invoice_item_array[0][:id]
  end

  def test_find_all_by_unit_price
    invoice_item_repo.load_invoice_item_searches
    invoice_item_array = invoice_item_repo.find_all_by_unit_price(4999)

    assert_equal 3, invoice_item_array[0][:id]
  end

end

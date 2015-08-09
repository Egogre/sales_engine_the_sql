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

end

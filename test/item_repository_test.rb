require_relative 'test_helper'

class ItemRepositoryTest < Minitest::Test
attr_reader :item_repo

  def setup
    csv_table = [{
                  :id => 1,
                  :name => "Toy",
                  :description => "Fun",
                  :unit_price => 5999,
                  :merchant_id => 3
                 },
                 {
                  :id => 2,
                  :name => "Book",
                  :description => "Interesting",
                  :unit_price => 1399,
                  :merchant_id => 1
                 },
                 {
                  :id => 3,
                  :name => "Mud",
                  :description => "Dirty",
                  :unit_price => 1,
                  :merchant_id => 2
                 }]
    engine = "Pretend Engine"
    @item_repo = ItemRepository.new(csv_table, engine)
  end

  def test_it_exists
    assert item_repo
  end

  def test_it_converts_to_hash
    assert_kind_of Hash, item_repo.records
  end

  def test_all_returns_all_items
    assert_equal 3, item_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << item_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

end

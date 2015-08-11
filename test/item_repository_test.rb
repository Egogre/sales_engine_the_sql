require_relative 'test_helper'

class ItemRepositoryTest < Minitest::Test
attr_reader :item_repo

def setup
  engine = SalesEngine.new
  engine.startup
  @item_repo = engine.item_repository
end

  def test_it_exists
    assert item_repo
  end

  def test_all_returns_all_items
    assert_equal 2483, item_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << item_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

  def test_find_by_id
    item = item_repo.find_by_id(196)

    assert_equal 9, item[0]["merchant_id"]
  end

  def test_find_by_name
    assert_equal 67076, item_repo.find_by_name("Item Autem Minima")[0]["unit_price"]
  end

  def test_find_by_description
    description = "Sunt officia eum qui molestiae. Nesciunt quidem cupiditate
                   reiciendis est commodi non. Atque eveniet sed. Illum
                   excepturi praesentium reiciendis voluptatibus eveniet odit
                   perspiciatis. Odio optio nisi rerum nihil ut."
    assert_equal 3, item_repo.find_by_description(description)[0]["id"]
  end

  def test_find_all_by_unit_price
    assert_equal 2, item_repo.find_all_by_unit_price(75107).count
  end

  def test_find_all_by_merchant_id
    assert_equal 9, item_repo.find_all_by_merchant_id(29).count
  end

end

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
    item1 = item_repo.find_by_id(196)
    item2 = item_repo.find_by_id(36)

    assert_equal 9, item1.merchant_id
    assert_equal "Item Omnis Molestiae", item2.name
  end

  def test_find_by_name
    result1 = item_repo.find_by_name("Item Autem Minima")
    result2 = item_repo.find_by_name("Item Aut Id")
    assert_equal 67076, result1.unit_price
    assert_equal 283, result2.id
  end

  def test_find_by_description
    part1 = "Sunt officia eum qui molestiae. Nesciunt quidem cupiditate "
    part2 = "reiciendis est commodi non. Atque eveniet sed. Illum excepturi "
    part3 = "praesentium reiciendis voluptatibus eveniet odit perspiciatis. "
    part4 = "Odio optio nisi rerum nihil ut."
    description = part1 + part2 +part3 + part4
    assert_equal 3, item_repo.find_by_description(description)[0].id
  end

  def test_find_all_by_unit_price
    assert_equal 2, item_repo.find_all_by_unit_price(75107).count
    assert_equal 1, item_repo.find_all_by_unit_price(18715).count
  end

  def test_find_all_by_merchant_id
    assert_equal 9, item_repo.find_all_by_merchant_id(29).count
    assert_equal 45, item_repo.find_all_by_merchant_id(86).count
  end

  def test_it_finds_items_with_most_revenue
    top_x_items = 3

    expected = "Item Delectus Saepe"

    assert_equal expected, repo.most_revenue(top_x_items)[2].name
  end

  def test_it_finds_most_sold_items
    top_x_items = 3

    expected = "Item Nam Magnam"

    assert_equal expected, repo.most_items(top_x_items)[1].name
  end

end

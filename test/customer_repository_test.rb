require_relative 'test_helper'

class CustomerRepositoryTest < Minitest::Test
attr_reader :customer_repo

  def setup
    engine = SalesEngine.new
    engine.startup
    @customer_repo = engine.customer_repository
  end

  def test_it_exists
    assert customer_repo
  end

  def test_all_returns_all_customers
    assert_equal 1000, customer_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << customer_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

  def test_find_by_id
    customer = customer_repo.find_by_id(2)

    assert_equal "Cecelia", customer[0]["first_name"]
  end

  def test_find_all_by_first_name_case_insensitive
    assert_equal 1, customer_repo.find_all_by_first_name("leanne").count
    assert_equal 1, customer_repo.find_all_by_first_name("Leanne").count
  end

  def test_find_all_by_last_name_case_insensitive
    assert_equal 3, customer_repo.find_all_by_last_name("nader").count
    assert_equal 3, customer_repo.find_all_by_last_name("Nader").count
  end

end

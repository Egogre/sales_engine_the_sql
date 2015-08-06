require_relative 'test_helper'

class CustomerRepositoryTest < Minitest::Test

  @@engine = SalesEngine.new
  @@engine.startup
  @@repo = @@engine.customer_repository

  def engine
    @@engine
  end

  def repo
    @@repo
  end

  def test_it_is_a_repository
    repo = CustomerRepository.new nil

    assert_kind_of Repository, repo
  end

  def test_it_is_created_by_engine
    assert_kind_of CustomerRepository, engine.customer_repository
  end

  def test_it_can_return_all_instances_as_array
    assert_kind_of Array, engine.customer_repository.all
  end

  def test_can_return_all_instances
    assert_equal 1000, engine.customer_repository.all.length
  end

  def test_can_return_random_instance
    instances = []
    100.times do
      instances << repo.random
    end

    refute instances.uniq.length == 1
  end

  def test_can_find_by_attribute
    assert_kind_of Customer, repo.find_by(:first_name, "Jeffrey")
  end

  def test_can_find_all_by_attribute
    assert_equal 3, repo.find_all_by(:last_name, "Wolf").length
  end

  def test_returns_empty_array_if_find_all_returns_nothing
    assert_equal [], repo.find_all_by(:last_name, "Casmir")
  end
end

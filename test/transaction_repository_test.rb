require_relative 'test_helper'

class TransactionRepositoryTest < Minitest::Test

  @@engine = SalesEngine.new
  @@engine.startup
  @@repo = @@engine.transaction_repository

  def engine
    @@engine
  end

  def repo
    @@repo
  end

  def test_it_is_a_repository
    assert_kind_of Repository, repo
  end

  def test_it_is_created_by_engine
    assert_kind_of TransactionRepository, engine.transaction_repository
  end

  def test_it_can_return_all_instances_as_array
    assert_kind_of Array, engine.transaction_repository.all
  end

  def test_can_return_all_instances
    assert_equal 1000, engine.transaction_repository.all.length
  end

  def test_can_return_random_instance
    instances = []
    100.times do
      instances << repo.random
    end

    refute instances.uniq.length == 1
  end

  def test_can_find_by_attribute
    assert_kind_of Transaction, repo.find_by(:invoice_id, 5)
  end

  def test_can_find_all_by_attribute
    assert_equal 823, repo.find_all_by(:result, "success").length
  end

  def test_returns_empty_array_if_find_all_returns_nothing
    assert_equal [], repo.find_all_by(:credit_card_number, "1234567812345678")
  end
end

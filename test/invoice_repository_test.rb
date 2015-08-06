require_relative 'test_helper'

class InvoiceRepositoryTest < Minitest::Test

  @@engine = SalesEngine.new
  @@engine.startup
  @@repo = @@engine.invoice_repository

  def engine
    @@engine
  end

  def repo
    @@repo
  end

  def test_is_a_repository
    assert_kind_of Repository, repo
  end

  def test_it_returns_all_instances_as_an_array
    assert_kind_of Array, repo.all
  end

  def test_it_can_return_all_instances
    assert_equal 1000, repo.all.length
  end

  def test_it_can_return_random_instance
    instances = []
    100.times do
      instances << repo.random
    end

    refute_equal 1, instances.uniq.length
  end

  def test_can_find_by_attribute
    assert_equal "10", repo.find_by(:merchant_id, 92).customer_id
  end

  def test_can_find_all_by_attribute
    assert_equal 10, repo.find_all_by(:customer_id, 20).length
  end

  def test_returns_empty_array_if_find_all_returns_nothing
    assert_equal [], repo.find_all_by(:id, "-5")
  end
end

require_relative 'test_helper'

class InvoiceItemRepositoryTest < Minitest::Test

  @@engine = SalesEngine.new
  @@engine.startup
  @@repo = @@engine.invoice_item_repository

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
    assert_kind_of InvoiceItemRepository, engine.invoice_item_repository
  end

  def test_it_can_return_all_instances_as_array
    assert_kind_of Array, engine.invoice_item_repository.all
  end

  def test_can_return_all_instances
    assert_equal 1001, engine.invoice_item_repository.all.length
  end

  def test_can_return_random_instance
    instances = []
    100.times do
      instances << repo.random
    end

    refute instances.uniq.length == 1
  end

  def test_can_find_by_invoice_id
    assert_kind_of InvoiceItem, repo.find_by(:invoice_id, 2)
  end

  def test_can_find_all_by_quantity
    assert_equal 82, repo.find_all_by(:quantity, 10).length
  end

  def test_returns_empty_array_if_find_all_returns_nothing
    assert_equal [], repo.find_all_by(:unit_price, "potato")
  end
end

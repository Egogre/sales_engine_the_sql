require_relative 'test_helper'

class MerchantRepositoryTest < Minitest::Test
attr_reader :merchant_repo

def setup
  engine = SalesEngine.new
  engine.startup
  @merchant_repo = engine.merchant_repository
end

  def test_it_exists
    assert merchant_repo
  end

  def test_all_returns_all_merchants
    assert_equal 100, merchant_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << merchant_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

  def test_find_by_id
    merchant = merchant_repo.find_by_id(98)

    assert_equal "Okuneva, Prohaska and Rolfson", merchant[0]["name"]
  end

  def test_find_by_name
    query_name = "Sporer, Christiansen and Connelly"
    assert_equal 56, merchant_repo.find_by_name(query_name)[0]["id"]
  end

end

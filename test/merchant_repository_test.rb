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
    merchant1 = merchant_repo.find_by_id(98)
    merchant2 = merchant_repo.find_by_id(11)

    assert_equal "Okuneva, Prohaska and Rolfson", merchant1["name"]
    assert_equal "Pollich and Sons", merchant2["name"]
  end

  def test_find_by_name
    query_name1 = "Sporer, Christiansen and Connelly"
    query_name2 = "Friesen, Hackett and Runte"

    assert_equal 56, merchant_repo.find_by_name(query_name1)[0]["id"]
    assert_equal 90, merchant_repo.find_by_name(query_name2)[0]["id"]
  end

  def test_most_revenue
    top_3 = 3

    expected = {"Okuneva, Prohaska and Rolfson"=>"$124181.06",
                "Bechtelar, Jones and Stokes"=>"$110898.05",
                "Tromp Inc"=>"$78824.63"}

    assert_equal expected, merchant_repo.most_revenue(top_3)
  end

end

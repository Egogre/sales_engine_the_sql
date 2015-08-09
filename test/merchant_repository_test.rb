require_relative 'test_helper'

class MerchantRepositoryTest < Minitest::Test
attr_reader :merchant_repo

  def setup
    csv_table = [{
                  :id => 1,
                  :name => "Fun Guys"
                 },
                 {
                  :id => 2,
                  :name => "Interesting Folk"
                 },
                 {
                  :id => 3,
                  :name => "Dirty Villagers"
                 }]
    engine = "Pretend Engine"
    @merchant_repo = MerchantRepository.new(csv_table, engine)
  end

  def test_it_exists
    assert merchant_repo
  end

  def test_it_converts_to_hash
    assert_kind_of Hash, merchant_repo.records
  end

  def test_all_returns_all_merchants
    assert_equal 3, merchant_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << merchant_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

end

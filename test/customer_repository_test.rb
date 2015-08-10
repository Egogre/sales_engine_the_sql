require_relative 'test_helper'

class CustomerRepositoryTest < Minitest::Test
attr_reader :customer_repo

  def setup
    csv_table = [{
                  :id => 1,
                  :first_name => "George",
                  :last_name => "Hudson"
                 },
                 {
                  :id => 2,
                  :first_name => "Naiya",
                  :last_name => "Washburn"
                 },
                 {
                  :id => 3,
                  :first_name => "Alida",
                  :last_name => "Washburn"
                 }]
    engine = "Pretend Engine"
    @customer_repo = CustomerRepository.new(csv_table, engine)
  end

  def test_it_exists
    assert customer_repo
  end

  def test_it_converts_to_hash
    assert_kind_of Hash, customer_repo.records
  end

  def test_all_returns_all_customers
    assert_equal 3, customer_repo.all.length
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

    assert_equal "Naiya", customer[:first_name]
  end

  def test_find_all_by_first_name
    customer_repo.load_customer_searches
    
    assert_equal 1, customer_repo.find_all_by_first_name("Alida").count
  end

end

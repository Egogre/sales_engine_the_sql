require_relative 'test_helper'

class TransactionRepositoryTest < Minitest::Test
attr_reader :transaction_repo

def setup
  engine = SalesEngine.new
  engine.startup
  @transaction_repo = engine.transaction_repository
end

  def test_it_exists
    assert transaction_repo
  end

  def test_all_returns_all_transactions
    assert_equal 5595, transaction_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << transaction_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

  def test_find_by_id
    transaction = transaction_repo.find_by_id(432)

    assert_equal 372, transaction[0]["invoice_id"]
  end

  def test_find_all_by_invoice_id
    assert_equal 74, transaction_repo.find_all_by_invoice_id(66)[0]["id"]
  end

  def test_find_by_credit_card_number
    card_number = 4017503416578382
    transaction = transaction_repo.find_by_credit_card_number(card_number)
    assert_equal "failed", transaction[0]["result"]
  end

  def test_find_all_by_result
    assert_equal 947, transaction_repo.find_all_by_result("failed").count
  end

end

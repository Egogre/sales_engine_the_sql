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
    transaction1 = transaction_repo.find_by_id(432)
    transaction2 = transaction_repo.find_by_id(12)

    assert_equal 372, transaction1["invoice_id"]
    assert_equal "failed", transaction2["result"]
  end

  def test_find_all_by_invoice_id
    assert_equal 74, transaction_repo.find_all_by_invoice_id(66)[0]["id"]
    assert_equal 3, transaction_repo.find_all_by_invoice_id(12).count
  end

  def test_find_by_credit_card_number
    card_number1 = 4017503416578382
    transaction1 = transaction_repo.find_by_credit_card_number(card_number1)
    card_number2 = 4210552883101907
    transaction2 = transaction_repo.find_by_credit_card_number(card_number2)

    assert_equal "failed", transaction1[0]["result"]
    assert_equal 141, transaction2[0]["invoice_id"]
  end

  def test_find_all_by_result
    assert_equal 947, transaction_repo.find_all_by_result("failed").count
    assert_equal 4648, transaction_repo.find_all_by_result("success").count
  end

end

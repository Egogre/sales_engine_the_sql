require_relative 'test_helper'

class TransactionRepositoryTest < Minitest::Test
attr_reader :transaction_repo

  def setup
    csv_table = [{
                  :id => 1,
                  :invoice_id => 4,
                  :credit_card_number => 1234123412341234,
                  :credit_card_expiration_date => "09-12-15",
                  :result => "success"
                 },
                 {
                  :id => 2,
                  :invoice_id => 4,
                  :credit_card_number => 1111222233334444,
                  :credit_card_expiration_date => "04-12-12",
                  :result => "success"
                 },
                 {
                  :id => 3,
                  :invoice_id => 4,
                  :credit_card_number => 4321432143214321,
                  :credit_card_expiration_date => "09-08-17",
                  :result => "failed"
                 }]
    engine = "Pretend Engine"
    @transaction_repo = TransactionRepository.new(csv_table, engine)
  end

  def test_it_exists
    assert transaction_repo
  end

  def test_it_converts_to_hash
    assert_kind_of Hash, transaction_repo.records
  end

  def test_all_returns_all_transactions
    assert_equal 3, transaction_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << transaction_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

end

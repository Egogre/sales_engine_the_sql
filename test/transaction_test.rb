require_relative 'test_helper'

class TransactionTest < Minitest::Test
  attr_reader :transaction_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @transaction_repo = engine.transaction_repository
  end

  def test_it_can_pull_an_invoice
    transaction = Transaction.new(transaction_repo.find_by_id(3), db)

    assert_equal Invoice, transaction.invoice.class
  end

  def test_it_pulls_the_correct_invoice
    transaction = Transaction.new(transaction_repo.find_by_id(3), db)

    assert_equal 4, transaction.invoice.attributes["id"]
    assert_equal 33, transaction.invoice.attributes["merchant_id"]
  end

  def test_knows_own_type_name
    transaction = Transaction.new(transaction_repo.find_by_id(625), db)

    assert_equal :transaction, transaction.type_name
  end
end

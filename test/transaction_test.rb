require_relative 'test_helper'

class TransactionTest < Minitest::Test
  attr_reader :transaction_repo, :db

  def setup
    engine = SalesEngine.new
    engine.startup
    @db = engine.db
    @transaction_repo = engine.transaction_repository
  end

  def test_it_has_attributes
    transaction = transaction_repo.find_by_id(9)

    assert_equal 9, transaction.id
    assert_equal 10, transaction.invoice_id
    assert_equal 4140149827486249, transaction.credit_card_number
    assert_equal "success", transaction.result
    assert_equal "2012-03-27 14:54:10 UTC", transaction.created_at
    assert_equal "2012-03-27 14:54:10 UTC", transaction.updated_at
  end

  def test_it_can_pull_an_invoice
    transaction = transaction_repo.find_by_id(3)

    assert_equal Invoice, transaction.invoice.class
  end

  def test_it_pulls_the_correct_invoice
    transaction = transaction_repo.find_by_id(3)

    assert_equal 4, transaction.invoice.attributes["id"]
    assert_equal 33, transaction.invoice.attributes["merchant_id"]
  end

end

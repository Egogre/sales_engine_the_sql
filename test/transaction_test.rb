require_relative 'test_helper'

class TransactionTest < Minitest::Test

  @@engine = SalesEngine.new
  @@engine.startup

  def engine
    @@engine
  end

  def test_invoice__it_can_pull_an_invoice
    transaction = engine.transaction_repository.find_by(:id, "3")

    assert_equal Invoice, transaction.invoice.class
  end

  def test_merchant__it_pulls_the_correct_invoice
    transaction = engine.transaction_repository.find_by(:id, "3")

    assert_equal '4', transaction.invoice.id
    assert_equal '33', transaction.invoice.merchant_id
  end

  def test_knows_own_type_name
    transaction = engine.transaction_repository.find_by(:id, "3")
    
    assert_equal :transaction, transaction.type_name
  end
end

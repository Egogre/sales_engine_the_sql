require_relative 'test_helper'

class InvoiceRepositoryTest < Minitest::Test
attr_reader :invoice_repo

def setup
  engine = SalesEngine.new
  engine.startup
  @invoice_repo = engine.invoice_repository
end

  def test_it_exists
    assert invoice_repo
  end

  def test_all_returns_all_invoices
    assert_equal 4843, invoice_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << invoice_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

  def test_find_by_id
    invoice1 = invoice_repo.find_by_id(208)
    invoice2 = invoice_repo.find_by_id(32)

    assert_equal 42, invoice1[0]["customer_id"]
    assert_equal 85, invoice2[0]["merchant_id"]
  end

  def test_find_all_by_customer_id
    assert_equal 6, invoice_repo.find_all_by_customer_id(15).count
    assert_equal 4, invoice_repo.find_all_by_customer_id(67).count
  end

  def test_find_all_by_merchant_id
    assert_equal 50, invoice_repo.find_all_by_merchant_id(32).count
    assert_equal 43, invoice_repo.find_all_by_merchant_id(3).count
  end

  def test_find_all_by_status
    assert_equal 4843, invoice_repo.find_all_by_status("shipped").count
  end

end

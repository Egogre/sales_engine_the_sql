require_relative 'test_helper'

class InvoiceRepositoryTest < Minitest::Test
attr_reader :invoice_repo

  def setup
    csv_table = [{
                  :id => 1,
                  :customer_id => 1,
                  :merchant_id => 4,
                  :status => "shipped"
                 },
                 {
                  :id => 2,
                  :customer_id => 2,
                  :merchant_id => 4,
                  :status => "shipped"
                 },
                 {
                  :id => 3,
                  :customer_id => 1,
                  :merchant_id => 2,
                  :status => "shipped"
                 }]
    engine = "Pretend Engine"
    @invoice_repo = InvoiceRepository.new(csv_table, engine)
  end

  def test_it_exists
    assert invoice_repo
  end

  def test_it_converts_to_hash
    assert_kind_of Hash, invoice_repo.records
  end

  def test_all_returns_all_invoices
    assert_equal 3, invoice_repo.all.length
  end

  def test_random
    instances = []
    100.times do
      instances << invoice_repo.random
    end

    refute_equal 1, instances.uniq.length
  end

end

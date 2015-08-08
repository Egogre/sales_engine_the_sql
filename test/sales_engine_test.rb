require_relative 'test_helper'

class SalesEngineTest < Minitest::Test

  def test_it_exists
    engine = SalesEngine.new

    assert engine
  end

  def test_it_accepts_a_folder_with_the_csvs
    sales_engine_root = File.expand_path('../..',  __FILE__)
    folder = File.join(sales_engine_root, 'data')
    engine = SalesEngine.new(folder)

    assert engine.customers_file
    assert engine.invoice_items_file
    assert engine.invoices_file
    assert engine.items_file
    assert engine.merchants_file
    assert engine.transactions_file
  end

  def test_files_are_converted_to_table
    engine = SalesEngine.new

    assert_kind_of CSV::Table, engine.customers_file
    assert_kind_of CSV::Table, engine.invoice_items_file
    assert_kind_of CSV::Table, engine.invoices_file
    assert_kind_of CSV::Table, engine.items_file
    assert_kind_of CSV::Table, engine.merchants_file
    assert_kind_of CSV::Table, engine.transactions_file
  end

  def test_it_loads_repositories
    engine = SalesEngine.new
    engine.startup

    assert engine.customer_repository
    assert engine.invoice_item_repository
    assert engine.invoice_repository
    assert engine.item_repository
    assert engine.merchant_repository
    assert engine.transaction_repository
  end

end

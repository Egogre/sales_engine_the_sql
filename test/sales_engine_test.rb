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

    assert engine.customers
    assert engine.invoice_items
    assert engine.invoices
    assert engine.items
    assert engine.merchants
    assert engine.transactions
  end

  def test_files_are_converted_to_table
    engine = SalesEngine.new

    assert_kind_of CSV::Table, engine.customers
    assert_kind_of CSV::Table, engine.invoice_items
    assert_kind_of CSV::Table, engine.invoices
    assert_kind_of CSV::Table, engine.items
    assert_kind_of CSV::Table, engine.merchants
    assert_kind_of CSV::Table, engine.transactions
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

  def test_it_creates_database
    engine = SalesEngine.new
    engine.startup

    assert_equal SQLite3::Database, engine.db.class
  end

end

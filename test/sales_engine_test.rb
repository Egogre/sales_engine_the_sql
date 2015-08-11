require_relative 'test_helper'

class SalesEngineTest < Minitest::Test

  def test_it_exists
    skip
    engine = SalesEngine.new

    assert engine
  end

  def test_it_accepts_a_folder_with_the_csvs
    skip
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
    skip
    engine = SalesEngine.new

    assert_kind_of CSV::Table, engine.customers
    assert_kind_of CSV::Table, engine.invoice_items
    assert_kind_of CSV::Table, engine.invoices
    assert_kind_of CSV::Table, engine.items
    assert_kind_of CSV::Table, engine.merchants
    assert_kind_of CSV::Table, engine.transactions
  end

  def test_it_loads_repositories
    skip
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
    skip
    engine = SalesEngine.new
    engine.startup

    assert_equal SQLite3::Database, engine.db.class
  end

  def test_it_loads_tables
    engine = SalesEngine.new
    engine.startup

    result1 = engine.db.execute("SELECT * FROM customers;")
    result2 = engine.db.execute("SELECT * FROM invoice_items;")
    result3 = engine.db.execute("SELECT * FROM invoices;")
    result4 = engine.db.execute("SELECT * FROM items;")
    result5 = engine.db.execute("SELECT * FROM merchants;")
    result6 = engine.db.execute("SELECT * FROM transactions;")

    assert_equal "Joey", result1[0]["first_name"]
    assert_equal 6, result2[52]["quantity"]
    assert_equal 7, result3[23]["customer_id"]
    assert_equal 39891, result4[13]["unit_price"]
    assert_equal "Rowe and Sons", result5[31]["name"]
    assert_equal 201, result6[221]["invoice_id"]
  end

end

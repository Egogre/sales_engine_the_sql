require 'sqlite3'

module GeneralRepository
  attr_reader :db

  def initialize(database)
    @db = database
  end

  def all
    db.execute("
    SELECT * FROM #{table};
    ")
  end

  def random
    @table_length ||= all.count
    random_id = rand(1..@table_length)
    db.execute("
    SELECT * FROM #{table} WHERE id = #{random_id};
    ")
  end

  def find_by_id(query_id)
    db.execute("
    SELECT * FROM #{table} WHERE id = #{query_id};
    ")
  end

  def find_all_by_created_at(query_date)
    db.execute("
    SELECT * FROM #{table} WHERE created_at = '#{query_date}';
    ")
  end

  def find_all_by_updated_at(query_date)
    db.execute("
    SELECT * FROM #{table} WHERE updated_at = '#{query_date}';
    ")
  end

  def find_all_by_invoice_id(query_id)
    db.execute("
    SELECT * FROM #{table} WHERE invoice_id = #{query_id};
    ")
  end

  def find_all_by_unit_price(query_price)
    db.execute("
    SELECT * FROM #{table} WHERE unit_price = #{query_price};
    ")
  end

  def find_all_by_merchant_id(query_id)
    db.execute("
    SELECT * FROM #{table} WHERE merchant_id = #{query_id};
    ")
  end

  def find_by_name(query_name)
    db.execute("
    SELECT * FROM #{table} WHERE name = '#{query_name}';
    ")
  end

end

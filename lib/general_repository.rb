require 'sqlite3'

module GeneralRepository
  attr_reader :db, :all, :time

  def initialize(database)
    @db = database
    all_data = db.execute("
    SELECT * FROM #{table};
    ")
    @all = all_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def random
    @table_length ||= all.count
    random_id = rand(1..@table_length)
    random_data = db.execute("
    SELECT * FROM #{table} WHERE id = #{random_id};
    ")[0]
    instance_class(random_data, db)
  end

  def find_by_id(query_id)
    instance_data = db.execute("
    SELECT * FROM #{table} WHERE id = #{query_id};
    ")[0]
    instance_class(instance_data, db)
  end

  def find_all_by_created_at(query_date)
    all_created_at = db.execute("
    SELECT * FROM #{table} WHERE created_at = '#{query_date}';
    ")
    all_created_at.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_all_by_updated_at(query_date)
    all_updated_at = db.execute("
    SELECT * FROM #{table} WHERE updated_at = '#{query_date}';
    ")
    all_updated_at.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_all_by_invoice_id(query_id)
    invoice_data = db.execute("
    SELECT * FROM #{table} WHERE invoice_id = #{query_id};
    ")
    invoice_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_all_by_unit_price(query_price)
    data_table = db.execute("
    SELECT * FROM #{table} WHERE unit_price = #{(query_price * 100).to_i};
    ")
    data_table.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_by_unit_price(query_price)
    instance_data = db.execute("
    SELECT * FROM #{table} WHERE unit_price = #{(query_price * 100).to_i};
    ")[0]
      instance_class(instance_data, db)
  end

  def find_all_by_merchant_id(query_id)
    merchant_table = db.execute("
    SELECT * FROM #{table} WHERE merchant_id = #{query_id};
    ")
    merchant_table.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_by_name(query_name)
    name_data = db.execute("
    SELECT * FROM #{table} WHERE name = '#{query_name}';
    ")[0]
    instance_class(name_data, db)
  end

  def find_all_by_name(query_name)
    name_data = db.execute("
    SELECT * FROM #{table} WHERE name = '#{query_name}';
    ")
    name_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def inspect
    "#<#{self.class} #{all.size} rows>"
  end

  def successful_transaction_invoice_ids
    db.execute("
    SELECT invoice_id FROM transactions WHERE result = 'success';
    ").map {|row| row["invoice_id"]}
  end

  def successful_invoice_items_qup
    db.execute("
    SELECT * FROM invoice_items
    WHERE invoice_id IN (#{string_invoice_ids});
    ")
  end

  private

  def string_invoice_ids
    successful_transaction_invoice_ids.join(", ")
  end

end

require 'csv'
require 'sqlite3'

class SalesEngine
  attr_reader :customers,
              :customer_repository,
              :invoice_items,
              :invoice_item_repository,
              :invoices,
              :invoice_repository,
              :items,
              :item_repository,
              :merchants,
              :merchant_repository,
              :transactions,
              :transaction_repository,
              :db,
              :customer_table

  def initialize(csv_folder = nil)
    `rm -rf "sales_engine.db"`
    csv_folder = csv_folder || File.expand_path('../../data',  __FILE__)
    @customers          = CSV.read("#{csv_folder}/customers.csv",
                                  :headers => true,
                                  :header_converters => :symbol,
                                  :converters => :numeric)
    @invoice_items      = CSV.read("#{csv_folder}/invoice_items.csv",
                                  :headers => true,
                                  :header_converters => :symbol,
                                  :converters => :numeric)
    @invoices           = CSV.read("#{csv_folder}/invoices.csv",
                                  :headers => true,
                                  :header_converters => :symbol,
                                  :converters => :numeric)
    @items              = CSV.read("#{csv_folder}/items.csv",
                                  :headers => true,
                                  :header_converters => :symbol,
                                  :converters => :numeric)
    @merchants          = CSV.read("#{csv_folder}/merchants.csv",
                                  :headers => true,
                                  :header_converters => :symbol,
                                  :converters => :numeric)
    @transactions       = CSV.read("#{csv_folder}/transactions.csv",
                                  :headers => true,
                                  :header_converters => :symbol,
                                  :converters => :numeric)
    @db = SQLite3::Database.new("sales_engine.db")
    db.results_as_hash = true
    load_database_tables
  end

  def startup
    @customer_repository     = CustomerRepository.new(customers, self)
    @invoice_item_repository = InvoiceItemRepository.new(invoice_items, self)
    @invoice_repository      = InvoiceRepository.new(invoices, self)
    @item_repository         = ItemRepository.new(items, self)
    @merchant_repository     = MerchantRepository.new(merchants, self)
    @transaction_repository  = TransactionRepository.new(transactions, self)
  end

  def load_database_tables
    load_customer_table
  end

  def load_customer_table
    db.execute <<-SQL
    CREATE TABLE customers (id INTEGER PRIMARY KEY AUTOINCREMENT,
                                        first_name VARCHAR(20),
                                        last_name VARCHAR(20),
                                        created_at DATETIME,
                                        updated_at DATETIME);
    SQL

    customers.each do |customer|
      columns = 'first_name, last_name, created_at, updated_at'
      vals = [customer[:first_name], customer[:last_name], customer[:created_at], customer[:updated_at]]
      db.execute "INSERT INTO customers (#{columns}) VALUES (?,?,?,?);", vals
    end
  end
  #INSERT INTO games(yr,city) VALUES (2005,'Athens');

  # def add(record_attributes)
  #     keys = (record_attributes[0] || {}).keys
  #     name_sql = keys.join(', ')
  #
  #     values_sql = record_attributes.map { |attrs|
  #       sql = keys.map { |key| attrs[key].inspect }.join(", ")
  #       "(#{sql})"
  #     }.join(", ")
  #
  #     insert_sql = "insert into #{table_name} (#{name_sql}) values #{values_sql};"
  #     db.execute(insert_sql)
  #   end

end

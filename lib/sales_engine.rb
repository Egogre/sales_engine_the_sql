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
    if Dir.glob("*.db")
      @db = SQLite3::Database.open("sales_engine.db")
      db.results_as_hash = true
    else
      build_database
    end
  end

  def startup
    @customer_repository     = CustomerRepository.new(db)
    @invoice_item_repository = InvoiceItemRepository.new(db)
    @invoice_repository      = InvoiceRepository.new(db)
    @item_repository         = ItemRepository.new(db)
    @merchant_repository     = MerchantRepository.new(db)
    @transaction_repository  = TransactionRepository.new(db)
  end

  def build_database
    @db = SQLite3::Database.new("sales_engine.db")
    db.results_as_hash = true
    load_database_tables
  end

  def load_database_tables
    load_customer_table
    load_invoice_item_table
    load_invoice_table
    load_item_table
    load_merchant_table
    load_transaction_table
  end

  def load_customer_table
    db.execute "
    CREATE TABLE customers (id INTEGER PRIMARY KEY AUTOINCREMENT,
                            first_name VARCHAR(20),
                            last_name VARCHAR(20),
                            created_at DATETIME,
                            updated_at DATETIME);"

    customers.each do |customer|
      columns = 'first_name,
                 last_name,
                 created_at,
                 updated_at'
      vals = [customer[:first_name],
              customer[:last_name],
              customer[:created_at],
              customer[:updated_at]]
      db.execute "
      INSERT INTO customers (#{columns}) VALUES (?,?,?,?);
      ", vals
    end
  end

  def load_invoice_item_table
    db.execute "
    CREATE TABLE invoice_items (id INTEGER PRIMARY KEY AUTOINCREMENT,
                                item_id INTEGER,
                                invoice_id INTEGER,
                                quantity INTEGER,
                                unit_price INTEGER,
                                created_at DATETIME,
                                updated_at DATETIME);"
    invoice_items.each do |invoice_item|
      columns = 'item_id,
                 invoice_id,
                 quantity,
                 unit_price,
                 created_at,
                 updated_at'
      vals = [invoice_item[:item_id],
              invoice_item[:invoice_id],
              invoice_item[:quantity],
              invoice_item[:unit_price],
              invoice_item[:created_at],
              invoice_item[:updated_at]]
      db.execute "
      INSERT INTO invoice_items (#{columns}) VALUES (?,?,?,?,?,?);
      ", vals
    end
  end

  def load_invoice_table
    db.execute "
    CREATE TABLE invoices (id INTEGER PRIMARY KEY AUTOINCREMENT,
                            customer_id INTEGER,
                            merchant_id INTEGER,
                            status VARCHAR(10),
                            created_at DATETIME,
                            updated_at DATETIME);"

    invoices.each do |invoice|
      columns = 'customer_id,
                 merchant_id,
                 status,
                 created_at,
                 updated_at'
      vals = [invoice[:customer_id],
              invoice[:merchant_id],
              invoice[:status],
              invoice[:created_at],
              invoice[:updated_at]]
      db.execute "
      INSERT INTO invoices (#{columns}) VALUES (?,?,?,?,?);
      ", vals
    end
  end

  def load_item_table
    db.execute "
    CREATE TABLE items (id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name VARCHAR(30),
                            description VARCHAR(200),
                            unit_price INTEGER,
                            merchant_id INTEGER,
                            created_at DATETIME,
                            updated_at DATETIME);"

    items.each do |item|
      columns = 'name,
                 description,
                 unit_price,
                 merchant_id,
                 created_at,
                 updated_at'
      vals = [item[:name],
              item[:description],
              item[:unit_price],
              item[:merchant_id],
              item[:created_at],
              item[:updated_at]]
      db.execute "
      INSERT INTO items (#{columns}) VALUES (?,?,?,?,?,?);
      ", vals
    end
  end

  def load_merchant_table
    db.execute "
    CREATE TABLE merchants (id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name VARCHAR(40),
                            created_at DATETIME,
                            updated_at DATETIME);"

    merchants.each do |merchant|
      columns = 'name,
                 created_at,
                 updated_at'
      vals = [merchant[:name],
              merchant[:created_at],
              merchant[:updated_at]]
      db.execute "
      INSERT INTO merchants (#{columns}) VALUES (?,?,?);
      ", vals
    end
  end

  def load_transaction_table
    db.execute "
    CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT,
                            invoice_id INTEGER,
                            credit_card_number INTEGER,
                            credit_card_expiration_date DATETIME,
                            result VARCHAR(10),
                            created_at DATETIME,
                            updated_at DATETIME);"

    transactions.each do |transaction|
      columns = 'invoice_id,
                 credit_card_number,
                 credit_card_expiration_date,
                 result,
                 created_at,
                 updated_at'
      vals = [transaction[:invoice_id],
              transaction[:credit_card_number],
              transaction[:credit_card_expiration_date],
              transaction[:result],
              transaction[:created_at],
              transaction[:updated_at]]
      db.execute "
      INSERT INTO transactions (#{columns}) VALUES (?,?,?,?,?,?);
      ", vals
    end
  end

end

require 'csv'

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
              :transaction_repository

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
  end

  def startup
    @customer_repository     = CustomerRepository.new(customers, self)
    @invoice_item_repository = InvoiceItemRepository.new(invoice_items, self)
    @invoice_repository      = InvoiceRepository.new(invoices, self)
    @item_repository         = ItemRepository.new(items, self)
    @merchant_repository     = MerchantRepository.new(merchants, self)
    @transaction_repository  = TransactionRepository.new(transactions, self)
  end

end

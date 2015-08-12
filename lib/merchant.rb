require_relative 'instance_module'
require_relative 'item'
require_relative 'invoice'

class Merchant
  include InstanceModule
  attr_reader :name

  def type_name
    :merchant
  end

  def assign_class_specific_attributes
    @name = attributes["name"]
  end

  def id_column
    "merchant_id"
  end

  def items
    item_list = db.execute("
    SELECT * FROM items WHERE merchant_id = #{attributes["id"]};
    ")
    item_list.map {|item| Item.new(item, db)}
  end

  def total_revenue
    revenue = 0
    #revenue returns the total revenue for that merchant across all transactions
    merchant_successful_transactions.each do |transaction|
      revenue += repository.invoice_item_revenue(transaction)
    end
    "#{name} Total revenue: #{repository.dollars(revenue)}"
  end

  def merchant_successful_transactions
    invoices.map do |invoice|
      repository.successful_transactions.find {|t| t.invoice_id == invoice.id}
    end
  end

  def revenue_on_date(date)
    revenue = calculate_revenue_on_date(date)
    "#{name} Total revenue on #{date}: #{repository.dollars(revenue)}"
  end

  def calculate_revenue_on_date(date)
    revenue = 0
    merchant_successful_transactions.each do |transaction|
      revenue += repository.invoice_item_revenue(transaction) if transaction.created_at[0..9] == date
    end
    revenue
  end

  def favorite_customer
    #favorite_customer returns the Customer who has conducted the most successful transactions
     ranked_customers = customer_transactions_hash.to_a.sort {|x,y| y[1] <=> x[1]}
     "Favorite customer name: #{ranked_customers[0][0].first_name} #{ranked_customers[0][0].last_name}, customer id: #{ranked_customers[0][0].id}, with #{ranked_customers[0][1]} successful transactions"
  end

  def customer_transactions_hash
    hash = Hash.new(0)
    merchant_successful_transactions.each do |transaction|
      invoice = invoices.find {|invoice| invoice.id == transaction.invoice.id}
      customer = repository.sales_engine.customer_repository.find_by(:id, invoice.customer_id )
      hash[customer] += 1
    end
    hash
  end

  def customers_with_pending_invoices
    #customers_with_pending_invoices returns a collection of Customer instances which have pending (unpaid) invoices. An invoice is considered pending if none of it’s transactions are successful.
    naughty_customers = {}
    all_pending.each do |invoice|
      customer = repository.sales_engine.customer_repository.find_by(:id, invoice.customer_id)
      naughty_customers[customer.id] = "#{customer.first_name} #{customer.last_name}"
    end
    naughty_customers
  end

  def all_pending
    invoices.select do |invoice|
      invoice if no_successful_transactions?(invoice)
    end
  end

  def no_successful_transactions?(invoice)
    transactions = repository.sales_engine.transaction_repository.find_all_by(:invoice_id, invoice.id)
    transactions.none? {|transaction| transaction.result == "success"}
  end

end

require_relative 'instance_module'
require_relative 'item'
require_relative 'invoice'

class Merchant
  include InstanceModule
  attr_reader :name, :total_revenue, :total_items_sold

  def type_name
    :merchant
  end

  def assign_class_specific_attributes
    @name = attributes["name"]
    @total_revenue = revenue
    @total_items_sold = sold
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

  def revenue(date = nil)
    if date.nil?
      calculate_revenue(successful_invoices)
    else
      calculate_revenue(successful_invoices_on_date(date))
    end
  end

  def calculate_revenue(revenue_invoices)
    revenue_invoices.reduce(0) do |total, invoice|
      quantity_sold = BigDecimal.new(item_qup(invoice.id)[0]["quantity"])
      sell_price = BigDecimal.new(item_qup(invoice.id)[0]["unit_price"])
      total += (quantity_sold * sell_price)
    end
  end

  def successful_invoices
    invoices.select do |invoice|
      invoice_transactions = db.execute("
      SELECT * FROM transactions WHERE invoice_id = #{invoice.id}
      ")
      invoice_transactions.any? do |invoice_transaction|
        invoice_transaction["result"] == "success"
      end
    end
  end

  def successful_invoices_on_date(date)
    successful_invoices.select do |invoice|
      Date.parse(invoice.created_at) == date
    end
  end

  def item_qup(query_id)
    db.execute("
    SELECT quantity, unit_price FROM invoice_items
    WHERE invoice_id = #{query_id}
    ")
  end

  def sold
    successful_invoices.reduce(0) do |total, invoice|
      quantity_sold = BigDecimal.new(item_qup(invoice.id)[0]["quantity"])
      total += quantity_sold
    end
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

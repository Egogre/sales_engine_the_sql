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
      calculate_revenue(merchant_successful_invoice_items)
    else
      calculate_revenue(merchant_successful_invoice_items_on_date(date))
    end
  end

  def merchant_successful_invoice_items
    successful_invoice_items_qup.select do |invoice_item|
      db.execute("
      SELECT * FROM invoices WHERE id = #{invoice_item["invoice_id"]};
      ")[0]["merchant_id"] == id
    end
  end

  def merchant_successful_invoice_items_on_date(date)
    successful_invoice_items_qup.select do |invoice_item|
      check = db.execute("
      SELECT * FROM invoices WHERE id = #{invoice_item["invoice_id"]};
      ")[0]
      check["merchant_id"] == id && Date.parse(check["created_at"]) == date
    end
  end

  def calculate_revenue(revenue_invoices)
    revenue_invoices.reduce(0) do |total, invoice|
      quantity_sold = BigDecimal.new(invoice["quantity"])
      sell_price = BigDecimal.new(invoice["unit_price"])
      total += (quantity_sold * sell_price)/100
    end
  end

  def sold
    merchant_successful_invoice_items.reduce(0) do |total, invoice|
      quantity_sold = BigDecimal.new(invoice["quantity"])
      total += quantity_sold
    end
  end

  def favorite_customer
    Customer.new(favorite_customer_data, db)
  end

  def favorite_customer_data
    db.execute("
    SELECT * FROM customers WHERE id = #{fav_customer_id};
    ")[0]
  end

  def fav_customer_id
    customer_visits.max_by {|customer| customer[1]}[0]
  end

  def customer_visits
    merchant_revenue_invoices.each_with_object(Hash.new(0)) do |invoice, hash|
      hash[invoice.customer_id] += 1
    end
  end

  def merchant_revenue_invoices
    successful_invoices.select {|invoice| invoice.merchant_id == id}
  end

  def successful_invoices
    db.execute("
    SELECT * FROM invoices WHERE id IN (#{string_invoice_ids});
    ").map {|invoice_data| Invoice.new(invoice_data, db)}
  end

  def customers_with_pending_invoices
    bad_customers.map do |customer|
      customer_data = db.execute("
      SELECT * FROM customers WHERE id = #{customer[0]};
      ")[0]
      Customer.new(customer_data, db)
    end
  end

  def bad_customers
    all_pending.each_with_object(Hash.new(0)) do |invoice, hash|
      hash[invoice.customer_id] += 1
    end
  end

  def all_pending
    invoices.select do |invoice|
      invoice if no_successful_transactions?(invoice)
    end
  end

  def no_successful_transactions?(invoice)
    transactions = db.execute ("
    SELECT * FROM transactions where invoice_id = #{invoice.id};
    ")
    transactions.none? {|transaction| transaction["result"] == "success"}
  end

end

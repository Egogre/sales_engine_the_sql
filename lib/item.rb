require_relative 'instance_module'

class Item
  include InstanceModule
  attr_reader :name, :description, :unit_price, :merchant_id

  def type_name
    :item
  end

  def assign_class_specific_attributes
    @name = attributes["name"]
    @decription = attributes["decription"]
    @unit_price = attributes["unit_price"]
    @merchant_id = attributes["merchant_id"]
  end

  def invoice_items
    invoice_item_list = db.execute("
    SELECT * FROM invoice_items WHERE item_id = (#{attributes["id"]});
    ")
    invoice_item_list.map {|invoice_item| InvoiceItem.new(invoice_item, db)}
  end

  def merchant
    merchant_data = db.execute("
    SELECT * FROM merchants WHERE id = (#{attributes["merchant_id"]});
    ")
    Merchant.new(merchant_data[0], db)
  end

  def best_day
    # returns the date with the most sales for the given item using the invoice date
    #find all invoice invoice_items
    #add quantity if transaction successful
    hash = Hash.new(0)
    invoice_items.each do |invoice_item|
      hash[invoice_item.created_at[0..9]] += invoice_item.quantity.to_i if transaction_successful?(invoice_item)
    end
    sales = hash.values.sort[-1]
    date = hash.key(sales)
    "best day for #{name} sales is #{date} with #{sales} units sold"
  end

  def transaction_successful?(invoice_item)
    item_transactions(invoice_item).any? {|transaction| transaction.result == "success"}
  end

  def invoice(invoice_item)
    repository.sales_engine.invoice_repository.find_by(:id, invoice_item.invoice_id)
  end

  def item_transactions(invoice_item)
    repository.sales_engine.transaction_repository.find_all_by(:invoice_id, invoice(invoice_item).id)
  end
end

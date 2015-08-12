require_relative 'instance_module'
require_relative 'item'

class Invoice
  include InstanceModule
  attr_reader :customer_id, :merchant_id, :status

  def type_name
    :invoice
  end

  def transactions
    transaction_list = db.execute("
    SELECT * FROM transactions WHERE invoice_id = (#{attributes["id"]});
    ")
    transaction_list.map {|transaction| Transaction.new(transaction, db)}
  end

  def invoice_items
    invoice_item_list = db.execute("
    SELECT * FROM invoice_items WHERE invoice_id = (#{attributes["id"]});
    ")
    invoice_item_list.map {|invoice_item| InvoiceItem.new(invoice_item, db)}
  end

  def items
    item_list = db.execute("
    SELECT * FROM items WHERE id IN (#{item_ids});
    ")
    item_list.map {|item| Item.new(item, db)}
  end

  def customer
    customer_data = db.execute("
    SELECT * FROM customers WHERE id = (#{attributes["customer_id"]});
    ")
    Customer.new(customer_data[0], db)
  end

  def merchant
    merchant_data = db.execute("
    SELECT * FROM merchants WHERE id = (#{attributes["merchant_id"]});
    ")
    Merchant.new(merchant_data[0], db)
  end

  private

  def item_ids
    ids = invoice_items.map {|invoice_item| invoice_item.attributes["item_id"]}
    ids.join(", ")
  end

end

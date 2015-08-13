require_relative 'instance_module'
require_relative 'item'

class Invoice
  include InstanceModule
  attr_reader :customer_id, :merchant_id, :status, :time

  def type_name
    :invoice
  end

  def assign_class_specific_attributes
    @customer_id = attributes["customer_id"]
    @merchant_id = attributes["merchant_id"]
    @status = attributes["status"]
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

  def charge(*card_attributes)
    @time = Time.now.utc
    vals = [id,
            card_attributes[0][:credit_card_number],
            card_attributes[0][:credit_card_expiration_date],
            card_attributes[0][:result],
            "#{time}",
            "#{time}"]
    db.execute("
    INSERT INTO transactions (#{transactions_columns}) VALUES (?,?,?,?,?,?);
    ", vals)
  end

  private

  def item_ids
    ids = invoice_items.map {|invoice_item| invoice_item.attributes["item_id"]}
    ids.join(", ")
  end

  def transactions_columns
    'invoice_id,
     credit_card_number,
     credit_card_expiration_date,
     result,
     created_at,
     updated_at'
  end

end

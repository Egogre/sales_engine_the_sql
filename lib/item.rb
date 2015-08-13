require_relative 'instance_module'

class Item
  include InstanceModule
  attr_reader :name, :description, :unit_price, :merchant_id

  def id_column
    "item_id"
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
    number_sold_by_date.max_by {|date, revenue| revenue}[0]
  end

  private

  def item_successful_invoice_items
    successful_invoice_items_qup.select do |invoice_item|
      invoice_item["item_id"] == id
    end
  end

  def number_sold_by_date
    item_successful_invoice_items.each_with_object(Hash.new(0)) do |item, hash|
      hash[Date.parse("#{item_invoiced_date(item)}")] += item["quantity"]
    end
  end

  def item_invoiced_date(item)
    db.execute("
    SELECT created_at FROM invoices WHERE id = #{item['invoice_id']};
    ")[0]["created_at"]
  end

end

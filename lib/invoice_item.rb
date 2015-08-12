require_relative 'instance_module'

class InvoiceItem
  include InstanceModule
  attr_reader :item_id, :invoice_id, :quantity, :unit_price

  def type_name
    :invoice_item
  end

  def assign_class_specific_attributes
    @item_id = attributes["item_id"]
    @invoice_id = attributes["invoice_id"]
    @quantity = attributes["quantity"]
    @unit_price = attributes["unit_price"]
  end

  def invoice
    invoice_data = db.execute("
    SELECT * FROM invoices WHERE id = #{attributes["invoice_id"]};
    ")
    Invoice.new(invoice_data[0], db)
  end

  def item
    repository.sales_engine.item_repository.find_by(:id, item_id)
  end

  #untested
  def revenue
    quantity.to_i * unit_price.to_i
  end
end

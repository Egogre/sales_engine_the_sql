require_relative 'general_repository'

class InvoiceItemRepository
  include GeneralRepository
  attr_reader :invoice_items_by_item_id,
              :invoice_items_by_invoice_id,
              :invoice_items_by_quantity,
              :invoice_items_by_unit_price

  def find_all_by_item_id(id)
    invoice_items_by_item_id[id]
  end

  def find_all_by_invoice_id(id)
    invoice_items_by_invoice_id[id]
  end

  def find_all_by_quantity(quantity)
    invoice_items_by_quantity[quantity]
  end

  def find_all_by_unit_price(price)
    invoice_items_by_unit_price[price]
  end

  def load_invoice_item_searches
    @invoice_items_by_item_id = csv_table.group_by do |invoice_item|
      invoice_item[:item_id]
    end
    @invoice_items_by_invoice_id = csv_table.group_by do |invoice_item|
      invoice_item[:invoice_id]
    end
    @invoice_items_by_quantity = csv_table.group_by do |invoice_item|
      invoice_item[:quantity]
    end
    @invoice_items_by_unit_price = csv_table.group_by do |invoice_item|
      invoice_item[:unit_price]
    end
  end

end

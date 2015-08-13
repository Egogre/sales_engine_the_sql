require_relative 'general_repository'
require_relative 'invoice_item'

class InvoiceItemRepository
  include GeneralRepository

  def table
    'invoice_items'
  end

  def instance_class(attributes, database)
    InvoiceItem.new(attributes, database)
  end

  def find_all_by_item_id(query_id)
    invoice_item_data = db.execute("
    SELECT * FROM invoice_items WHERE item_id = #{query_id};
    ")
    invoice_item_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_by_item_id(query_id)
    invoice_item_data = db.execute("
    SELECT * FROM invoice_items WHERE item_id = #{query_id};
    ")[0]
      instance_class(invoice_item_data, db)
  end

  def find_all_by_quantity(query_quantity)
    invoice_item_data = db.execute("
    SELECT * FROM invoice_items WHERE quantity = #{query_quantity};
    ")
    invoice_item_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

end

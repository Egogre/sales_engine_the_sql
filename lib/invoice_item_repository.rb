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
    db.execute("
    SELECT * FROM invoice_items WHERE item_id = #{query_id};
    ")
  end

  def find_all_by_quantity(query_quantity)
    db.execute("
    SELECT * FROM invoice_items WHERE quantity = #{query_quantity};
    ")
  end

end

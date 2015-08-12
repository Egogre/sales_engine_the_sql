require_relative 'general_repository'
require_relative 'invoice'

class InvoiceRepository
  include GeneralRepository

  def table
    'invoices'
  end

  def instance_class(attributes, database)
    Invoice.new(attributes, database)
  end

  def find_all_by_customer_id(query_id)
    db.execute("
    SELECT * FROM invoices WHERE customer_id = #{query_id};
    ")
  end

  def find_all_by_status(query_status)
    db.execute("
    SELECT * FROM invoices WHERE status = '#{query_status}';
    ")
  end

end

require_relative 'general_repository'

class InvoiceRepository
  include GeneralRepository

  def table
    'invoices'
  end
  #id,customer_id,merchant_id,status,created_at,updated_at

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

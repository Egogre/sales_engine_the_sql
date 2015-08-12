require_relative 'instance_module'

class Transaction
  include InstanceModule
  attr_reader :invoice_id, :credit_card_number, :credit_card_expiration_date, :result

  def type_name
    :transaction
  end

  def invoice
    invoice_data = db.execute("
    SELECT * FROM invoices WHERE id = (#{attributes["invoice_id"]});
    ")
    Invoice.new(invoice_data[0], db)
  end
end

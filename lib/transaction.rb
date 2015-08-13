require_relative 'instance_module'

class Transaction
  include InstanceModule
  attr_reader :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result

  def assign_class_specific_attributes
    @invoice_id = attributes["invoice_id"]
    @credit_card_number = attributes["credit_card_number"]
    @credit_card_expiration_date = attributes["credit_card_expiration_date"]
    @result = attributes["result"]
  end

  def invoice
    invoice_data = db.execute("
    SELECT * FROM invoices WHERE id = (#{attributes["invoice_id"]});
    ")
    Invoice.new(invoice_data[0], db)
  end
end

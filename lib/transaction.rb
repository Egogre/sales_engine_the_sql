require_relative 'instance_module'

class Transaction
  include InstanceModule
  attr_reader :invoice_id, :credit_card_number, :credit_card_expiration_date, :result

  def type_name
    :transaction
  end

  def invoice
    # returns an instance of Invoice associated with this object
    repository.sales_engine.invoice_repository.find_by(:id, invoice_id)
  end
end

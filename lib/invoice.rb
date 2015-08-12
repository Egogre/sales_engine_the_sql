require_relative 'instance_module'

class Invoice
  include InstanceModule
  attr_reader :customer_id, :merchant_id, :status

  def type_name
    :invoice
  end

  def transactions
    all_referred_by sales_engine.transaction_repository
  end

  def invoice_items
    all_referred_by sales_engine.invoice_item_repository
  end

  def items
    invoice_items.map do |invoice_item|
      invoice_item.refers_to sales_engine.item_repository
    end.uniq
  end

  def customer
    refers_to sales_engine.customer_repository
  end

  def merchant
    repository.sales_engine.merchant_repository.find_by(:id, merchant_id)
  end

end

require_relative 'instance_module'
require_relative 'transaction'

class Customer
  include InstanceModule
  attr_reader :first_name, :last_name

  def type_name
    :customer
  end

  def assign_class_specific_attributes
    @first_name = attributes["first_name"]
    @last_name = attributes["last_name"]
  end

  def id_column
    "customer_id"
  end

  def transactions
    transaction_list = db.execute("
    SELECT * FROM transactions WHERE invoice_id IN (#{invoice_ids});
    ")
    transaction_list.map {|transaction| Transaction.new(transaction, db)}
  end

  def transaction_ids
    transactions.map {|transaction| transaction.attributes["id"]}
  end

  def favorite_merchant
    # returns an instance of Merchant where the customer has conducted the most successful transactions
    hash = Hash.new(0)
    invoices.each {|invoice| hash[invoice.merchant_id] += 1}
    repository.sales_engine.merchant_repository.find_by(:id, ranked_merchants(hash)[0][0]).name
  end

  private

  def invoice_ids
    invoices.map {|invoice| invoice.attributes["id"]}.join(", ")
  end

  def ranked_merchants(hash)
    hash.to_a.sort {|x, y| y[1] <=> x[1]}
  end

end

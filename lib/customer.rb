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
    Merchant.new(favorite_merchant_data, db)
  end

  private

  def invoice_ids
    invoices.map {|invoice| invoice.attributes["id"]}.join(", ")
  end

  def merchant_visits
    invoices.each_with_object(Hash.new(0)) do |invoice, hash|
      hash[invoice.merchant_id] += 1
    end
  end

  def fav_merchant_id
    merchant_visits.max_by {|merchant| merchant[1]}[0]
  end

  def favorite_merchant_data
    db.execute("
    SELECT * FROM merchants WHERE id = #{fav_merchant_id};
    ")[0]
  end

end

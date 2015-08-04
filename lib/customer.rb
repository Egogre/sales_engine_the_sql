require_relative 'data_instance'

class Customer < DataInstance
  attr_reader :first_name, :last_name

  def initialize(attributes, repository)
    @repository = repository
    @id = attributes[:id]
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
    @created = attributes[:created_at]
    @updated = attributes[:updated_at]
  end

  def invoices
    # returns a collection of Invoice instances associated with this object.
    repository.sales_engine.invoice_repository.find_all_by(:customer_id, id)
  end

  def transaction_ids
    transactions.map {|transaction| transaction.id}
  end

  def favorite_merchant
    # returns an instance of Merchant where the customer has conducted the most successful transactions
    hash = Hash.new(0)
    invoices.each {|invoice| hash[invoice.merchant_id] += 1}
    repository.sales_engine.merchant_repository.find_by(:id, ranked_merchants(hash)[0][0]).name
  end

  private

  def transactions
    # returns an array of Transaction instances associated with the customer
    invoices.map do |invoice|
      repository.sales_engine.transaction_repository.find_by(:invoice_id, invoice.id)
    end
  end

  def ranked_merchants(hash)
    hash.to_a.sort {|x, y| y[1] <=> x[1]}
  end

end

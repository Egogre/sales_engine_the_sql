require_relative 'general_repository'
require_relative 'transaction'

class TransactionRepository
  include GeneralRepository

  def table
    'transactions'
  end

  def instance_class(attributes, database)
    Transaction.new(attributes, database)
  end

  def find_by_credit_card_number(card_number)
    transaction_data = db.execute("
    SELECT * FROM transactions WHERE credit_card_number = #{card_number.to_i};
    ")[0]
    instance_class(transaction_data, db)
  end

  def find_all_by_result(query_result)
    transaction_data = db.execute("
    SELECT * FROM transactions WHERE result = '#{query_result}';
    ")
    transaction_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

end

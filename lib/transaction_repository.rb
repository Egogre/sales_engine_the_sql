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
    db.execute("
    SELECT * FROM transactions WHERE credit_card_number = #{card_number};
    ")
  end

  def find_all_by_result(query_result)
    db.execute("
    SELECT * FROM transactions WHERE result = '#{query_result}';
    ")
  end

end

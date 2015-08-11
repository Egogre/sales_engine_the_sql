require_relative 'general_repository'

class TransactionRepository
  include GeneralRepository

  def table
    'transactions'
  end

end

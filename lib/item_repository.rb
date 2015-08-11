require_relative 'general_repository'

class ItemRepository
  include GeneralRepository

  def table
    'items'
  end

end

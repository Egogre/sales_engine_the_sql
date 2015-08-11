require_relative 'general_repository'

class MerchantRepository
  include GeneralRepository

  def table
    'merchants'
  end

end

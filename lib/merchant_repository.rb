require_relative 'general_repository'
require_relative 'merchant'

class MerchantRepository
  include GeneralRepository

  def table
    'merchants'
  end

  def instance_class(attributes, database)
    Merchant.new(attributes, database)
  end

  def most_revenue(top_x_sellers)

  end

end

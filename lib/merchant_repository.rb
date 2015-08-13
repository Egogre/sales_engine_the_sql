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
    best_sellers = all.max_by(top_x_sellers) do |merchant|
      merchant.total_revenue
    end
  end

  def most_items(top_x_sellers)
    best_sellers = all.max_by(top_x_sellers) do |merchant|
      merchant.total_items_sold
    end
  end

end

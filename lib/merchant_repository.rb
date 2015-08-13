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

  def revenue(date)
    invoice_items_by_date(date).reduce(0) do |total, invoice_item|
      quantity = BigDecimal.new(invoice_item["quantity"])
      price = BigDecimal.new(invoice_item["unit_price"])
      total += (quantity * price)/100
    end
  end

  private

  def invoice_items_by_date(date)
    successful_invoice_items_qup.select do |invoice_item|
      invoice = db.execute("
      SELECT * FROM invoices WHERE id = #{invoice_item["invoice_id"]};
      ")[0]
      Date.parse(invoice["created_at"]) == date
    end
  end

end

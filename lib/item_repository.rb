require 'bigdecimal'
require_relative 'general_repository'
require_relative 'item'

class ItemRepository
  include GeneralRepository

  def table
    'items'
  end

  def instance_class(attributes, database)
    Item.new(attributes, database)
  end

  def find_by_description(query_description)
    item_data = db.execute("
    SELECT * FROM items WHERE description = '#{query_description}';
    ")
    item_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def most_revenue(top_x_items)
    top_items = item_ids_with_revenue.max_by(top_x_items) {|itemrev| itemrev[1]}
    top_items.to_h.keys.map do |top_x_id|
      find_by_id(top_x_id)
    end
  end

  def most_items(top_x_items)
    top_items = item_ids_sold.max_by(top_x_items) {|items_sold| items_sold[1]}
    top_items.to_h.keys.map do |top_x_id|
      find_by_id(top_x_id)
    end
  end

  private

  def item_ids_with_revenue
    successful_invoice_items_qup.each_with_object(Hash.new(0)) do |qup, hash|
      hash[qup["item_id"]] += (qup["quantity"] * qup["unit_price"])
    end
  end

  def item_ids_sold
    successful_invoice_items_qup.each_with_object(Hash.new(0)) do |qup, hash|
      hash[qup["item_id"]] += qup["quantity"]
    end
  end

end

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

end

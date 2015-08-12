require_relative 'general_repository'

class ItemRepository
  include GeneralRepository

  def table
    'items'
  end

  def instance_class(attributes, database)
    Item.new(attributes, database)
  end

  def find_by_description(query_description)
    db.execute("
    SELECT * FROM items WHERE description = '#{query_description}';
    ")
  end

end

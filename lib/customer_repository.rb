require_relative 'general_repository'
require_relative 'customer'

class CustomerRepository
  include GeneralRepository
  attr_reader

  def instance_class(attributes, database)
    Customer.new(attributes, database)
  end

  def find_all_by_first_name(name)
    name_data = db.execute("
    SELECT * FROM customers WHERE
    first_name = '#{name.downcase}' COLLATE NOCASE;
    ")
    name_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_by_first_name(name)
    name_data = db.execute("
    SELECT * FROM customers WHERE
    first_name = '#{name.downcase}' COLLATE NOCASE;
    ")[0]
    instance_class(name_data, db)
  end

  def find_all_by_last_name(name)
    name_data = db.execute("
    SELECT * FROM customers WHERE
    last_name = '#{name.downcase}' COLLATE NOCASE;
    ")
    name_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_by_last_name(name)
    name_data = db.execute("
    SELECT * FROM customers WHERE
    last_name = '#{name.downcase}' COLLATE NOCASE;
    ")[0]
    instance_class(name_data, db)
  end

  private

  def table
    'customers'
  end

end

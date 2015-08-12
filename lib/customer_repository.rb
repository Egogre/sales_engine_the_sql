require_relative 'general_repository'

class CustomerRepository
  include GeneralRepository
  attr_reader

  def table
    'customers'
  end

  def instance_class(attributes, database)
    Customer.new(attributes, database)
  end

  def find_all_by_first_name(name)
    db.execute("
    SELECT * FROM customers WHERE
    first_name = '#{name.downcase}' COLLATE NOCASE;
    ")
  end

  def find_all_by_last_name(name)
    db.execute("
    SELECT * FROM customers WHERE
    last_name = '#{name.downcase}' COLLATE NOCASE;
    ")
  end

end

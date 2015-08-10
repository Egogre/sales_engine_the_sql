require_relative 'general_repository'

class CustomerRepository
include GeneralRepository
attr_reader :customers_by_first_name, :customers_by_last_name

def find_all_by_first_name(name)
  customers_by_first_name[name]
end

def load_customer_searches
  @customers_by_first_name = csv_table.group_by do |customer|
    customer[:first_name]
  end
  @customers_by_last_name = csv_table.group_by do |customer|
    customer[:last_name]
  end
end

end

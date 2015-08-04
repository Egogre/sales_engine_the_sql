require_relative 'test_helper'

class DataInstanceTest < Minitest::Test
  def test_it_can_convert_symbol_to_instance_variable_name
    instance = DataInstance.new Hash.new(:id => "1"), nil

    assert_equal :@hello, instance.to_instance_var(:hello)
  end

  def test_it_knows_the_name_of_the_type_it_exhibits
    customer = Customer.new Hash.new(:id => "1"), "hello"

    assert_equal :customer, customer.type_name
  end

  def test_it_knows_reference_name
    item = Item.new Hash.new(:id => "1"), nil

    assert_equal :item_id, item.reference
  end

  def test_can_ask_what_refers_to_it
    engine = SalesEngine.new
    engine.startup
    invoice = engine.invoice_repository.find_by(:id, 4)
    transaction = engine.transaction_repository.find_by(invoice.reference, invoice.id)

    assert_equal "3", transaction.id
  end

  def test_can_ask_what_refers_to_it_using_method
    engine = SalesEngine.new
    engine.startup
    invoice = engine.invoice_repository.find_by(:id, 4)
    transaction = invoice.referred_by(engine.transaction_repository)

    assert_equal "3", transaction.id
  end
end

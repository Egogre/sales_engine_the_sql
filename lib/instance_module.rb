require 'sqlite3'
require 'bigdecimal'

module InstanceModule
  attr_reader :db, :attributes, :id, :created_at, :updated_at

  def initialize(attribute_data, database)
    @db = database
    @attributes = attribute_data
    @id = attribute_data["id"]
    @created_at = attribute_data["created_at"]
    @updated_at = attribute_data["updated_at"]
    assign_class_specific_attributes
  end

  def invoices
    invoice_list = db.execute("
    SELECT * FROM invoices WHERE #{id_column} = #{attributes["id"]};
    ")
    invoice_list.map {|invoice| Invoice.new(invoice, db)}
  end

end

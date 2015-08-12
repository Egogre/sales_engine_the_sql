require 'sqlite3'

module InstanceModule
  attr_reader :db, :attributes, :id, :created_at, :updated_at

  def initialize(attributes, database)
    @db = database
    @attributes = attributes
    @id = attributes["id"]
    @created_at = attributes["created_at"]
    @updated_at = attributes["updated_at"]
    assign_class_specific_attributes
  end

  def invoices
    invoice_list = db.execute("
    SELECT * FROM invoices WHERE #{id_column} = #{attributes["id"]};
    ")
    invoice_list.map {|invoice| Invoice.new(invoice, db)}
  end

end

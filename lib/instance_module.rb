require 'sqlite3'

module InstanceModule
  attr_reader :db, :attributes

  def initialize(attributes, database)
    @db = database
    @attributes = attributes
  end

  def invoices
    invoice_list = db.execute("
    SELECT * FROM invoices WHERE #{id_column} = #{attributes["id"]};
    ")
    invoice_list.map {|invoice| Invoice.new(invoice, db)}
  end

end

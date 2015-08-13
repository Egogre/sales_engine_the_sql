require 'sqlite3'
require 'bigdecimal'
require 'date'

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

  def successful_transaction_invoice_ids
    db.execute("
    SELECT invoice_id FROM transactions WHERE result = 'success';
    ").map {|row| row["invoice_id"]}
  end

  def successful_invoice_items_qup
    db.execute("
    SELECT * FROM invoice_items
    WHERE invoice_id IN (#{string_invoice_ids});
    ")
  end

  private

  def string_invoice_ids
    successful_transaction_invoice_ids.join(", ")
  end

end

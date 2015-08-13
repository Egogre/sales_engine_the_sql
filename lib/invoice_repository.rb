require_relative 'general_repository'
require_relative 'invoice'

class InvoiceRepository
  include GeneralRepository
  attr_reader :time

  def table
    'invoices'
  end

  def instance_class(attributes, database)
    Invoice.new(attributes, database)
  end

  def find_all_by_customer_id(query_id)
    invoice_data = db.execute("
    SELECT * FROM invoices WHERE customer_id = #{query_id};
    ")
    invoice_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_all_by_status(query_status)
    invoice_data = db.execute("
    SELECT * FROM invoices WHERE status = '#{query_status}';
    ")
    invoice_data.map do |instance_data|
      instance_class(instance_data, db)
    end
  end

  def find_by_status(query_status)
    invoice_data = db.execute("
    SELECT * FROM invoices WHERE status = '#{query_status}';
    ")[0]
    instance_class(invoice_data, db) if invoice_data
  end

  def create(*invoice_attributes)
    @time = Time.now.utc
    vals = [invoice_attributes[0][:customer].id,
            invoice_attributes[0][:merchant].id,
            "shipped",
            "#{time}",
            "#{time}"]
    db.execute("
    INSERT INTO invoices (#{invoice_columns}) VALUES (?,?,?,?,?);
    ", vals)
    create_invoice_items(invoice_attributes[0][:items])
    new_invoice_id = db.execute("SELECT * FROM invoices").count
    new_invoice_data = db.execute("SELECT * FROM invoices WHERE
                                   id = #{new_invoice_id};")[0]
    instance_class(new_invoice_data, db)
  end

  private

  def create_invoice_items(items)
    new_invoice_items = items.each_with_object(Hash.new(0)) do |item, hash|
      hash[item] += 1
    end
    new_invoice_items.to_a.each do |item|
      vals = [item[0].id,
              db.execute("SELECT * FROM invoices;").count,
              item[1],
              item[0].unit_price,
              "#{time}",
              "#{time}"]
      db.execute("
      INSERT INTO invoice_items (#{invoice_item_columns}) VALUES (?,?,?,?,?,?);
      ", vals)
    end
  end

  def invoice_columns
    'customer_id,
     merchant_id,
     status,
     created_at,
     updated_at'
  end

  def invoice_item_columns
    'item_id,
     invoice_id,
     quantity,
     unit_price,
     created_at,
     updated_at'
  end

end

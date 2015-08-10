require 'sqlite3'

module GeneralRepository
  attr_reader :db, :engine, :csv_table

  def initialize(csv_table, engine)
    @csv_table = csv_table
    @engine = engine
  end

  def all
    records
  end

  def random
    records.values.sample
  end

  def find_by_id(value)
    records[value]
  end

end

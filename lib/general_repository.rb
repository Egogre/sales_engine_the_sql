module GeneralRepository
  attr_reader :records, :engine, :csv_table

  def initialize(csv_table, engine)
    @csv_table = csv_table
    @records = csv_table.each_with_object({}) do |record, hash|
      hash[record[:id]] = record
    end
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

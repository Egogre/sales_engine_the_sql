module GeneralRepository
  attr_reader :records, :engine

  def initialize(csv_table, engine)
    @records = csv_table.each_with_object(Hash.new) do |record, hash|
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

end

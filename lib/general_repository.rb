require 'sqlite3'

module GeneralRepository
  attr_reader :db

  def initialize(database)
    @db = database
  end

  def all
    db.execute("SELECT * FROM #{table}")
  end

  def random
    @table_length ||= all.count
    random_id = rand(1..@table_length)
    db.execute("SELECT * FROM #{table} WHERE id = #{random_id}")
  end

  def find_by_id(value)
    db.execute("SELECT * FROM #{table} WHERE id = #{value}")
  end

end

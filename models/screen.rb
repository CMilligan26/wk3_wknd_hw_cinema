require_relative("../db/sql_runner")

class Screen

  attr_reader :id
  attr_accessor :cinema_location_id, :screen_number

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @cinema_location_id = options['cinema_location_id'].to_i
    @screen_number = options['screen_number']
  end

  #C

  def save()
    sql = "INSERT INTO screens (cinema_location_id, screen_number) VALUES ($1, $2) RETURNING id"
    values = [@cinema_location_id, @screen_number]
    screen = SqlRunner.run(sql, values).first
    @id = screen['id'].to_i
  end

  #R

  def self.all()
  sql = "SELECT * FROM screens"
  screens = SqlRunner.run(sql)
  return Screen.map_items(screens)
  end

  #U

  def update()
    sql = "UPDATE screens SET (cinema_location_id, screen_number) = ($1, $2) WHERE id = $3"
    values = [@cinema_location_id, @screen_number, @id]
    SqlRunner.run(sql, values)
  end

  #D

  def delete()
    sql = "DELETE * from screens where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM screens"
    SqlRunner.run(sql)
  end

  #MAP

  def self.map_items(screens)
   result = data.map{|screen| Screen.new(screen)}
   return result
  end

end

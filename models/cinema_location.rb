require_relative("../db/sql_runner")

class CinemaLocation

  attr_reader :id
  attr_accessor :city, :venue

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @city = options['city']
    @venue = options['venue']
  end

  #C

  def save()
    sql = "INSERT INTO cinema_locations (city, venue) VALUES ($1, $2) RETURNING id"
    values = [@city, @venue]
    cinema_location = SqlRunner.run(sql, values).first
    @id = cinema_location['id'].to_i
  end

  #R

  def self.all()
  sql = "SELECT * FROM cinema_locations"
  cinema_locations = SqlRunner.run(sql)
  return CinemaLocation.map_items(cinema_locations)
  end

  #U

  def update()
    sql = "UPDATE cinema_locations SET (city, venue) = ($1, $2) WHERE id = $3"
    values = [@city, @venue, @id]
    SqlRunner.run(sql, values)
  end

  #D

  def delete()
    sql = "DELETE FROM cinema_locations WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM cinema_locations"
    SqlRunner.run(sql)
  end

  #MAP

  def self.map_items(cinema_locations)
   result = cinema_locations.map{|cinema_location| CinemaLocation.new(cinema_location)}
   return result
  end

end

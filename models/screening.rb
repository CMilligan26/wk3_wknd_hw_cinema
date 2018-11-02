require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :film_id, :showing_time, :screen_id, :tickets_available

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @showing_time = options['showing_time']
    @screen_id = options['screen_id'].to_i
    @tickets_available = options['tickets_available']
  end

  #C

  def save()
    sql = "INSERT INTO screenings (film_id, showing_time, screen_id, tickets_available) VALUES ($1, $2, $3, $4) RETURNING id"
    values = [@film_id, @showing_time, @screen_id, @tickets_available]
    screening = SqlRunner.run(sql, values).first
    @id = screening['id'].to_i
  end

  #R

  def self.all()
  sql = "SELECT * FROM screenings"
  screenings = SqlRunner.run(sql)
  return Screening.map_items(screenings)
  end

  #U

  def update()
    sql = "UPDATE screenings SET (film_id, showing_time, screen_id, tickets_available) = ($1, $2, $3, $4) WHERE id = $5"
    values = [@film_id, @showing_time, @screen_id, @tickets_available, @id]
    SqlRunner.run(sql, values)
  end

  #D

  def delete()
    sql = "DELETE * from screenings where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  #UPDATE SELF FROM DATABASE
  def update_from_database()
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@id]
    data = SqlRunner.run(sql, values)
    new_data = Screening.map_items(data)
    @tickets_available = new_data.first.tickets_available.to_i
  end

  #MAP

  def self.map_items(screenings)
   result = screenings.map{|screening| Screening.new(screening)}
   return result
  end

end

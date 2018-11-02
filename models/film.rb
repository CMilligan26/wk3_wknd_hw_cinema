require_relative("../db/sql_runner")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  #C

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  #R

  def self.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return Film.map_items(films)
  end

  #U

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  #D

  def delete()
    sql = "DELETE * from films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  #MAP

  def self.map_items(films)
    result = films.map{|film| Film.new(film)}
    return result
  end

  def customers
    sql = "SELECT COUNT(*)
    FROM
    (
      SELECT customers.*
      FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      INNER JOIN screenings
      ON tickets.screening_id = screenings.id
      INNER JOIN films
      ON screenings.film_id = films.id
      WHERE film_id = $1
      ) alias;"
      values = [@id]
      return SqlRunner.run(sql, values).map{ |hash| hash['count']}.join.to_i
    end

    def popular_time
      sql = "SELECT screenings.showing_time
      FROM screenings
      INNER JOIN tickets
      ON tickets.screening_id = screenings.id
      WHERE screenings.film_id = $1
      GROUP BY screenings.showing_time
      ORDER BY COUNT(screenings.showing_time) DESC
      LIMIT 1;"
      values = [@id]
      return SqlRunner.run(sql, values).map{ |hash| hash['showing_time']}.join
    end

  end

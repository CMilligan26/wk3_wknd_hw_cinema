require_relative("../db/sql_runner")
require_relative("./film")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  #C

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  #R

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return Customer.map_items(customers)
  end

  #U

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  #D

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  #UPDATE SELF FROM DATABASE
  def update_from_database()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@id]
    data = SqlRunner.run(sql, values)
    new_data = Customer.map_items(data)
    @name = new_data.first.name
    @funds = new_data.first.funds.to_i
  end

  #MAP

  def self.map_items(customers)
    result = customers.map{|customer| Customer.new(customer)}
    return result
  end

  #Show films customer has tickets for

  def films
    sql = "
      SELECT films.*
      FROM films
      INNER JOIN screenings
      ON films.id = screenings.film_id
      INNER JOIN tickets
      ON screenings.id = tickets.screening_id
      WHERE customer_id = $1"
      values = [@id]
      films = SqlRunner.run(sql, values)
      return Film.map_items(films)
    end

  def count_tickets
    sql = "SELECT COUNT(*)
    FROM
    (
      SELECT films.*
      FROM films
      INNER JOIN screenings
      ON films.id = screenings.film_id
      INNER JOIN tickets
      ON screenings.id = tickets.screening_id
      WHERE customer_id = $1
      ) alias;"
      values = [@id]
      return SqlRunner.run(sql, values).map{ |hash| hash['count']}.join.to_i
    end

    #Not refactored, kept this to demonstrate how this can be done with sql, refactored films.

  end

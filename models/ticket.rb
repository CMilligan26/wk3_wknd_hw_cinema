require_relative("../db/sql_runner")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  #C

  def save()
    if get_available_tickets >= 1
    sql = "INSERT INTO tickets (customer_id, screening_id) VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @screening_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket['id'].to_i
    charge_customer
    sell_ticket
    end
  end

  #Update customer funds

  def get_film_price
    sql = "SELECT films.price
    FROM films
    INNER JOIN screenings
    ON films.id = screenings.film_id
    INNER JOIN tickets
    ON screenings.id = tickets.screening_id
    WHERE tickets.id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).map{ |hash| hash['price']}.join.to_i
  end

  def charge_customer
    sql = "SELECT customers.funds
          FROM customers
          WHERE customers.id = $1"
    values = [@customer_id]
    customer_funds = SqlRunner.run(sql, values).map{ |hash| hash['funds']}.join.to_i
    new_customer_funds = customer_funds -= get_film_price
    sql = "UPDATE customers SET funds = $1 WHERE id = $2"
    values = [new_customer_funds, @customer_id]
    SqlRunner.run(sql, values)
  end

  #Get available tickets

  def get_available_tickets
    sql = "SELECT screenings.tickets_available
    FROM screenings
    WHERE screenings.id = $1"
    values = [@screening_id]
    return SqlRunner.run(sql, values).map{ |hash| hash['tickets_available']}.join.to_i
  end

  def sell_ticket
    new_available_tickets = get_available_tickets-1
    sql = "UPDATE screenings SET tickets_available = $1 WHERE id = $2"
    values = [new_available_tickets, @screening_id]
    SqlRunner.run(sql, values)
  end

  #R

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return Ticket.map_items(tickets)
  end

  #U

  def update()
    sql = "UPDATE tickets SET (customer_id, screening_id) = ($1, $2) WHERE id = $3"
    values = [@customer_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  #D

  def delete()
    sql = "DELETE * from tickets where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  #MAP

  def self.map_items(tickets)
    result = tickets.map{|ticket| Ticket.new(ticket)}
    return result
  end

end

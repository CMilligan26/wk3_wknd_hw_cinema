require_relative("./models/cinema_location")
require_relative("./models/customer")
require_relative("./models/film")
require_relative("./models/screen")
require_relative("./models/screening")
require_relative("./models/ticket")

require('pry-byebug')

#Delete

Ticket.delete_all()
Screening.delete_all()
Screen.delete_all()
Film.delete_all()
Customer.delete_all()
CinemaLocation.delete_all()

#Create

cinema_location1 = CinemaLocation.new({'city' => 'Twin Peaks', 'venue' => 'Roadhouse'})
cinema_location2 = CinemaLocation.new({'city' => 'Twin Peaks', 'venue' => 'The Great Northern'})

cinema_location1.save
cinema_location2.save

customer1 = Customer.new({'name' => 'Dale Cooper', 'funds' => 50})
customer2 = Customer.new({'name' => 'Audrey Horne', 'funds' => 100})

customer1.save
customer2.save

film1 = Film.new({'title' => 'Sunset Boulevard', 'price' => 10})
film2 = Film.new({'title' => 'Laura', 'price' => 6})

film1.save
film2.save

screen1 = Screen.new({'cinema_location_id' => cinema_location1.id, 'screen_number' => 1})
screen2 = Screen.new({'cinema_location_id' => cinema_location2.id, 'screen_number' => 1})

screen1.save
screen2.save

screening1 = Screening.new({'film_id' => film1.id, 'showing_time' => '2018-11-11 14:30:00', 'screen_id' => screen1.id, 'tickets_available' => 12})
screening2 = Screening.new({'film_id' => film1.id, 'showing_time' => '2018-11-11 18:30:00', 'screen_id' => screen1.id, 'tickets_available' => 12})
screening3 = Screening.new({'film_id' => film2.id, 'showing_time' => '2018-11-13 20:30:00', 'screen_id' => screen2.id, 'tickets_available' => 8})

screening1.save
screening2.save
screening3.save

ticket1 = Ticket.new({'customer_id' => customer1.id, 'screening_id' => screening1.id})
ticket2 = Ticket.new({'customer_id' => customer1.id, 'screening_id' => screening2.id})
ticket3 = Ticket.new({'customer_id' => customer2.id, 'screening_id' => screening2.id})
ticket4 = Ticket.new({'customer_id' => customer2.id, 'screening_id' => screening3.id})

ticket1.save
ticket2.save
ticket3.save
ticket4.save


#Update

# customer1.name = "Leland Palmer"
# customer1.update

#Delete one

# customer1.delete

#customers_tickets



#films_customers



#count_tickets



#count_customers



#popular_time



#Update from database

customer1.update_from_database
customer2.update_from_database

screening1.update_from_database
screening2.update_from_database
screening3.update_from_database

binding.pry
nil

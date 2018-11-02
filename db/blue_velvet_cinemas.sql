DROP TABLE IF EXISTS tickets_booked;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS screens;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS cinema_locations;


CREATE TABLE cinema_locations (
  id SERIAL4 PRIMARY KEY,
  city TEXT,
  venue TEXT
);

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name TEXT,
  funds INT4
);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title TEXT,
  price INT4
);

CREATE TABLE screens (
  id SERIAL4 PRIMARY KEY,
  cinema_location_id INT4 REFERENCES cinema_locations(id) ON DELETE CASCADE,
  screen_number INT4
);

CREATE TABLE screenings (
  id SERIAL4 PRIMARY KEY,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
  showing_time TIMESTAMP,
  screen_id INT4 REFERENCES screens(id) ON DELETE CASCADE,
  tickets_available INT4
);

CREATE TABLE tickets_booked (
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
  screening_id INT4 REFERENCES screenings(id) ON DELETE CASCADE
);

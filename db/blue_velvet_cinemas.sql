CREATE TABLE cinema_locations (
  id SERIAL4 PRIMARY KEY,
  city TEXT,
  venue TEXT
);

CREATE TABLE customer (
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

);

-- Boolean data type
-- TRUE FALSE,'true' 'false','t' 'f','y' 'n','yes' 'no','1' '0'
CREATE TABLE table_boolean(
	product_id SERIAL PRIMARY KEY,
	is_available BOOLEAN NOT NULL
);

INSERT INTO table_boolean (is_available) VALUES (FALSE);
INSERT INTO table_boolean (is_available) VALUES ('true');
INSERT INTO table_boolean (is_available) VALUES ('false');
INSERT INTO table_boolean (is_available) VALUES ('t');
INSERT INTO table_boolean (is_available) VALUES ('f');
INSERT INTO table_boolean (is_available) VALUES ('y');
INSERT INTO table_boolean (is_available) VALUES ('n');
INSERT INTO table_boolean (is_available) VALUES ('yes');
INSERT INTO table_boolean (is_available) VALUES ('no');
INSERT INTO table_boolean (is_available) VALUES ('1');
INSERT INTO table_boolean (is_available) VALUES ('0');

SELECT * FROM table_boolean WHERE is_available = TRUE;
SELECT * FROM table_boolean WHERE is_available = 'true';
SELECT * FROM table_boolean WHERE is_available = 'yes';
SELECT * FROM table_boolean WHERE is_available = 'y';
SELECT * FROM table_boolean WHERE is_available = 't';
SELECT * FROM table_boolean WHERE is_available = '1';
SELECT * FROM table_boolean WHERE is_available = 'no';
SELECT * FROM table_boolean WHERE is_available;

-- Character Data types char,varchar,text
-- char(10) if 8 char provided then postgresql adds the spaces to fulfill.
SELECT CAST('Adnan' AS character(10)) as "Name";
SELECT 'Adnan'::char(10) AS "Name";
SELECT 'Adnan'::varchar(10);
SELECT 'THIS IS A TEST FROM THE SYSTEM'::varchar(10);
SELECT 'THIS IS  A VERY VERY LONG TEXT'::text;
CREATE TABLE table_characters(
	col_char CHAR(10),
	col_varchar VARCHAR(10),
	col_text TEXT
);
INSERT INTO table_characters(col_char,col_varchar,col_text)
VALUES('ABC','ABC','ABC');
SELECT * FROM table_characters;

-- Numbers data types Integers(smallint,integer,bigint) and Floating point
-- Auto increament integer data type:SERIAL(smallserial,serial,bigserial)
CREATE TABLE table_serial(
product_id SERIAL,
product_name VARCHAR(100)
);
INSERT INTO table_serial (product_name) VALUES ('pen');
INSERT INTO table_serial (product_name) VALUES ('pencil');
SELECT * FROM table_serial;

CREATE TABLE table_numbers(
	col_numeric numeric(20,5),
	col_real real,
	col_double double precision
);
INSERT INTO table_numbers(col_numeric,col_real,col_double) 
VALUES
(.8,.8,.8),
(3.13577,3.13577,3.13577),
(4.1357087654,4.1357087654,4.1357087654);
SELECT * FROM table_numbers;

-- Date/Time data types Date,Time,Timestamp,Timestamptz,Interval
-- Date
CREATE TABLE dates(
id SERIAL PRIMARY KEY,
	employee_name VARCHAR(100) NOT NULL,
	hire_date DATE NOT NULL,
	add_date DATE DEFAULT CURRENT_DATE
);
INSERT INTO dates (employee_name,hire_date) VALUES ('ADAM','2020-01-01'),
('LINDA','2020-02-02');
SELECT CURRENT_DATE;
SELECT NOW();
SELECT * FROM dates;

-- Time
CREATE TABLE table_time(
	id SERIAL PRIMARY KEY,
	class_name VARCHAR(100) NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL
);
INSERT INTO table_time (class_name,start_time,end_time)
VALUES
('MATH','04:00:00','04:00:00'),
('CHEMISTRY','06:01:00','07:00:00');
SELECT CURRENT_TIME;
SELECT CURRENT_TIME(4);
SELECT LOCALTIME;
SELECT * FROM table_time;

-- Timestamp and Timestamptz
CREATE TABLE table_time_tz(
ts TIMESTAMP,
tstz TIMESTAMPTZ
);

INSERT INTO table_time_tz (ts,tstz) VALUES
('2020-02-22 10:10:10-07','2020-02-22 10:10:10-07');
SHOW TIMEZONE;

SELECT * FROM table_time_tz;


-- UUID data type
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SELECT uuid_generate_v1();
SELECT uuid_generate_v4();

CREATE TABLE table_uuid(
	product_id UUID DEFAULT uuid_generate_v1(),
	product_name VARCHAR(100) NOT NULL
);

INSERT INTO table_uuid (product_name) VALUES ('ABC1');
INSERT INTO table_uuid (product_name) VALUES ('ABC2');

SELECT * FROM table_uuid;


-- Array data types
CREATE TABLE table_array(
	id SERIAL,
	name VARCHAR(100),
	phones TEXT []
);

INSERT INTO table_array(name,phones) 
VALUES('Adam',ARRAY['(801)-123-4567','(812)-555-2222']);
INSERT INTO table_array(name,phones) 
VALUES('Linda',ARRAY['(201)-123-4567','(214)-222-3333']);

SELECT name,phones[1] FROM table_array;
SELECT name FROM table_array WHERE phones[2] = '(214)-222-3333';

-- hstore data type store data in key pair
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE TABLE table_hstore(
	book_id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	book_info hstore
);
INSERT INTO table_hstore (title,book_info) VALUES(
	'TITLE 1',
	'
		"publisher" => "ABC publisher",
		"paper_cost" => "10.00",
		"e_cost" => "5.85"
	'
);
INSERT INTO table_hstore (title,book_info) VALUES(
	'TITLE 2',
	'
		"publisher" => "ABC publisher2",
		"paper_cost" => "20.00",
		"e_cost" => "10.85"
	'
);
SELECT book_info -> 'publisher' AS "publisher" FROM table_hstore;

SELECT * FROM table_hstore;

-- JSON data type
CREATE TABLE table_json(
	id SERIAL PRIMARY KEY,
	docs JSON
);

INSERT INTO table_json (docs) VALUES
('[1,2,3,4,5,6]'),
('[2,3,4,5,6,7]'),
('{"key":"value"}');

SELECT docs FROM table_json;
SELECT * FROM table_json WHERE docs @> '2';
ALTER TABLE table_json ALTER COLUMN docs TYPE JSONB;
CREATE INDEX ON table_json USING GIN (docs jsonb_path_ops);

-- Network Address Data Type like cidr,inet,macaddr,macaddr8,inet
CREATE TABLE table_netaddr(
	id SERIAL PRIMARY KEY,
	ip INET
);
INSERT INTO table_netaddr (ip) VALUES
('4.35.221.243'),
('4.152.207.126'),
('4.152.207.238'),
('4.24.111.162'),
('12.1.223.132');

SELECT ip,set_masklen(ip,24) as inet_24 FROM table_netaddr;
SELECT 
ip,
set_masklen(ip,24) as inet_24,
set_masklen(ip::cidr,24) as cidr_24
FROM table_netaddr;
SELECT * FROM table_netaddr;



























-- User defined data type
-- Create addr user defined data type
CREATE DOMAIN addr VARCHAR(100) NOT NULL;
CREATE TABLE locations(
	address addr
);
INSERT INTO locations VALUES ('123 London');
SELECT * from locations;

-- Create positive numeric domain with a positive numberic i.e >0
CREATE DOMAIN positive_numeric INT NOT NULL CHECK (VALUE > 0);
CREATE TABLE sample(
	sample_id SERIAL PRIMARY KEY,
	value_num positive_numeric
);
INSERT INTO sample (value_num) VALUES (-10);
SELECT * FROM sample;


-- US postal code domain to check for valid us postal code format
CREATE DOMAIN us_postal_code AS TEXT 
CHECK(VALUE ~'^\d{5}$' OR VALUE ~'^\D{5}-\d{4}$');
CREATE TABLE addresses(
	address_id SERIAL PRIMARY KEY,
	postal_code us_postal_code
);
INSERT INTO addresses (postal_code) VALUES ('10000-10');
SELECT * FROM addresses;


-- Proper email domain to check for a valid email address
CREATE DOMAIN proper_email VARCHAR(150) 
CHECK (VALUE ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
CREATE TABLE clients_names(
	client_name_id SERIAL PRIMARY KEY,
	email proper_email
);
INSERT INTO clients_names (email) VALUES ('m ahesh@gmail.com');
SELECT * FROM clients_names;

-- Create an Enumeration Type (Enum or Set of Values) domain
CREATE DOMAIN valid_color VARCHAR(10)
CHECK (VALUE IN ('red','green','blue'))

CREATE TABLE colors (
	color valid_color
);
INSERT INTO colors (color) VALUES ('orange');
SELECT * FROM colors;

-- Get all domain in a schema
SELECT typname 
FROM pg_catalog.pg_type
JOIN pg_catalog.pg_namespace
ON pg_namespace.oid = pg_type.typnamespace
WHERE
typtype = 'd' and nspname = 'public';

-- Drop a Domain data type
DROP DOMAIN positive_numeric;
DROP DOMAIN positive_numeric CASCADE;

-- Create a address composite data type
CREATE TYPE address AS (
	city VARCHAR(50),
	country VARCHAR(20)
);

CREATE TABLE companies (
	comp_id SERIAL PRIMARY KEY,
	address address
);
INSERT INTO companies (address) VALUES (ROW('LONDON','UK'));
SELECT (address).country FROM companies;

-- Create a composite inventory item data type
CREATE TYPE inventory_item AS (
	product_name varchar(200),
	supplier_id INT,
	price NUMERIC
);
CREATE TABLE inventory(
	inventory_id SERIAL PRIMARY KEY,
	item inventory_item
);
INSERT INTO inventory (item) VALUES (ROW('pen',10,4.88));
SELECT * FROM inventory;

-- Create a currency ENUM data type with currency data
CREATE TYPE currency AS ENUM ('USD','EUR','GBP');
SELECT 'USD'::currency;
ALTER TYPE currency ADD VALUE 'CHF' AFTER 'EUR';

CREATE TABLE stocks(
	stock_id SERIAL PRIMARY KEY,
	stock_currency currency
);
INSERT INTO stocks (stock_currency) VALUES ('USD');
SELECT * FROM stocks;

-- Drop type name
CREATE TYPE sample_type AS ENUM ('ABC','123');
DROP TYPE sample_type;

-- Alter data types
CREATE TYPE myaddress AS (
	city VARCHAR(50),
	COUNTRY varchar(20)
);
ALTER TYPE myaddress OWNER TO postgres;

-- Alter enum data type
CREATE TYPE mycolors AS ENUM ('green','red','blue');
ALTER TYPE mycolors RENAME VALUE 'red' TO 'orange';

-- List all ENUM values
SELECT enum_range(NULL::mycolors);
ALTER TYPE mycolors ADD VALUE 'red' BEFORE 'green';

-- Update an ENUM on prod
CREATE TYPE status_enum AS enum ('queued','waiting','running','done');
CREATE TABLE jobs(
	job_id SERIAL PRIMARY KEY,
	job_status status_enum
);
INSERT INTO jobs (job_status) VALUES 
('queued'),('waiting'),('running'),('done');

UPDATE jobs SET job_status = 'running' WHERE job_status = 'waiting';
ALTER TYPE status_enum RENAME TO status_enum_old;
CREATE TYPE status_enum AS enum ('queued','running','done');
ALTER TABLE jobs ALTER COLUMN job_status TYPE status_enum 
USING job_status::text::status_enum;
Select * from jobs;

-- An ENUM with a default value in a table
CREATE TYPE demostatus AS ENUM ('pending','approved','declined');
CREATE TABLE cron_jobs(
	cron_job_id INT,
	status demostatus DEFAULT 'pending'
);
INSERT INTO cron_jobs (cron_job_id,status) VALUES (4,'approved');
SELECT * FROM cron_jobs;







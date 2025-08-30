-- CREATE sample table
CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(150),
	age INT
);


-- Insert single data
INSERT INTO customers (first_name,last_name,email,age)
values ('Adnan','waheed','a@b.com',40);

-- Insert multiple data
INSERT INTO customers(first_name,last_name)
values
('ADNAN','WAHEED'),
('JOHN','ADAMS'),
('LINDA','ABE');

-- Insert data containng quote
INSERT INTO customers (first_name)
VALUES ('Bill''O Sullivan');

-- First see the default behaviour when adding a record into9 a table
INSERT INTO customers (first_name)
VALUES ('ADAM');

-- After the insert, lets returns all rows
INSERT INTO customers (first_name)
VALUES ('JOSEPH') RETURNING *;

-- Update single column
UPDATE customers SET email='a2@b.com' where customer_id=1;

-- Update multiple columns
UPDATE customers SET email='a4@b.com',age=30 where customer_id=1;

-- Use RETURNING to get updated rows
UPDATE customers SET email='a@b.com' where customer_id=3 RETURNING *;

-- Update all records in a table
UPDATE customers SET is_enabled='Y' WHERE customer_id = 1;
UPDATE customers SET is_enabled = 'Y';


-- To delete records based on a condition
DELETE FROM customers WHERE customer_id=9;

-- To delete without condition
DELETE FROM customers;

-- UPSERT
-- Create sample table 

CREATE TABLE t_tags(
	id SERIAL PRIMARY KEY,
	tag TEXT UNIQUE,
	update_date TIMESTAMP DEFAULT NOW()
);

-- Insert some sample data
INSERT INTO t_tags (tag) VALUES ('Pen'),('Pencil');

-- Lets insert a record, on conflict do nothing
INSERT INTO t_tags (tag) VALUES ('Pen') ON CONFLICT (tag) DO NOTHING;
INSERT INTO t_tags (tag) VALUES ('Pen')
ON CONFLICT (tag) DO UPDATE SET tag = EXCLUDED.tag,update_date = NOW();

SELECT * from t_tags;









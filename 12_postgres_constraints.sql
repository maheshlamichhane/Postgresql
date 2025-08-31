-- NOT NULL constraints
CREATE TABLE table_nn(
	id SERIAL PRIMARY KEY,
	tag TEXT NOT NULL
);
SELECT * FROM table_nn;
INSERT INTO table_nn (tag) VALUES (null);
INSERT INTO table_nn (tag) VALUES ('');

-- UNIQUE constraints
CREATE TABLE table_emails (
	id SERIAL PRIMARY KEY,
	emails text UNIQUE
);
INSERT INTO table_emails  (emails) VALUES  ('A@B.COM');
SELECT * FROM table_emails;

CREATE TABLE table_products(
	id SERIAL PRIMARY KEY,
	product_code VARCHAR (10),
	product_name text
);
ALTER TABLE table_products ADD CONSTRAINT myunique
UNIQUE (product_code,product_name); 

INSERT INTO table_products (product_code,product_name)
VALUES ('A','apple');
SELECT * FROM table_products;

-- Default constraints
CREATE TABLE employees(
	employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	is_enabled VARCHAR(2) DEFAULT 'Y'
);ß
INSERT INTO employees (first_name,last_name) VALUES ('HARI','SHYAM');
ALTER TABLE employees ALTER COLUMN is_enabled SET DEFAULT 'N';
ALTER TABLE employees ALTER COLUMN is_enabled DROP DEFAULT;
SELECT * FROM employees;

-- Primary Key Constraint on single column
CREATE TABLE table_items(
	item_id INTEGER PRIMARY KEY,
	item_name VARCHAR(100) NOT NULL
);
INSERT INTO table_items (item_id,item_name) VALUES (1,'PEN');
INSERT INTO table_items (item_id,item_name) VALUES (null,'PEN');
INSERT INTO table_items (item_id,item_name) VALUES (2,'PEN');
ALTER TABLE table_items DROP CONSTRAINT caname;
ALTER TABLE table_items ADD PRIMARY KEY (item_id);
SELECT * FROM table_items;


-- Primary Key Constraint on multiple column
CREATE TABLE t_grades(
	course_id VARCHAR(100) NOT NULL,
	student_id VARCHAR(100) NOT NULL,
	grade int NOT NULL,
	PRIMARY KEY (course_id,student_id)
);
INSERT INTO t_Grades (course_id,student_id,grade) VALUES
('MATH','S2',50),
('CHEMISTRY','S1',70),
('ENGLISH','S2',70),
('PHYSICS','S1',80);
ALTER TABLE t_grades 
ADD CONSTRAINT t_gradescourse_id_session_id_pkey 
PRIMARY KEY (course_id,student_id);
SELECT * FROM t_grades;


-- Foreign Key Constraint
CREATE TABLE t_products(
	proudct_id INT PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	supplier_id INT NOT NULL,
	FOREIGN KEY (supplier_id) REFERENCES t_suppliers(supplier_id)
);
INSERT INTO t_products (proudct_id,product_name,supplier_id)
VALUES (1,'PEN',1),
(2,'PAPER',2);
SELECT * from t_products;


CREATE TABLE t_suppliers(
	supplier_id INT PRIMARY KEY,
	supplier_name VARCHAR(100) NOT NULL
); 
INSERT INTO t_suppliers(supplier_id,supplier_name) VALUES
(1,'SUPPLIER 1'),
(2,'SUPPLIER 2');
SELECT * FROM t_suppliers;

-- How to drop a constraint
ALTER TABLE tablename DROP CONSTRAINT cname;

-- Update foreign key constraint on an existing table
 ALTER TABLE tablename ADD CONSTRAINT canem FOREIGN KEY (columnname)
 REFERENCES table2_name (columnname);

 -- CHECK constraint
CREATE TABLE staff(
	staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	birth_date DATE CHECK (birth_date > '1800-01-01'),
	joined_date DATE CHECK (joined_date > birth_date),
	salary numeric CHECK (salary > 0)
);
INSERT INTO staff (first_name,last_name,birth_date,joined_date,salary)
VALUES ('ADAM','KING','1888-01-01','2002-02-02',100);
SELECT * FROM staff;




 














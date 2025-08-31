-- Create a sequence
CREATE SEQUENCE IF NOT EXISTS test_seq;
SELECT nextval('test_seq');
SELECT currval('test_seq');
SELECT setval('test_seq',100);
SELECT setval('test_seq',200,false);
CREATE SEQUENCE IF NOT EXISTS test_seq2 START WITH 100;
CREATE SEQUENCE IF NOT EXISTS test_seq3 
INCREMENT 50 MINVALUE 400 MAXVALUE 6000 START WITH 500;
SELECT nextval('test_seq3');

-- Alter a sequence
SELECT nextval('test_seq');
ALTER SEQUENCE test_seq RESTART WITH 100;
ALTER SEQUENCE test_seq RENAME TO my_sequence4;

-- Specify data type for sequence
CREATE SEQUENCE IF NOT EXISTS test_seq_smallint AS SMALLINT
CREATE SEQUENCE IF NOT EXISTS test_seq_smallint AS INT

-- Create a descending sequence and CYCLE | NO CYCLE
CREATE SEQUENCE seq_asc;
SELECT nextval('seq_asc');
CREATE SEQUENCE seq_des INCREMENT -1 MINVALUE 1 MAXVALUE 3 START 3 CYCLE;
SELECT nextval('seq_des');
CREATE SEQUENCE seq_des2 INCREMENT -1 MINVALUE 1 MAXVALUE 3 START 3 NO CYCLE;
SELECT nextval('seq_des2');

-- Drop sequence
DROP SEQUENCE test_seq3;

-- Attach sequence to a column
CREATE TABLE users(
	user_id INT PRIMARY KEY,
	user_name VARCHAR(50)
);
CREATE SEQUENCE user_id_seq START WITH 100 OWNED BY users.user_id;
ALTER TABLE users ALTER COLUMN user_id SET DEFAULT nextval('user_id_seq');
INSERT INTO users (user_name) VALUES ('mahesh2');
SELECT * FROM users;

-- List all sequence 
SELECT relname sequence_name FROM pg_class WHERE relkind='S';

-- Share sequence among multiple tables
CREATE SEQUENCE common_fruits_seq START WITH 100;
CREATE TABLE apples(
	fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
	fruit_name VARCHAR(50)
);
CREATE TABLE mangoes(
	fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
	fruit_name VARCHAR(50)
);
INSERT INTO apples (fruit_name) VALUES ('big apples');
SELECT * FROM apples;
INSERT INTO mangoes (fruit_name) VALUES ('big mangoes');
SELECT * FROM mangoes;

-- Create alphanumeric sequence
CREATE SEQUENCE table_seq;
CREATE TABLE contacts(
	contact_id TEXT NOT NULL DEFAULT ('ID' || nextval('table_seq')),
	contact_name VARCHAR(150)
);
INSERT INTO contacts (contact_name) VALUES ('HARI');
SELECT * FROM contacts;


















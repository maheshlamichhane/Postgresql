-- Table Partitioning
-- Partitioning is a splitting one table into multiple smaller,logically divided and more manageable pieces tables.
-- Partition leads to a huge performance boost
-- Partitioned tables can improve query performance by allowing the db query optimizer to scan only the data neede to satisfy a given query instead of scanning all the contents of large table.
-- use only for several million of data or if query execution time is slow.


-- Table Inheritance
-- Inheritance is an object oriented concept when a subclass inherits the properties. ofits parent class.
-- In PostgresSQL, a table inherits from its parent table
-- An example : master -> master_child

CREATE TABLE master(
	pk INTEGER PRIMARY KEY,
	tag TEXT,
	parent INTEGER
);
CREATE TABLE master_child() INHERITS (master);
ALTER TABLE master_child ADD CONSTRAINT master_pk PRIMARY KEY (pk);

-- lets see effect of insert
INSERT INTO master (pk,tag,parent) VALUES
(1,'pen',0);
INSERT INTO master_child (pk,tag,parent) VALUES
(2,'pencil',0);

SELECT * FROM master;
SELECT * FROM master_child;

-- FOR ONLY
SELECT * FROM ONLY master;
SELECT * FROM ONLY master_child;

-- when inserted in master that data won't be stored in child. but when data is inserted into child then that will be shown in parent without for only.


-- lets see effect of updates
UPDATE  master
SET tag = 'monitor'
WHERE pk = 2;
SELECT * FROM master;
SELECT * FROM master_child;
-- when master is updated for data inserted through child is also updated. here child update is permanent.
SELECT * FROM ONLY master;
SELECT * FROM ONLY master_child;

-- lets see effect of delete
DELETE FROM master WHERE pk=2;
SELECT * FROM master;
SELECT * FROM master_child;

SELECT * FROM ONLY master;
SELECT * FROM ONLY master_child;
-- here data inserted from child is deleted from parent then child data also deleted.

-- Droping master table
DROP TABLE master CASCADE;



-- Types of partitions
-- 1. Range:-> The table is partitioned into ranges defined by a key column or set of columns,with no overlap between the ranges of values assigned to different partitions.
-- 2. List:-> The table is partitioned by explicitly listing which key values appear in each partition.
-- 3. Hash:-> The table is partitioned by specifying a modulues and a reminder for each partition.

-- Partition by Range
-- lets create the master table 'employees_range'
CREATE TABLE employees_range(
	id bigserial,
	birth_date DATE NOT NULL,
	country_code VARCHAR(2) NOT NULL
) PARTITION BY RANGE (birth_date);

 -- lets create partition1 table 
 CREATE TABLE employees_range_y2000 PARTITION OF employees_range
 FOR VALUES FROM ('2000-01-01') TO ('2001-01-01');
 SELECT * FROM employees_range_y2000;
-- lets create partition2 table 
CREATE TABLE employees_range_y2001 PARTITION OF employees_range
 FOR VALUES FROM ('2001-01-01') TO ('2002-01-01');
 SELECT * FROM employees_range_y2001;

 -- lets insert some data into master
 INSERT INTO employees_range (birth_date,country_code)
 VALUES
 ('2000-01-01','US'),
 ('2000-01-01','US'),
 ('2000-01-02','US'),
 ('2000-12-31','US'),
 ('2001-01-01','US');

SELECT * FROM employees_range;
SELECT * FROM ONLY employees_range;
SELECT * FROM employees_range_y2000;
SELECT * FROM employees_range_y2001;

-- lets perform update move one table data to another by update
UPDATE employees_range
SET birth_date = '2001-10-10'
WHERE id=1;

-- DELETE operations
DELETE FROM employees_range WHERE id=1;

-- QUERY Plannings
-- In below query we did not specify where condition so postgres doesn't know which partition to scan so it scans all partitions. This is same as un-partitioned tables, as the query is not using any parition.
SELECT * FROM employees_range;

SELECT * FROM employees_range WHERE birth_date = '2000-01-02';
-- Now when we used where clause the postgres directly access the partition table emp_range_y2000


-- Partition by List 
CREATE TABLE employee_list(
	id bigserial,
	birth_date DATE NOT NULL,
	country_code VARCHAR(2) NOT NULL
)PARTITION BY LIST (country_code);

CREATE TABLE employees_list_us PARTITION OF employee_list
FOR VALUES IN ('US');
CREATE TABLE employees_list_eu PARTITION OF employee_list
FOR VALUES IN ('UK','DE','IT','FR','ES');

INSERT INTO employee_list (id,birth_date,country_code) VALUES
(1,'2000-01-01','US'),
(2,'2000-01-02','US'),
(3,'2000-12-31','UK'),
(4,'2001-01-01','DE');

SELECT * FROM employee_list;
SELECT * FROM ONLY employee_list;
SELECT * FROM employees_list_us;
SELECT * FROM employees_list_eu;

-- Update operations
UPDATE employee_list
SET country_code = 'US'
WHERE id = 4;

-- lets see DELETE operations
DELETE FROM employee_list WHERE id = 2;

-- lets visualize the query in pgadmin explain to see how the queries run
SELECT * FROM employee_list; -- here postgresql search all 2 child tables

SELECT * FROM employee_list WHERE country_code = 'US'; -- it only scans us table only


-- Partition by Hash
-- it is used when we are unable to classify data logically.
CREATE TABLE employees_hash(
	id bigserial,
	birth_date DATE NOT NULL,
	country_code VARCHAR(2) NOT NULL
) PARTITION BY HASH(id);

CREATE TABLE employees_hash_1 PARTITION OF employees_hash
FOR VALUES WITH (MODULUS 3, REMAINDER 0);
CREATE TABLE employees_hash_2 PARTITION OF employees_hash
FOR VALUES WITH (MODULUS 3, REMAINDER 1);
CREATE TABLE employees_hash_3 PARTITION OF employees_hash
FOR VALUES WITH (MODULUS 3, REMAINDER 2);

SELECT * FROM employees_hash;
SELECT * FROM employees_hash_1;
SELECT * FROM employees_hash_2;
SELECT * FROM employees_hash_3;

-- lets review insert operations
INSERT INTO employees_hash(id,birth_date,country_code) VALUES
(1,'2000-01-01','US'),
(2,'2000-01-02','US'),
(3,'2000-12-31','UK');

-- lets review update operations
UPDATE employees_hash
SET country_code='US'
WHERE id=3;

-- lets review delete operations
DELETE FROM employees_hash WHERE id=2;

-- lets visualize the query
SELECT * FROM employees_hash;
SELECT * FROM employees_hash WHERE country_code = 'US';

-- DEFAULT PARTITION
-- What happens when you try to insert a record that can't fit into any partition?
INSERT INTO employee_list (id,birth_date,country_code) VALUES
(10,'2001-01-01','JP'); -- error

CREATE TABLE employees_list_default PARTITION OF employee_list DEFAULT;
INSERT INTO employee_list (id,birth_date,country_code) VALUES
(10,'2001-01-01','JP');
SELECT * FROM employees_list_default;


-- Sub Partitioning
-- A single partition can also be a partitioned table.

-- lets create a new fresh master table
CREATE TABLE employees_master(
	id bigserial,
	birth_date DATE NOT NULL,
	country_code VARCHAR(2) NOT NULL
) PARTITION BY LIST (country_code);

CREATE TABLE employees_master_us PARTITION OF employees_master
FOR VALUES IN ('US');

CREATE TABLE employees_master_eu PARTITION OF employees_master
FOR VALUES IN ('UK','DE','IT','FR','ES') PARTITION BY HASH (id);

-- create sub partition
CREATE TABLE employees_master_eu_1 PARTITION OF employees_master_eu
FOR VALUES WITH (MODULUS 3,REMAINDER 0);
CREATE TABLE employees_master_eu_2 PARTITION OF employees_master_eu
FOR VALUES WITH (MODULUS 3,REMAINDER 1);
CREATE TABLE employees_master_eu_3 PARTITION OF employees_master_eu
FOR VALUES WITH (MODULUS 3,REMAINDER 2);

-- insert data
INSERT INTO employees_master (id,birth_date,country_code) VALUES
(1,'2000-01-01','US'),
(2,'2000-01-02','US'),
(3,'2000-12-31','UK'),
(4,'2001-01-01','DE');

SELECT * FROM employees_master;
SELECT * FROM ONLY employees_master;
SELECT * FROM employees_master_us;
SELECT * FROM employees_master_eu;
SELECT * FROM ONLY employees_master_eu;
SELECT * FROM employees_master_eu_1;
SELECT * FROM employees_master_eu_2;
SELECT * FROM employees_master_eu_3;

-- Partition maintenance
-- Attach partition
CREATE TABLE employees_list_sp PARTITION OF employee_list
FOR VALUES IN ('SP');

INSERT INTO employee_list (id,birth_date,country_code) 
VALUES (10,'2020-01-01','SP');

SELECT * FROM employees_list_sp;

-- Detach partition
ALTER TABLE employee_list DETACH PARTITION employees_list_sp;


-- Altering the bounds of a partition
CREATE TABLE t1(a int,b int) PARTITION BY RANGE(a);
CREATE TABLE t1p1 PARTITION OF t1 FOR VALUES FROM (0) to (100);
CREATE TABLE t1p2 PARTITION OF t1 FOR VALUES FROM (200) to (300);

INSERT INTO t1 (a,b) VALUES (1,1);
INSERT INTO t1 (a,b) VALUES (150,150);

rollback;
BEGIN TRANSACTION;
ALTER TABLE t1 DETACH partition t1p1;
ALTER TABLE t1 ATTACH PARTITION t1p1 VALUES FROM (0) TO (200);
COMMIT TRANSACTION;

SELECT * FROM t1;
SELECT * FROM t1p1;
SELECT * FROM t1p2;



-- Partition Indexing
-- Creating an index on the master/parent table will automatically create same indexes to every attached partition

-- Lets create an index on employee_list parent table with parent key id only
CREATE UNIQUE INDEX idx_uniq_employees_list_id_country_code 
ON employee_list(id,country_code);
-- here country code added uniqueness to the indexes
-- When parent indexes deleted then child indexes also deleted


-- Switching Partition Pruning on/off
SHOW enable_partition_pruning;

-- lets visualize the query
SELECT * FROM employee_list WHERE country_code='US';

-- To disable the partition pruning
SET enable_partition_pruning = off;

-- Now run the previous query
SELECT * FROM employee_list WHERE country_code='US';

-- to enable the partition query 
SET enable_partition_pruning = on;
SHOW enable_partition_pruning;

SELECT * FROM employee_list WHERE country_code='US';

-- here because of partition pruning on it will use only one partitioin to fetch data.



-- Sizing the partition
-- Get high, low number of you key fields
SELECT
	MIN(order_date),
	MAX(order_date)
FROM orders;

-- Get unique values of key field
SELECT
	DISTINCT(country_code)
FROM orders;

-- Get total counts for your key fields
SELECT
	order_date,
	COUNT(*)
FROM orders
GROUP BY order_date;















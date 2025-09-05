-- Create an index, Index,UNIQUE INDEX
-- Lets create an index on order date on orders table 
CREATE INDEX idx_orders_order_date ON orders (order_date);
CREATE INDEX idx_orders_ship_city ON orders (ship_city);

-- Create an index on multiple fields say orders -> customer_id,order_id
CREATE INDEX idx_orders_customer_id_order_id ON orders (customer_id,order_id);

-- Lets create a UNIQUE index on products table on product_id
CREATE UNIQUE INDEX idx_u_products_product_id ON products (product_id);

-- Lets create a UNIQUE index on employees table on employee_id
CREATE UNIQUE INDEX idx_u_employees_employee_id ON  employees (employee_id);

-- How amout unique on multiple columns
CREATE UNIQUE INDEX idx_u_orders_order_id_customer_id 
ON orders (order_id,customer_id);
CREATE UNIQUE INDEX idx_u_employees_employee_id_hire_date
ON employees (employee_id,hire_date);


-- Unique index on table
CREATE TABLE t1(
	id SERIAL PRIMARY KEY,
	tag text
);
INSERT INTO t1 (tag) VALUES  ('a'),('b');
CREATE UNIQUE INDEX idx_u_t1_tag ON t1(tag);
SELECT * FROM t1;

-- List all indexes
SELECT 
*
FROM pg_indexes
WHERE 
	schemaname='public' AND tablename='employees';

-- Size of the table index
SELECT 
	pg_size_pretty(pg_indexes_size('suppliers'));
CREATE INDEX idx_suppliers_region ON suppliers(region);
CREATE UNIQUE INDEX idx_u_suppliers_supplier_id 
ON suppliers (supplier_id);

-- List counts fro all indexes
-- all stats
SELECT 
*
FROM
	pg_stat_all_indexes;

-- for schema
SELECT 
*
FROM
	pg_stat_all_indexes
WHERE schemaname = 'public'
ORDER BY relname,indexrelname;

-- for table
SELECT 
*
FROM
	pg_stat_all_indexes
WHERE relname = 'orders'
ORDER BY relname,indexrelname;


-- DROP an Index
DROP INDEX idx_suppliers_region;

-- SQL statement execution process
-- SQL Execution Stages
-- parser: handles the textual form of the statement and verifies whether it is correct or not. disassemble info into tables, columns, clauses etc.
-- rewriter: applying any syntactic rules to rewrite the original SQL statement
-- optimizer: finding the very fastest path to the data that the statement needs
-- executor: responsible for effectlively going to the storage and retrieving or modifying the data gets physical access to the data.

-- The Optimizer
-- 1. The cost is everything: lower cost win. 4 operations = 4 * COST = total amount
-- 2. Thread: >= 9.6
-- 3. Nodes: select * from orders order by order_id; a. all data b. order by
-- 4. Nodes Types: 

-- Optimizer Nodes types:-> Nodes are availabel for every oprations and every access methods. nodes are stackable.
-- Sequential scan
-- Index Scan, Index Only Scan, and Bitmap Index Scan
-- Nested Loop, Hash join and merge join
-- The gather and merge parallel nodes

SELECT * FROM pg_am;

-- Sequential Scan
EXPLAIN SELECT * FROM orders;
EXPLAIN SELECT * FROM orders WHERE order_id IS NOT NULL;

-- Index Nodes
-- it is usec to access the dataset
-- Data file and index files are seperated but they are nearby
-- Index Nodes scan type
-- i. Index Scan:-> seeking the tuples then read again the data
EXPLAIN SELECT * from orders where order_id = 1;
-- ii. Index Only Scan:-> request index columns only.directly get data from index file
EXPLAIN SELECT order_id FROM orders where order_id=1;
-- iii. Bitmap Index Scan:-> builds a memory bitmap of where tuples that satisfy the statement caluses


-- Join Nodes
-- 1. used when joining the tables
-- 2. Joins are performed on two tables at a time; if more tables are joined together, the output of one join is treated as input to a subsequent join.
-- 3. When joining a large number of tables, the genetic query optimizer settings may affect what combinations of joins are considered.
-- 4. Types: Hash Join,Merge Join,Nested Loop


-- Index Types
-- 1. B-Tree Index
-- default index
-- self balancing tree: SELECT,INSERT,DELETE and sequential access in logarithmic time
-- Can be used for most operators and column type
-- Supports the UNIQUE condition and
-- Normally used to build the primary key indexes
-- Uses when columns involves follwoing opertors <,>,BETWEEN,IN,IS NULL
-- Use when pattern matching even for like based queries
-- One drawback: copy the whole columns values into the tree structure

-- 2. Hash index
-- for equality operators
-- not for range nor disequality oreprators
-- large then btree indexes


-- BRIN Index
-- 1. block range indexes
-- 2. data block -> min to max value
-- 3. smaller index
-- 4. Less costly to maintain than btree index
-- 5. Can be used on a large table vs btree index
-- 6. used linear sort order eg customers -> order_date

-- GIN Index
-- 1. generalized inverted indexes
-- 2. point to multiple tuples
-- 3. Used with array type data
-- 4. Used in full text_search
-- 5. Useful when we have multiple values stored in a single column


-- The EXPLAIN statment
-- 1. It will show query execution plan
-- 2. Shows the lowest COST among evaluted plans
-- 3. Will not execute the statment you enter, just show query only
-- 4. Show you the execution nodes that the executor will use to  provide you with the dataset.

-- cost:
-- startup cost: how much work postgresql has to do before it begins executing the node
-- final cost: How much effort postgresql has to do to provide the last bit of the dataset

-- rows: how many tuples the node is exected to provide for final dataset
-- width: how many bits evey tuples will occupy as an average.


-- EXPLAIN output options
EXPLAIN (FORMAT JSON) SELECT * FROM orders WHERE order_id=1;
EXPLAIN (FORMAT XML) SELECT * FROM orders WHERE order_id=1;

-- Using EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM orders WHERE order_id=1;


-- Understanding query cost model
CREATE TABLE t_big (id SERIAL,name text);
INSERT INTO t_big (name) SELECT 'Adam' 
FROM generate_series(1,2000000);

INSERT INTO t_big (name) SELECT 'Linda' 
FROM generate_series(1,2000000);

explain select * from t_big where id=12345;
SHOW max_parallel_workers_per_gather;
SET max_parallel_workers_per_gather TO 0;
SELECT pg_relation_size('t_big') / 8192.0;
--21622

SHOW seq_page_cost;
-- 1

SHOW cpu_tuple_cost;
-- 0.01

SHOW cpu_operator_cost
-- 0.0025

-- cost formaula
pg_relation_size * seq_page_cost 
+
total_number_of_table_records * cpu_tuple_cost
+ 
total_number_of_table_records * cpu_operator_cost

SELECT 21622*1 + 4000000*0.01 + 4000000*0.0025
EXPLAIN SELECT * FROM t_big WHERE id=12345;


-- Index are not free
SELECT pg_size_pretty(pg_indexes_size('t_big'));
SELECT pg_size_pretty(pg_total_relation_size('t_big'));
EXPLAIN ANALYZE SELECT * FROM t_big WHERE id=123456;
-- 43455.43
CREATE INDEX idx_t_big_id ON t_big(id);
-- INSERT is expensive
SHOW max_parallel_maintenance_workers;
EXPLAIN ANALYZE SELECT * FROM t_big WHERE id=123456;
-- 8.45


-- Indexes for sorted output
EXPLAIN SELECT * FROM t_big ORDER BY id LIMIT 20;
EXPLAIN SELECT * FROM t_big ORDER BY name LIMIT 20;
EXPLAIN SELECT MIN(id),MAX(id) FROM t_big;

-- Using multiple indexes on a single query
EXPLAIN SELECT * FROM t_big WHERE id = 20 OR id = 40;

-- Execution plans depends on input values
CREATE INDEX idx_t_big_name ON t_big(name);
EXPLAIN SELECT * FROM t_big WHERE name='Adam' LIMIT 10;
EXPLAIN SELECT * FROM t_big WHERE name='Adam' OR name ='Linda';
EXPLAIN SELECT * FROM t_big WHERE name='Adam2' OR name ='Linda2';

-- Using organized vs random data
SELECT * FROM t_big ORDER BY id LIMIT 10;
EXPLAIN (ANALYZE true,buffers true, timing true)
SELECT * FROM t_big WHERE id < 10000;

CREATE TABLE t_big_random AS 
SELECT * FROM t_big ORDER BY random();
CREATE INDEX idx_t_big_random_id ON t_big_random (id);
SELECT * FROM t_big_random limit 10;
VACUUM ANALYZE t_big_random;
EXPLAIN (ANALYZE true,buffers true, timing true)
SELECT * FROM t_big_random WHERE id < 10000;

-- Try using index only scan
EXPLAIN ANALYZE SELECT * FROM t_big WHERE id=123456;
-- 36.266 + 0.057
EXPLAIN ANALYZE SELECT id FROM t_big WHERE id=123456;
-- 0.105 + 0.040

-- Partial Index
SELECT pg_size_pretty(pg_indexes_size('t_big'));
DROP INDEX idx_t_big_name;
CREATE INDEX idx_p_t_big_name ON t_big (name)
WHERE name NOT IN('Adam','Linda');

-- Expression Indexes
CREATE TABLE t_dates AS
SELECT d, repeat(md5(d::text),10) AS padding
	FROM generate_series(timestamp '1800-01-01',
						 timestamp '2100-01-01',
						 interval '1 day') s(d);

VACUUM ANALYZE t_dates;
SELECT * FROM t_dates;
EXPLAIN ANALYZE SELECT * FROM t_dates WHERE d BETWEEN '2001-01-01' 
AND '2001-01-31';
-- WITHOUT ANY INDEX 
-- 438.60

CREATE INDEX idx_t_dates_d ON t_dates (d);
EXPLAIN ANALYZE SELECT * FROM t_dates 
WHERE EXTRACT(day FROM d) = 1;

CREATE INDEX idx_expr_t_dates ON t_dates (EXTRACT(day FROM d));
EXPLAIN ANALYZE SELECT * FROM t_dates 
WHERE EXTRACT(day FROM d) = 1;

-- Adding data while indexing problem
CREATE INDEX CONCURRENTLY idx_t_big_name2 on t_big (name);

-- Invalidating an index
-- 1. Delete or DROP the index
EXPLAIN SELECT * FROM orders where ship_country = 'USA';
CREATE INDEX idx_orders_ship_country ON orders (ship_country);

-- Lets disallow the query optimizer to use our index
UPDATE pg_index
SET indisvalid = false
WHERE indexrelid = (SELECT oid FROM pg_class WHERE relkind = 'i'
	AND relname = 'idx_orders_ship_country');


-- Rebuilding an index (REINDEX)
REINDEX [ (VERBOSE)] {INDEX | TABLE | SCHEMA | DATABASE | SYSTEM} [CONCURRENTLY} name
REINDEX INDEX idx_orders_customer_id_order_id;
REINDEX  TABLE orders;





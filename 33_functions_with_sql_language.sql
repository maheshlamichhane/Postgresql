-- SQL Functions
/*
	1. SQL functions are the easiest way to write functions in postgresql.
	2. We can use any SQL command inside them
*/

-- syntax
CREATE OR REPLACE FUNCTION function_name() RETURNS void AS 
'
	-- SQL command
' LANGUAGE SQL

-- Examples
CREATE OR REPLACE FUNCTION fn_mysum(int,int)
RETURNS int AS
'
	SELECT $1 + $2;
' LANGUAGE SQL;

SELECT fn_mysum(10,10);

-- Introducing dollar quoting
CREATE OR REPLACE FUNCTION fn_mysum(int,int)
RETURNS int AS
$$
	SELECT $1 + $2;
$$ LANGUAGE SQL;
SELECT fn_mysum(10,10);

CREATE OR REPLACE FUNCTION fn_mysum(int,int)
RETURNS int AS
$body$
	SELECT $1 + $2;
$body$ LANGUAGE SQL;
SELECT fn_mysum(10,10);

-- Function returning no values
CREATE OR REPLACE FUNCTION fn_employees_update_country()
RETURNS void AS
$$
	UPDATE employees SET country='N/A' WHERE country is NULL
$$
LANGUAGE SQL;
UPDATE employees SET country = NULL where employee_id = 1;
SELECT fn_employees_update_country();
SELECT * FROM employees;

-- Function returning single value
CREATE OR REPLACE FUNCTION fn_product_min_price() RETURNS real AS
$$
	SELECT MIN(unit_price) FROM products
$$
LANGUAGE SQL;
SELECT fn_product_min_price();

-- Get the biggest order ever placed
CREATE OR REPLACE FUNCTION fn_biggest_order() RETURNS double precision AS
$$
SELECT MAX(amount) FROM
(
	SELECT
		order_id,
		SUM(unit_price * quantity) as amount
	FROM order_details
	GROUP BY order_id
) as total_amount
$$
LANGUAGE SQL;
SELECT fn_biggest_order();

-- Function using parameters
CREATE OR REPLACE FUNCTION function_name(p1 TYPE,p2 TYPE...) RETURNS 
return_type AS
$$
	$1,$2
$$
LANGUAGE language_name;
CREATE OR REPLACE FUNCTION function_name(p1 TYPE,p2 TYPE...) RETURNS 
return_type AS
$$
	p1,p2
$$
LANGUAGE language_name;

CREATE OR REPLACE FUNCTION fn_mid(string varchar, starting_point integer)
RETURNS varchar AS
$$
	SELECT substring(string,starting_point)
$$
LANGUAGE SQL;
SELECT fn_mid('my name is mahesh',3);

-- Function returning a composite
-- Returning a table
-- Returns a single row, in the form of an array style
CREATE OR REPLACE FUNCTION fn_api_order_lateast() RETURNS orders AS
$$
	SELECT
		*
	FROM orders
	ORDER BY order_date DESC,order_id DESC
	LIMIT 1
$$
LANGUAGE SQL;
SELECT fn_api_order_lateast();
SELECT (fn_api_order_lateast()).*;
SELECT (fn_api_order_lateast()).customer_id;

CREATE OR REPLACE FUNCTION fn_api_order_lateast_by_date_range(p_from date,p_to date) RETURNS orders AS
$$
	SELECT
		*
	FROM orders
	WHERE
		order_date BETWEEN p_from AND p_to
	ORDER BY order_date DESC,order_id DESC
	LIMIT 1
$$
LANGUAGE SQL;
SELECT 
(fn_api_order_lateast_by_date_range('1997-01-01','2020-10-10')).*;


-- Funciton returning multiple rows
CREATE OR REPLACE FUNCTION 
fn_api_employees_hire_date_by_year(p_year integer)
RETURNS SETOF employees AS
$$
	SELECT
	*
	FROM employees
	WHERE
		EXTRACT('YEAR' FROM hire_date) = p_year
$$
LANGUAGE SQL;
SELECT (fn_api_employees_hire_date_by_year('1992')).*;

-- Function result as table source
SELECT
	first_name,
	last_name,
	hire_date
FROM fn_api_employees_hire_date_by_year('1992');

SELECT * FROM fn_api_employees_hire_date_by_year('1992');

-- Functions order matters
-- RETURNS TABLE(clo1 type,col2 type...)


-- Function returning a table
-- RETURNS TABLE(col1,col2 type ...)
-- must return all columns
CREATE OR REPLACE FUNCTION fn_api_customer_top_orders(p_customer_id bpchar,p_limit integer)
RETURNS TABLE
(
	order_id smallint,
	customer_id bpchar,
	product_name varchar,
	unit_price real,
	quantity smallint,
	total_order double precision
)
AS
$$
	SELECT
		orders.order_id,
		orders.customer_id,
		products.product_name,
		order_details.unit_price,
		order_details.quantity,
		((order_details.unit_price * order_details.quantity) - order_details.discount) AS total_order
	FROM order_details
	NATURAL JOIN orders
	NATURAL JOIN products
	WHERE orders.customer_id = p_customer_id
	ORDER BY ((unit_price*quantity)-discount) DESC
	LIMIT p_limit
$$
LANGUAGE SQL;
SELECT (fn_api_customer_top_orders('VINET',10)).*;


-- Function parameters with default values
CREATE OR REPLACE FUNCTION fun_sum_3(x int, y int DEFAULT 10,z int DEFAULT 10) 
RETURNS integer AS
$$
	SELECT x + y +z;
$$
LANGUAGE SQL;
SELECT fun_sum_3(1);
SELECT fun_sum_3(1,2);

-- Function based on views
CREATE OR REPLACE VIEW v_active_queries AS
SELECT
	pid,
	usename,
	query_start,
	(CURRENT_TIMESTAMP - query_start) as runtime,
	query
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY 4 DESC;

CREATE OR REPLACE FUNCTION fn_internal_active_queries(p_limit int)
RETURNS SETOF v_active_queries AS
$$
	SELECT
	*
	FROM v_active_queries
	LIMIT p_limit
$$
LANGUAGE SQL;

SELECT * from fn_internal_active_queries(10);

-- DROP a function
DROP FUNCTION IF EXISTS fn_internal_active_queries;












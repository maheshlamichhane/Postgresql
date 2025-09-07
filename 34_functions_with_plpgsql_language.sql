-- Introduction to PL/pgSQL language
/*
	1. PL/pgSQL is a powerful SQL scripting language that is heavily influenced
	by oracle PL/SQL
	2. PL/pgSQL is a full-fledged SQL development language
	3. Originally designed for simple scaler functions, and now providing;
		-- Full PostgreSQL internals,
		-- COntrol Structure
		-- Variable declaration
		-- Expression
		-- Loops
		-- Cursors and much more
	4. Ability to create
		-- complex functions
		-- new data types
		-- stored procedures and more
	5. It is easy to use. available by default on postgresql.
	6. Optimized for performance of data intensive tasks
*/

-- PL/pgSQL VS SQL
/*
	-- SQL is a query language, but can only execute SQL statemnt INDIVIDUALLY
	-- PL/pgSQL will
		- Wrap multiple statements in an OBJECT
		- store that object on the server
		- instead of sending multiple statements to the server one by one,
			we can send one statement to execute the object stored in the server
		- reduced round trips to server for each statement to execute
		- provide transactional integrity and much more

*/

-- Strucutre of a PL/pgSQL function
CREATE FUNCTION function_name(p1 type,p2 type...) RETURNS return_type AS
$$
	BEGIN
		-- statements
	END
$$
LANGUAGE plpgsql

-- Lets get the max price of all product
CREATE OR REPLACE FUNCTION fn_api_products_max_price() RETURNS bigint AS
$$
	BEGIN
		RETURN MAX(unit_price) FROM products;
	END;
$$
LANGUAGE plpgsql;
SELECT fn_api_products_max_price();

-- Declaring variables
DECLARE
	mynum 	integer :=1;
	first_name 	varchar(100) :='Adnan';
	hire_date 	date :='2020-01-01';
	start_time 	timestamp :=NOW();
	emptyvar	integer;
BEGIN
	....
END;

-- Block structure
DO
$$
	DECLARE
		mynum 		integer :=1;
		first_name 	varchar(100) :='Adnan';
		hire_date 	date :='2020-01-01';
		start_time 	timestamp :=NOW();
		emptyvar	integer;
		var1		integer = 10;
	BEGIN
		RAISE NOTICE 'My variables % % % % % %',
		mynum,
		first_name,
		hire_date,
		start_time,
		emptyvar,
		var1;
	END;
$$ 

-- Declaring variables in funcion
CREATE OR REPLACE FUNCTION fn_my_sum(integer,integer) RETURNS integer AS
$BODY$
	DECLARE
		ret integer;
	BEGIN
		ret := $1 + $2;
		RETURN ret;
	END;
$BODY$
LANGUAGE plpgsql;
SELECT fn_my_sum(2,2);

-- Declaring variables via ALIAS
CREATE OR REPLACE FUNCTION fn_my_sum(integer,integer) RETURNS integer AS
$BODY$
	DECLARE
		ret integer;
		x alias FOR $1;
		y alias FOR $2;
	BEGIN
		ret := x + y;
		RETURN ret;
	END;
$BODY$
LANGUAGE plpgsql;
SELECT fn_my_sum(2,2);


-- Variable initialization timing
DO
$$
	DECLARE 
		start_time time :=NOW();
	BEGIN
		RAISE NOTICE 'Starting at : %',start_time;
		PERFORM pg_sleep(2);
		RAISE NOTICE 'Next time : %',start_time;
	END;
$$
LANGUAGE plpgsql;

-- Copying data types
DO
$$
	DECLARE 
		variable_name table_name.column_name%TYPE;
$$


-- Asigning variables from query
DO
$$
	DECLARE
		product_title products.product_name%TYPE;
	BEGIN
		SELECT
			product_name
		FROM products
		INTO product_title
		WHERE product_id = 1
		LIMIT 1;
		RAISE NOTICE 'Your product title %',product_title;
	END;
$$

-- Asigning row from query
DO
$$
	DECLARE
		row_product record;
	BEGIN
		SELECT
			*
		FROM products
		INTO row_product
		WHERE product_id = 1
		LIMIT 1;
		RAISE NOTICE 'Your product row %',row_product.product_name;
	END;
$$

-- Using IN, OUT without RETURNS
CREATE OR REPLACE FUNCTION fn_my_sum_2_par(IN x integer,In y integer,OUT z integer) AS
$$
	BEGIN
		z := x +y;
	END;
$$
LANGUAGE plpgsql;
SELECT fn_my_sum_2_par(1,5);

-- Can we also output more than one return
CREATE OR REPLACE FUNCTION fn_my_sum_2_par1(IN x integer,In y integer,OUT w integer,OUT z integer) AS
$$
	BEGIN
		z := x +y;
		w := x*y;
	END;
$$
LANGUAGE plpgsql;
SELECT * FROM fn_my_sum_2_par1(1,5);

-- Variables in block and subblock
DO
$$
	<<PARENT>>
	DECLARE
		counter integer :=0;
	BEGIN
		counter := counter + 1;
		RAISE NOTICE 'THE CURRENT VALUE OF COUNTER IS %',counter;

		-- Another block
		DECLARE
			counter integer :=0;
		BEGIN
			counter := counter + 5;
			RAISE NOTICE 'THE CURRENT VALUE OF COUNTER at subblock IS %',counter;
			RAISE NOTICE 'THE CURRENT VALUE OF COUNTER at BLOCK_1 IS %',PARENT.counter;
		END;
	END PARENT;
$$
LANGUAGE PLPGSQL;



-- How to return query results
CREATE OR REPLACE FUNCTION fn_api_orders_latest_top_10_orders()
RETURNS SETOF orders AS
$$
	BEGIN
		RETURN QUERY
		SELECT
			*
		FROM orders
		ORDER BY order_date DESC
		LIMIT 10;
	END;
$$
LANGUAGE PLPGSQL;
SELECT * FROM fn_api_orders_latest_top_10_orders();

-- Control Structures
/*
	-- Conditional statements(IF,CASE)
	-- Loop statemsnts
	-- Exception handler statements

*/

-- Using IF
CREATE or REPLACE FUNCTION fn_api_products_cateory(price real) RETURNS text AS
$$
	BEGIN
		IF price > 50 THEN
			RETURN 'HIGH';
		ELSEIF price > 25  THEN
			RETURN 'MEDIUM';
		ELSE
			RETURN 'SWEET_SPOT';
		END IF;
	END;
$$
LANGUAGE PLPGSQL;
SELECT fn_api_products_cateory(unit_price),* FROM products;

-- CASE Statement
-- simple:-> if we have to make a choice from a LIST of values
-- searched:-> we have to choose from a range of values(1...10)

-- simple
CREATE OR REPLACE FUNCTION fn_my_check_value(x integer default 0) RETURNS TEXT AS
$$
	BEGIN
		CASE x
			WHEN 10 THEN
				RETURN 'VALUE = 10';
			WHEN 20 THEN
				RETURN 'VALUE = 20';
			ELSE
				RETURN 'No values found,returning input value x';
		END CASE;
	END;
$$
LANGUAGE PLPGSQL;
SELECT fn_my_check_value(40);

-- searched
DO
$$
	DECLARE
		total_amount numeric;
		order_type varchar(50);
	BEGIN
		SELECT
			SUM((unit_price * quantity) - discount) INTO total_amount
		FROM order_details
		WHERE
			order_id = 5454;

		IF found THEN
			CASE
				WHEN total_amount > 200 THEN
					order_type = 'PLATINIUM';
				WHEN total_amount > 100 THEN
					order_type = 'GOLD';
				ELSE
					order_type = 'SILVER';
			END CASE;
			RAISE NOTICE 'order amount, order type % %',total_amount,order_type;
		ELSE
			RAISE NOTICE 'No order was found';
		END IF;
	END;
$$
LANGUAGE PLPGSQL;


-- Loop statement
DO
$$
	DECLARE
		i_counter integer :=0;
	BEGIN
		LOOP
			RAISE NOTICE '%',i_counter;
			i_counter := i_counter +1;
			EXIT WHEN
				i_counter = 5;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;

-- FOR Loops
DO
$$
	BEGIN
		FOR counter IN 1..10
		LOOP
			RAISE NOTICE 'Counter : %',counter;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;

-- steepping
DO
$$
	BEGIN
		FOR counter IN 1..10 BY 2
		LOOP
			RAISE NOTICE 'Counter : %',counter;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;

-- FOR Loops iterate over result set
DO
$$
	DECLARE
		rec record;
	BEGIN
		FOR rec IN SELECT order_id,customer_id FROM orders LIMIT 20
		LOOP
			RAISE NOTICE '%, %',rec.order_id,rec.customer_id;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;

-- CONTINUE statement
DO
$$
	DECLARE
		i_counter int = 0;
	BEGIN
		LOOP
			i_counter = i_counter+1;
			EXIT WHEN i_counter > 20;
			CONTINUE WHEN MOD(i_counter,2) = 1;
			RAISE NOTICE '%',i_counter;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;

-- FOREACH loop with arrays
DO
$$
	DECLARE 
		arr1 int[] := array[1,2,3,4,5];
		arr2 int[] := array[5,6,7,8,9,10];
		var int;
	BEGIN
		FOREACH var IN ARRAY arr1 || arr2
		LOOP
			RAISE INFO '%',var;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;

-- WHILE loops
CREATE OR REPLACE FUNCTION fn_while_loop_sum_all(x integer) RETURNS numeric AS
$$
	DECLARE
		counter integer :=1;
		sum_all integer :=0;
	BEGIN
		WHILE counter <= x
		LOOP
			sum_all := sum_all + counter;
			counter := counter + 1;
		END LOOP;
		RETURN sum_all;
	END;
$$
LANGUAGE PLPGSQL;
SELECT fn_while_loop_sum_all(4);


-- Using RETURN table
CREATE OR REPLACE FUNCTION fn_api_products_by_names(p_pattern varchar)
RETURNS TABLE (productname varchar,unitprice real) AS
$$
	BEGIN
		RETURN QUERY
			SELECT
				product_name,
				unit_price
			FROM products
			WHERE
				product_name like p_pattern;
	END;
$$
LANGUAGE PLPGSQL;
SELECT * FROM fn_api_products_by_names('A%');

-- Using RETURN NEXT
CREATE OR REPLACE FUNCTION fn_get_all_orders_greater_than() RETURNS SETOF
order_details AS
$$
	DECLARE
		r record;
	BEGIN
		FOR r IN SELECT * FROM order_details WHERE unit_price > 10
		LOOP
			RETURN NEXT r;
		END LOOP;
		RETURN;
	END;
$$
LANGUAGE PLPGSQL;
SELECT * FROM fn_get_all_orders_greater_than();

-- Error Handling
DO
$$
	DECLARE
		rec record;
		orderid smallint = 1;
	BEGIN
		SELECT
			customer_id,
			order_date
		FROM orders
		INTO STRICT rec
		WHERE
			order_id = orderid;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			RAISE EXCEPTION 'NO order id was found %',orderid;
	END;
$$
LANGUAGE PLPGSQL;

-- TOO MANY ROWS EXCEPTION
DO
$$
	DECLARE
		rec record;
	BEGIN
		SELECT
			customer_id,
			company_name
		FROM customers
		INTO STRICT rec
		EXCEPTION
			WHEN too_many_rows THEN
			RAISE EXCEPTION 'Your query returns too many rows';
	END;
$$
LANGUAGE PLPGSQL;

-- Using SQLSTATE codes for exception handling
DO
$$
	DECLARE
		rec record;
		orderid smallint = 1;
	BEGIN
		SELECT
			customer_id,
			order_date
		FROM orders
		INTO STRICT rec
		WHERE
			order_id = orderid;
		EXCEPTION
			WHEN sqlstate 'p0002' THEN
			RAISE EXCEPTION 'No orderid was found %',orderid;
	END;
$$
LANGUAGE PLPGSQL;

-- EXCEPTION with data exception errors
CREATE OR REPLACE FUNCTION fn_div_exception(x real,y real) RETURNS real AS
$$
	DECLARE
		ret real;
	BEGIN
		ret := x /y;
		RETURN ret;
	EXCEPTION
		WHEN divisible_by_zero THEN
			RAISE INFO 'DIVISION By Zero';
			RAISE INFO 'Error % %',SQLSTATE, SQLERRM;
	END;
$$
LANGUAGE PLPGSQL;
		















--Functions VS Stored Procedures
/*
	1. A user-defined functions(create function) cannot execute 'transactions'
		i.e inside a function, you cannot start a transaction
	2. Stored procedure support transactions.
	3. Stored procedure does not return value, so you cannot use 'return';
		However you can use the return statement without the expression
		to stop the stored procedure immediately INOUT mode can be used to return a value from stored procedure.
	4. Can not be executed or called from within a SELECT.
	5. They are compiled object.
	6. Procedures may or may not use parameters.
	7. Execution
		- Explicit execution:-> execute command along with specific SP name and optional parameters.
		-- Implicit execution: using only SP name CALL
*/

-- syntax
CREATE OR REPLACE PROCEDURE procedure_name(parameter_list) AS
$$
	DECLARE
		-- variable declaration
	BEGIN
		-- stored procedure body
	END;
$$

-- Create a transaction
CREATE TABLE t_accounts(
	recid serial primary key,
	name varchar not null,
	balance dec(15,2) not null
);
INSERT INTO t_accounts(name,balance)
VALUES
('Adam',100),
('Linda',100);
SELECT * FROM t_accounts;

-- create our stored procedure
CREATE OR REPLACE PROCEDURE pr_money_transfer(
	sender int,
	receiver int,
	amount dec
)
AS
$$
	BEGIN
		-- SUBTRACT AMOUNT FROM THE SENDERS ACCOUNT
		UPDATE t_accounts 
		SET balance = balance - amount
		WHERE recid = sender;

		-- ADDING AMOUNT TO REC END 
		UPDATE t_accounts 
		SET balance = balance + amount
		WHERE recid = receiver;

		COMMIT;
	END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM t_accounts;
CALL pr_money_transfer(1,2,100);

-- Understanding why to use stored procedures
/*
	1. To ensure data consistency by not requiring that a series of steps to be run or created over and over.
	2. TO simply complex operations and encapsulating that into a single easy to use inti.
	3. TO simplify overall change management.
	4. TO ensure security
	5. To fully utilize transaction and its all beneifits.
	6. Performance. The code is compiled only when created, meaning no need to require
		at run time, unless you change the program.
	7. Modularity
*/

-- Returning a value
CREATE OR REPLACE PROCEDURE pr_orders_count(INOUT total_count integer default 0) AS
$$
	BEGIN
		SELECT COUNT(*)
		INTO total_count
		FROM orders;
	END;
$$
LANGUAGE PLPGSQL;

CALL pr_orders_count();


-- Drop a procedure
DROP PROCEDURE IF EXISTS pr_orders_count;






-- What is a Trigger
/*
	1. A 'Trigger' is defined as any event that sets a course of action in a motion.
	2. A PostgreSQL trigger is a function invoked automatically whenever 'an even'
		assciated with a table occurs.
	3. An event could be of the following: INSERT,UPDATE,DELETE,TRUNCATE
	4. A trigger ca be associated with a specified :Table,View,Forign Table
	5. A trigger is a special 'user-defined function'.
	6. The difference between a trigger and a user-defined function is that
		a trigger is automatically invoked when a triggering event occurs.
	7. We can create trigger
		- BEFORE:-> IF the trigger is invoked before an event, it can skip
			the opertion for the current row or even change the row being updated and inserted.
		- AFTER:-> ALl changes are available to the trigger.
		- INSTEAD:-> of the event operation.
	8. If there are more than one triggers on a table, then they are fired
		in alphabetical orders. First, all of those before triggers happen in 
		alphabetical orders.
	9. Triggers can modify data before aor after the actual modificatin has happended. In general,
		this is a good way to verify data and to error out if some custom restrictions
		are violated.
	10. There are two main characteristics that make tirggers different than stored procedures:
		- Triggers cann be manually executed by the user.
		- There is no chance for triggers to receive parameters.
*/

-- Type of Triggers
/*
	1. Row Level Trigger:-> If the trigger is marked for each row then 
		the trigger function will be called for each row that is getting modified
		by the event.
		eg. If we update 20 rows in the table,the update trigger function 
		will be called 20 times once for each updated row.
	2. Statement Level Trigger:-> The for each statement option will call the 
		trigger function only once for each statement, regardless of
		the number of the rows getting modified.
*/

-- Trigger Table
/*
	When		Event					Row-level			Statement-level

	BEFORE		INSERT/UPDATE/DELETE    Tables 			     Tables and views
				TRUNCATE				  - 				 Tables


	AFTER       INSERT/UPDATE/DELETE     Tables   			  Tables and views
				TRUNCATE 			       -   				  Tables


	INSTEAD OF   INSERT/UPDATE/DELETE.   Views					-
				 TRUNCATE 				    - 					-
*/

-- Pros and Cons of using triggers
/*
	Pros
	1. Triggers are not difficult to code. The fact that they are coded like stored
		procedures which makes getting started with triggers easy.
	2. Triggers allow you to create 'basic auditing'. By using the deleted table 
		inside a trigger you can build a decent audit solution that inserts the 
		contents of the deleted table data into an audit table which holds the data
		that is either being removed by a DELETE statement or being changed by an 
		UPDATE statement.
	3. You can call stored procedure and functions from inside a trigger.
	4. Triggers are useful when you need to validate inserted or updated data in 
		batches instead of row by row. Think about it, in a triggers code you have the
		inserted and deleted tables that hold a copy of data that potentially will be stored
		in the table and the data that will be removed from the table.
	5. You can use triggers to implement referential integrity acrosss database.
	6. Triggers are useful if you need to be sure that certain events always
		happen when data is inserted,updated or deleted.This is the case when you
		have. todeal with complex default vaues of columns, or modify the data of
		other tables.
	7. Triggers allow recursion. Triggers are recursive when a trigger on a table 
		performs an action on the base table that causes another instance of the 
		trigger to fire. This is useful when you have to solve a self-referencing
		relation.

Cons
	1. Triggers are difficult to locate unless you have proper documentation because
		they are invisible to the client. For instance, sometimes you execute a DML
		statement without erros or warnnngs,say an insert, and you don't see
		it reflected in the tables data. In such case you have to check the table 
		for triggers that may be disallowing you to run the insert you wanted.
	2. Triggers add overhead to DML statements. Every time you run a DML statement 
		that has a trigger associated to it, you are actually executing the DML 
		statement and the trigger; but by definition the DML statement won't end 
		until the trigger execution completes. This can create a problem in production.
	3. The problem of using triggers for audit purpose is that when triggers are enabled,
		they execute always regardless of the circumtances that caused the trigger to fire. 
	4. If there are many nested triggers it could get very hard to debug and 
		troubleshoot, which consumes development time and resoruces.
	5. Recursive triggers are even harder to debug 
		
*/

-- Trigger creation process
/*
	To create a new trigger in PostgreSQL, you follow these steps:
	1. First, create a trigger function using CREATE FUNCTION statement.
	2. Second, bind the trigger function to a table by using CREATE TRIGGER statement.
*/

-- Create function Syntax
CREATE function trigger_function()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
AS
$$
	BEGIN
		-- trigger logic
	END;
$$

-- Create trigger function

CREATE TRIGGER trigger_name
	{BEFORE | AFTER} { event}
ON table_name
	[FOR [EACH] {ROW | STATEMENT}]
		EXECUTE PROCEDURE trigger_function

-- Data auditing with triggers
-- lets create the players table
CREATE TABLE players(
	player_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);
-- lets create players_audit table to store all changes
CREATE TABLE players_audits(
	player_audit_id SERIAL PRIMARY KEY,
	player_id INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	edit_date TIMESTAMP NOT NULL
);

-- As we seen earlier , we first create a function and then bind that function to our trigger
CREATE  OR REPLACE FUNCTION fn_players_nam_changes_log()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		-- Compare the new value vs old value
		IF NEW.name <> OLD.name THEN
			INSERT INTO players_audits(player_id,name,edit_date)
			VALUES
			(OLD.player_id,OLD.name,NOW());
		END IF;

		RETURN NEW;
	END;
$$

-- Now bind our newly created function to our table 'players' via CREATE TRIGGER statement.
CREATE TRIGGER trg_players_name_changes
	BEFORE UPDATE
	ON players
	FOR EACH ROW
	EXECUTE PROCEDURE fn_players_nam_changes_log();

-- lets inserting some data
INSERT INTO players (name) VALUES
('Adam'),('Linda');

-- lets update data
UPDATE players 
SET name='Linda2'
WHERE player_id=2;

SELECT * FROM players;
SELECT * FROM players_audits;

-- Modify data at INSERT event
CREATE TABLE t_temperature_log(
	id_temperature_log SERIAL PRIMARY KEY,
	add_date TIMESTAMP,
	temperature numeric
);

-- lets create a function to check the inserted data
CREATE OR REPLACE FUNCTION fn_temperature_value_check_at_insert()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		-- temperature < -30: temperature = 0
		IF NEW.temperature < -30 THEN
			NEW.temperature = 0;
		END IF;
		RETURN NEW;
		
	END;
$$

-- lets bind our function to our table.
CREATE OR REPLACE TRIGGER trg_temperature_value_check_at_insert
BEFORE INSERT
ON t_temperature_log
FOR EACH ROW
EXECUTE PROCEDURE fn_temperature_value_check_at_insert();

-- insert some data
INSERT INTO t_temperature_log (add_date,temperature) VALUES
('2020-10-01',10);
INSERT INTO t_temperature_log (add_date,temperature) VALUES
('2020-10-01',-40);
SELECT * FROM t_temperature_log;


-- View Trigger variables
-- Triggers knows a lot about themselves. They can access couple of variables that
-- allow you to write advace code and more
CREATE OR REPLACE FUNCTION fn_trigger_variables_display()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
	BEGIN
		RAISE NOTICE 'TG_NAME: %', TG_NAME;
		RAISE NOTICE 'TG_RELNAME: %', TG_RELNAME;
		RAISE NOTICE 'TG_TABLE_SCHEMA: %', TG_TABLE_SCHEMA;
		RAISE NOTICE 'TG_TABLE_NAME: %', TG_TABLE_NAME;
		RAISE NOTICE 'TG_WHEN: %', TG_WHEN;
		RAISE NOTICE 'TG_LEVEL: %', TG_LEVEL;
		RAISE NOTICE 'TG_OP: %', TG_OP;
		RAISE NOTICE 'TG_NARGS: %', TG_NARGS;
		RAISE NOTICE 'TG_ARGV: %', TG_NAME;

		RETURN NEW;
	END;
$$

CREATE TRIGGER trg_trigger_variables_display
	AFTER INSERT
	ON t_temperature_log
	FOR EACH ROW
	EXECUTE PROCEDURE fn_trigger_variables_display();

INSERT INTO t_temperature_log (add_date,temperature) VALUES
('2020-11-01',50);

-- Disallowing DELETE
/*
	What if our business requirements are such that the data can only be added and 
	modified in some tables but not deleted??
	One way to handle this will be to just revoke the DELETE rights on these tables
	from all the users,but this can also be achieved using triggers.
*/

CREATE TABLE test_delete(
id INT
);

INSERT INTO test_delete (id) VALUES (1),(2);
SELECT * FROM test_delete;

CREATE OR REPLACE FUNCTION fn_generic_cancel_op()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
	BEGIN
		IF TG_WHEN = 'AFTER' THEN
			RAISE EXCEPTION 'YOU ARE NOT ALLOWED TO % ROWS in %.%',
			TG_OP,TG_TABLE_SCHEMA,TG_TABLE_NAME;
		END IF;

		RAISE NOTICE '% ON ROWS IN %.% WONT HAPPEN',
		TG_OP,TG_TABLE_SCHEMA,TG_TABLE_NAME;
		RETURN NULL;
	END;
$$

CREATE TRIGGER trg_disallow_delete
AFTER DELETE
ON test_delete
FOR EACH ROW
EXECUTE PROCEDURE fn_generic_cancel_op();

DELETE FROM test_delete WHERE id=1;
SELECT * FROM test_delete;

CREATE TRIGGER trg_skip_delete
BEFORE DELETE
ON test_delete
FOR EACH ROW
EXECUTE PROCEDURE fn_generic_cancel_op();

DELETE FROM test_delete WHERE id=1;

-- Disallowing TRUNCATE 
/*
	- PostgreSQL TRUNCATE quickly removes all rows from a set of tables. it has the
	same effect as an unqualified delete on each table, but since it does not actually 
	scan the tables it is faster. Furthmore, it reclaims disk space immediately, rather
	than requiring a susequent VACUUM operation. This is most useful on large tables.

	Problem: In the previous example, a user can still delete the record using the 
		truncate command. so we will work on disallowing truncate here
	Solution: While we cannot simply skip TRUNCATE by returning NULL as Opposed to the
		row level BEFORE triggers,however we can still make it impossible by raising an error if 
		if truncate is attempted
*/

CREATE TRIGGER trg_disallow_truncate
AFTER TRUNCATE 
ON test_delete
FOR EACH ROW
EXECUTE PROCEDURE fn_generic_cancel_op();

-- Do you notice the error, TRUNCATE FOR EACH ROW triggers are not supported
-- Lets do that on statement level and now row level

CREATE TRIGGER trg_disallow_truncate
AFTER TRUNCATE 
ON test_delete
FOR EACH STATEMENT
EXECUTE PROCEDURE fn_generic_cancel_op();

TRUNCATE test_delete;

-- The audit trigger
/*
	1. One of the most common uses of triggers is to log data changes to tables in a
		consistent and transparent manner.
	2. When creating an audit trigger, we first must decide what we want to log.
	3. A logical set of things that can be logged are:
		- who changed the data,
		- when the data was changed
		- and which operation changed the data
*/

CREATE TABLE audit(
	id INT
);

CREATE TABLE audit_log(
	username TEXT,
	add_time TIMESTAMP,
	table_name TEXT,
	operation TEXT,
	row_before JSON,
	row_after JSON
);

CREATE OR REPLACE FUNCTION fn_audit_trigger()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
	DECLARE
		old_row json = NULL;
		new_row json = NULL;
	BEGIN
		IF TG_OP IN('UPDATE','DELETE') THEN
			old_row = row_to_json(OLD);
		END IF;
		IF TG_OP IN('INSERT','UPDATE') THEN
			new_row = row_to_json(NEW);
		END IF;

		INSERT INTO audit_log
		(
			username,
			add_time,
			table_name,
			operation,
			row_before,
			row_after
		)
		VALUES
		(
			session_user,
			CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
			TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
			TG_OP,
			old_row,
			new_row
		);
		RETURN NEW;
	END;
$$

CREATE TRIGGER trg_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON audit
FOR EACH ROW
EXECUTE PROCEDURE fn_audit_trigger();

INSERT INTO audit (id) VALUES (1);
INSERT INTO audit (id) VALUES (2);
SELECT * FROM audit;
SELECT * FROM audit_log;

UPDATE audit SET id = '100' WHERE id = 1;
SELECT * FROM audit;
SELECT * FROM audit_log;

DELETE FROM audit WHERE id=2;
SELECT * FROM audit;
SELECT * FROM audit_log;

-- Creating conditional triggers
/*
	1. we can create a conditional trigger by using a generic WHEN clause
	2. WIth a WHEN clause, you can write some conditions except a subquery. bcz subquery executed before.
	3. The WHEN expression should result into boolean values. if the value is FALSE or null ,
		the trigger function is not called.
*/

CREATE TABLE mytask(
	task_id SERIAL PRIMARY KEY,
	task TEXT
);

CREATE OR REPLACE FUNCTION fn_cancel_with_message()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
	BEGIN
		RAISE EXCEPTION '%',TG_ARGV[0];
		RETURN NULL;
	END;
$$

CREATE OR REPLACE TRIGGER trg_no_update_on_friday_afternoon
BEFORE INSERT OR UPDATE OR DELETE OR TRUNCATE
ON mytask
FOR EACH STATEMENT
WHEN
(
	EXTRACT('DOW' FROM CURRENT_TIMESTAMP) = 1
	AND CURRENT_TIME >'00:17'
)
EXECUTE PROCEDURE 
fn_cancel_with_message('No update are allowed at Friday Afternoon,so chill!!!');


SELECT
	EXTRACT('DOW' FROM CURRENT_TIMESTAMP),
	CURRENT_TIME;

INSERT INTO mytask (task) VALUES ('test2');

-- Disallows change on primary key data
/*
	Use case: We want to raise an error each time whenever someone tries to change a 
	primary key column.
*/

CREATE TABLE pk_table(
	id SERIAL PRIMARY KEY,
	t TEXT
);

INSERT INTO pk_table(t) VALUES ('t1'), ('t2');
SELECT * FROM pk_table;

CREATE TRIGGER disallow_pk_change
AFTER UPDATE OF id
ON pk_table
FOR EACH ROW
EXECUTE PROCEDURE fn_generic_cancel_op();

UPDATE pk_table
SET id = 100
WHERE id = 1;

-- Event Triggers
/*
	1. Event triggers are data-specific and not bind or attached to a table.
	2. Unlike regular triggers they capture system level DLL events.
	3. Event triggers can be BEFORE or AFTER triggers
	4. Trigger function can be written in any language except SQL
	5. Event triggers are disabled in the single user mode and can only be created
		by a super user.
*/

-- Event Triggers Usage Scenarios
/*
	1. Audit trial - Users, Schema changes etc.
	2. Preventing changes to table
	3. Providing limited DDL capabilites to deveopers.
	4. Enable/Disable certain  DDL commands based on business logic
	5. Performance analysis of DDL start and end process.
	6. Replicating DDL changes/updates to remote locations
	7. Cascading a DDL
*/

-- Creating event triggers
/*
	Requirements
	1. Before creating an event trigger, we must have a function that the trigger will execute.
	2. The functioin must return a special type called EVENT_TRIGGER
	3. This function need not(may not) return a  value; the reutrn type serves 
		merely as a signal that the function is to be invoked as an event trigger.


	In case of multiple triggers??
	-> they are executed in the alphabetical orders of theirs names

	Can we create conditional events??
	-> yes , you can hcreate conditional event triggers by suing the when clause.
*/

-- Event Triggers events
/*
	ddl_command_start:-> this event occures just before create alter or 
	drop ddl command is execute.
	ddl_command_end: -> This event occurs just AFTER a CREATE,ALTER,or DROP 
	command has finished executing.
	table_rewrite:-> This event occurs jsust before the table is rewritten by some 
	actions of the commands ALTER TABLE and ALTER TYPE
	sql_drop:-> This event occurs just before the ddl_command_end even for the commands
	that drop database object.

	Event Trigger Variable:
	TG_TAG:-> it contains the 'TAG' or the command for which trgger is executed
	TG_EVENT:-> This variable contains the event name, which can be ddl_command_start etc.
	
*/

-- Creating an audit trial eent trigger
CREATE TABLE audit_ddl(
		audit_ddl_id SERIAL PRIMARY kEY,
		username TEXT,
		ddl_event TEXT,
		ddl_command TEXT,
		ddl_add_time TIMESTAMPTZ
);

CREATE OR REPLACE FUNCTION fn_evnt_audit_ddl()
RETURNS EVENT_TRIGGER
LANGUAGE PLPGSQL
SECURITY DEFINER
AS
$$
	BEGIN
		-- insert
		INSERT INTO audit_ddl
		(
			username,
			ddl_event,
			ddl_command,
			ddl_add_time
		)
		VALUES
		(
			session_user,
			TG_EVENT,
			TG_TAG,
			NOW()
		);
		-- raise notice
		RAISE NOTICE 'DDL activity is added!!';
	END;
$$

-- create event tirgger without condition
CREATE EVENT TRIGGER trg_evnt_audit_ddl
ON ddl_command_start
EXECUTE PROCEDURE fn_evnt_audit_ddl();

-- create event tirgger without condition
CREATE EVENT TRIGGER trg_evnt_audit_ddl
ON ddl_command_start
WHEN
	TAG IN ('CREATE TABLE')
EXECUTE PROCEDURE fn_evnt_audit_ddl();

CREATE TABLE audit_ddl_test(
	i INT
);
SELECT * FROM audit_ddl;


-- Drop a evebt trigger
DROP TRIGGER disallow_pk_change;
DROP EVENT TRIGGER trg_evnt_audit_ddl;







-- What is transaction
/*
	1. Our databaseis most vulnerable to damages while we or someone else is changing it.
	2. If a software or hardware failure occurs while the change is in progress, a database
		may be left in an indeterminate staate.
	3. A transactin is a list of commands that we want to run on our database to make changes on 
		inforamtions.
	4. A transaction bundles multiple steps or operations into a single, ALL-OR-NOTHING operation.
	5. SQL protects our database by restricting operations that can change it so they can occure
		only WITHIN Transactions.
	6. There are four main transaction commands, that protect from hard.both accidental and intentional.
		-- COMMIT
		-- ROLLBACK
		-- GRANT
		-- REVOKE
	7. Its possible for a hardware or software problem to occur and as a result your database is susceptible
		to damage.
	8. To minimize the change of damage, the DBMS close the window of vulnerability as much as possible by
		performing ALL operatoins that affect the database within a transaction and then comitting all these
		changes at once at the end of the transaction
	9. In a multi user system, database corruption or incorrect results are possible even if no hardware or
		software failure occure. Interactions between two or more users who access the same table at the 
		same time can cause serious data issues and more. By restriciting changes so that they occur only withing
		transactions, SQL addresss these problems accordingly.
	
*/

-- How SQL protect our database during transactions
/*
	1. During a transaction, SQL record every operation performed on the data in a log file.
	2. If anything interrupts the transaction BEFORE the COMMIT statement ends the transactions, you can
		restore the system to its original state by issuing a ROLLBACK statement.
	3. The ROLLBACK processes the transaction log in REVERSE, undoing all the actions that took place in the
		transaction.
*/

-- An ACID database
/*
	1. Database designed often use the term that "they want their database to have ACID"
	2. ACID is simply an acronym for
		A Atomicity
		C Consistency
		I Isolation
		D Durability

		All of the above four characteristic are necessary to protect a database from corruption
		It is like All or nothing

		Atomicity:
			Database transactions should be 'atomic' in nature i.e
				- The ENTIRE TRANSACTION should be treated as an individual unit.
				- Either it is executed in this entirely or the db is restored to its original state 
					before the transaction was executed.

		Consistency:
			The meaning of consistency here is not consistent; it should vary from applicaiton to app
				- For example, in a bank application or environment, when you transfer funds from one 
				account to another, you want the total amount of the money from both account to 
				be same at the end of transacton. Over here consistency means more of a balanced approach 
				before and after a transaction is executed.

		Isolation:
			Database transactons should be totally isolated from other transactions that execute at the same
			time.
				- If the transaction are SERIALIZED, then only total isolation is achieved.

		Durability
			After a transaction has comitted or rolled back, we should be able to count on the database 
			BEING in the proper state.
				- Even if your system suffers a hard crash or any software downturn after a commit, but
				before stored to disk, a well designed and durable DBMS should gurantee that UPON
				RECOVERY from the crash,the database can be restored to its PROPER STATE!.
*/

-- Create transaction

CREATE TABLE accounts(
	account_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	balance INTEGER NOT NULL
);
INSERT INTO accounts(name,balance) VALUES
('Adam',100),
('Bob',100),
('Linda',100);

SELECT * FROM accounts;

-- Transaction analysis
/*
	1. We connect to our postgresql serve rvia a 'connection' e.g this editor is ay connection #1
	2. Lets create another connection i.e Connection #2 by launcing another query editor window
	3. Lets create/open a transaction
*/

BEGIN;

-- 4. lets update the data in connection #1
UPDATE accounts
SET balance = balance - 50
WHERE name='Adam';
SELECT * FROM accounts;
COMMIT;

-- How to fix aborted transaction
BEGIN;
SELECT * FROM klsdjfldksjf;
SELECT * FROM accounts;
ROLLBACK;
SELECT * FROM accounts;

-- How to fix transactions on crash
-- 1. lets update all balance to 200
UPDATE accounts SET balance = 200;

-- 2. view the data
SELECT * FROM accounts;

-- 3. Lets begin with BEGIN;
BEGIN;
UPDATE accounts
SET balance = balance - 50
WHERE name = 'Adam';

SELECT * FROM accounts;

-- 4. Now lets mimic a connection error and see the effect
-- Remember we did not use the COMMIT on this connection before the crash, so PostgreSQL will ROLLBACK to 
-- last transaction state automatically.

-- Using Savepoints
/*
	1. Simple ROLLBACK and COMMIT statements enable us to write or undo an ENTIRE TRANSACTION.
		however, we might want sometimes a support for a ROLLBACK of PARTIAL TRANSACTION.
	2. To support the ROLLBACK of PARTIAL TRANSACTION, we must put PLACEHOLDERS at strategic
		location of the transaction block. Thus if a rollback is required, you can read back on the said placeholder.
	3. In PostgreSQL these placeholders are called 'Savepoints'

	4. Syntax 
		SAVE savepoint_name;

	5. Each full building block with transaction will look like;
		BEGIN;
			<your valid statement>
			SAVEPOINT savepoint1;
			<your error_statement>
			ROLLBACK TO savepoint1;
		COMMIT;
*/

-- Using savepoints with transaction
SELECT * FROM accounts;
BEGIN;

	UPDATE accounts
	SET balance = balance - 50
	WHERE name='Adam';

	SELECT * FROM accounts;

	SAVEPOINT first_update;

	UPDATE accounts
	SET balance = balance - 50
	WHERE name='Adam';

	SELECT * FROM accounts;

	ROLLBACK TO first_update;

	SELECT * FROM accounts;
COMMIT;







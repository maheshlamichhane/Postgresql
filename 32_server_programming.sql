-- PostgreSQL as a development platform??
/*
	Why anyone should choose the PostgreSQl as a development platform??
	
	Cost of acquisition:
	Oracle:-> Free edition -> enterprise sales -> licensing cost
	Microsoft SQL:-> Visible prices but with variation based on your database size/design etc.
	Open Source:-> No licensing cost,No service contact cost
	MySQL,PostgreSQL:-> Very hard cost of aquisition to beat


	Developers Community
	Regular good updates.vast no of developer in market.

	Predictability
	A stricter adherence to standards comes at the cost of not allowing ambigious behaviour.
	Not allowing ambiguos behaviour makes the developers life more difficult.

*/

-- Procedural languages
/*
	1. PostgreSQL is capable of executing server-side code.
	2. The user can create functions in following built in programming language like SQL,PL/pgSQL,C
	3. Additional language supports are: PL/Python,PL/Perl,PL/Java
	4. The language can be added or removed from a running version of postgresql.
	5. Any function defined using the avoce languages can also be created or dropped while postgresqlis running.
	6. Language have full access to postgresql internal function,data entities -> permissioning.
*/

-- Keep the data on the server
/*
	Server VS Application Layer
	1. the data will be much happier if you kept it at the server end, and the
		performance will be much better when modifying data.
*/

-- Functions vs procedures
/*
	1. The term stored procedure has traditionally been used to actually talk about a function.
	2. A function is a normal SQL statement,not allowed to start or commit transactions
		Eg: SELECT myfunc(id) FROM large_table;
	3. A procedure is a 
		-- able to control transactions 
		-- even run multiple transctions one after the other
		-- you cannot run it inside a select statement, you have to call it.
	4. Functions are around quite some time, but procedure were introduced in pssql 11 onwards.
	
*/

-- User defined functions
/*
	1. The ability to write user-defined functions is the powerhouse faature of postgresql.
	2. Functions
		-- can be written in many different programming languages.
		-- can use any kin dof control structure that the language provides.
		-- for untrusted languages, they can perform any operation that is availabe in pssql.
*/

-- Structure of a function
CREATE FUNCTION func_name (p1 type,p2 type,p3 type, ...., pn type)
RETURNS return_type AS 
BEGIN
	-- function logic
END;
LANGUAGE language_name


	






	
	
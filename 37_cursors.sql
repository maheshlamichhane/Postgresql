-- Understanding row by row operaiton
/*
	1. SQL retrieval operations work sets of rows as 'result sets' or 'dataset'.
	2. The rows returns are all the rows that returns match a SQL statement. Either zero or more of them.
	3. e.g When you use a simple SELECT statement, there is no way to get the first row, the next row, or
		the previous 5 rows etc. and this is a how relational DBMS works.
	4. Traditional procedural languages like python, php, etc can operates on a row by row.
	5. Sometimes you need to step through rows FORWARD or BACKWARD and ONE or MORE at a time. This is waht cursor 
		is used for.
	6. A cursor enable SQL to retrieve(or update or delete) a single row at a time.
	7. A cursor is like a pointer that point or locate a specific table row.
	8. A curosr is a database query store on the DBMS server - not a SELECT statement but the RESULT SET 
		retrieve by that statement.
	9. Once the cursor is active or stored, you can; SELECT,UPDATE or DELET a row at which the cursor is pointing.
	
*/

-- Using cursors with procedural language
/*
	1. Cursor are very valuable if you want to retrieve SELECTED ROWS from a table..
	2. Once retrieved, you can check the contents of the reult sets, and perform different operations on those
		contents.
	3. However, Please note SQL can't perform this sequence of operations by itself. SQL can retrieve the
	rows but ideally the operations should be done by procedural language based on contents.
	4. Procedural and non-procedural language:-> In PROCEDURAL language, the program code is written as a 
		sequence of instructions. user has to specify what to do and also how to do. these instruction are
		executed in sequential order.These instructions are written to solve specific problems.
		Examples:FORTRAN,COBOL,BASIC,C etc.
	  	In the NON-PROCEDURAL language, the user has to specify only "what to do" and not "how to do".
		 Exampless:SQL,LISP,PROLOG
*/

-- Steps to create curosrs
/*
	Before using the curosrs, following steps are requried;

	1. DECLARE
		A cursor must be DECCLARE before is is to be used.This does not retrieve any data, it just defines the 
		SELECT statement to be used and any other cursor options.
	2. OPEN
		Once it is declare, it must be OPENed for used.This process retrieves the data using the define 
		SELECT statement.
	3. FETCH
		With the cursor populated with data, individual rows can be fetched as per needed
	4. CLOSE
		When you do not need the cursor, it must be closed. This operation then deallcate memory etc back to 
		the DBMS.
	5. Once a cursor is declared, it may be opened, fetched and close as often. asneeded.
	6. So the steps are;
		DECLARE -> OPEN -> FETCH -> CLOSE
*/

-- Create a cursor
-- Decalre a cursor using refcursor data type
DECLARE cursor_name refcursor;

-- Create a cursor that bounds to a query expression
cursor-name [cursor-scrollability] CURSOR [(name datatype, name datatype...)]
FOR query-expression
DECLARE
	cur_all_movies CURSOR
	FOR
		SELECT
			movie_name,
			movie_length
		FROM movies;

-- Create a cursor with query parameters
DECLARE
	cur_all_movies_by_year CURSOR (custom_year integer)
	FOR
		SELECT
			movie_name,
			movie_length
		FROM movies
		WHERE EXTRACT('YEAR' FROM release_date) = custom_year;

-- Opening a cursor
-- Openning a unbount cursor
OPEN unbount_cursor_variable[[NO] SCROLL] FOR query;
OPEN cur_directors_us FOR SELECT first_name,last_name,date_of_birth FROM directors
WHERE nationality='American';

-- Openning a unbount cursor with dynamic query
OPEN unbouund_cursor_variable[[NO] SCROLL]
FOR EXECUTE
	query-expression [using expression[,...]];
my_query: = 'SELECT DISTINCT(NATIONALITY) FROM directors ORDER BY $1';
OPEN cur_directors_nationality
FOR EXECUTE
	my_query USING sort_fiedl;

-- Bound cursor
OPEN cursor_variable[(name:=value,name:=value...)];
OPEN cur_all_movies;
DECLARE
	cur_all_movies_by_year CURSOR (custom_year integer)
	FOR
		SELECT
			movie_name,
			movie_length
		FROM movies
		WHERE EXTRACT('YEAR' FROM release_date) = custom_year;
OPEN cur_all_movies_by_year(custom_year:=2010)


-- Using cursors
-- 1. Follwoing operations can be done once a cursor is opened. 
FETCH,MOVE,UPDATE,or DELETE statement
-- 2. FETCH statement
FETCH [direction{FROM | IN}] cursor_variable
INTO target_variable;
FETCH cur_all_movies into row_movie

-- 3. Direction
-- By default a cursor gets the next row if you don't specify the direction explicitly.
-- NEXT,LAST,PRIOR,FIRST,ABSOLUTE count,RELATIVE count,FORWARD,BACKWARD
FETCH LAST FROM row_movie INTO movie_title,movie_release_year

-- If you enable scroll at the declaration of the cursor, they can only you can use;
FORWARD
backward

-- 3. Moving the cursor
-- If you want to move the cursor only without retrieving any row, you will use the move statement.
MOVE [direction{FROM|IN}] cursor_variable;
MOVE cur_all_movies;
MOVE LAST FROM cur_all_movies;
MOVE relative -1 FROM cur_all_movies;
MOVE FORWARD 4 FROM cur_all_movies;

-- Updating data usng cursor
/*
	Once a cursor is positioned, we can delete or update row identifying by the cursor using the following
	statement 
	DELETE WHERE CURRENT OF or
	UPDATE WHERE CURRENT OF
*/

UPDATE movies
SET YEAR(release_date) = custom_year
WHERE 
	CURRENT OF cur_all_movies;

-- Closing a cursor
CLOSE cursor_variable


-- PL/pgSQL cursors with block
-- 1. Lets use the cursor to list all movies names
SELECT * FROM movies ORDER BY movie_name;

DO
$$
	DECLARE
		output_text text DEFAULT '';
		rec_movie record;
		cur_all_movies CURSOR 
		FOR
			SELECT * FROM movies;
		
	BEGIN
		OPEN cur_all_movies;
		LOOP
			FETCH cur_all_movies INTO rec_movie;
			EXIT WHEN NOT FOUND;
			output_text := output_text || '|' || rec_movie.movie_name;
		END LOOP;
		RAISE NOTICE 'ALL MOVIES NAMES %',output_text;
	END;
$$

-- Using cursors with a function
CREATE OR REPLACE FUNCTION fn_get_movie_names_by_year(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
	DECLARE
		movie_names TEXT DEFAULT '';
		rec_movie record;
		cur_all_movies_by_year CURSOR(custom_year integer)
		FOR
			SELECT
				movie_name,
				EXTRACT('YEAR' FROM release_date) AS release_year
			FROM movies
			WHERE
				EXTRACT('YEAR' FROM release_date) = custom_year;
			
	BEGIN
		OPEN cur_all_movies_by_year(custom_year);
		LOOP
			FETCH cur_all_movies_by_year INTO rec_movie;
			EXIT WHEN NOT FOUND;
			IF rec_movie.movie_name LIKE '%Star%' THEN
				movie_names := movie_names || ',' || rec_movie.movie_name || ':' || rec_movie.release_year;
			END IF;
		END LOOP;
		CLOSE cur_all_movies_by_year;
		RETURN movie_names;
	END;
$$

SELECT fn_get_movie_names_by_year(1977);
select * from movies where movie_name like '%Star%'

FETCH NEXT FROM my_cursor;       -- Default
FETCH PRIOR FROM my_cursor;
FETCH FIRST FROM my_cursor;
FETCH LAST FROM my_cursor;
FETCH ABSOLUTE 5 FROM my_cursor;
FETCH RELATIVE -2 FROM my_cursor;
FETCH FORWARD 3 FROM my_cursor;
FETCH BACKWARD 1 FROM my_cursor;

-- Scrollable cursor with FIRST
CREATE OR REPLACE FUNCTION fn_get_movie_names_by_year_scrollable_first(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
DECLARE
	movie_names TEXT DEFAULT '';
	rec_movie record;
	cur_all_movies_by_year SCROLL CURSOR(custom_year integer)
	FOR
		SELECT
			movie_name,
			EXTRACT('YEAR' FROM release_date) AS release_year
		FROM movies
		WHERE
			EXTRACT('YEAR' FROM release_date) = custom_year;

BEGIN
	OPEN cur_all_movies_by_year(custom_year);

	-- Fetch only the FIRST row
	FETCH FIRST FROM cur_all_movies_by_year INTO rec_movie;

	IF FOUND THEN
			movie_names := movie_names || rec_movie.movie_name || ':' || rec_movie.release_year;
	END IF;

	CLOSE cur_all_movies_by_year;

	RETURN movie_names;
END;
$$;


SELECT fn_get_movie_names_by_year_scrollable_first(1979);

-- Scrollable cursor with Last
CREATE OR REPLACE FUNCTION fn_get_movie_names_by_year_scrollable_LAST(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
DECLARE
	movie_names TEXT DEFAULT '';
	rec_movie record;
	cur_all_movies_by_year SCROLL CURSOR(custom_year integer)
	FOR
		SELECT
			movie_name,
			EXTRACT('YEAR' FROM release_date) AS release_year
		FROM movies
		WHERE
			EXTRACT('YEAR' FROM release_date) = custom_year;

BEGIN
	OPEN cur_all_movies_by_year(custom_year);

	-- Fetch only the FIRST row
	FETCH LAST FROM cur_all_movies_by_year INTO rec_movie;

	IF FOUND THEN
			movie_names := movie_names || rec_movie.movie_name || ':' || rec_movie.release_year;
	END IF;

	CLOSE cur_all_movies_by_year;

	RETURN movie_names;
END;
$$;


SELECT fn_get_movie_names_by_year_scrollable_last(1979);


-- Scrollable cursor with Previous 
CREATE OR REPLACE FUNCTION fn_get_movie_names_before_previous(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
DECLARE
	movie_names TEXT DEFAULT '';
	rec_movie record;
	cur_all_movies_by_year SCROLL CURSOR(custom_year integer)
	FOR
		SELECT
			movie_name,
			EXTRACT('YEAR' FROM release_date) AS release_year
		FROM movies
		WHERE
			EXTRACT('YEAR' FROM release_date) = custom_year
		ORDER BY release_date;  -- Ensure consistent order
BEGIN
	OPEN cur_all_movies_by_year(custom_year);

	-- Step 1: Go to LAST row
	FETCH LAST FROM cur_all_movies_by_year INTO rec_movie;

	IF FOUND THEN
		-- Optional: capture last row
		movie_names := 'Last: ' || rec_movie.movie_name || ':' || rec_movie.release_year;

		-- Step 2: Move to row before last
		FETCH PRIOR FROM cur_all_movies_by_year INTO rec_movie;

		IF FOUND THEN
			-- Append second-last row
			movie_names := movie_names || ' | Before Last: ' || rec_movie.movie_name || ':' || rec_movie.release_year;
		END IF;
	END IF;

	CLOSE cur_all_movies_by_year;

	RETURN movie_names;
END;
$$;

SELECT fn_get_movie_names_before_previous(1979);
select * from movies where EXTRACT('YEAR' FROM release_date) = '1979';\

-- Scrollable cursor with ABSOLUTE 2(move cursor to 2 position) 
CREATE OR REPLACE FUNCTION fn_get_movie_names_before_absolute(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
DECLARE
	movie_names TEXT DEFAULT '';
	rec_movie record;
	cur_all_movies_by_year SCROLL CURSOR(custom_year integer)
	FOR
		SELECT
			movie_name,
			EXTRACT('YEAR' FROM release_date) AS release_year
		FROM movies
		WHERE
			EXTRACT('YEAR' FROM release_date) = custom_year
		ORDER BY release_date;  -- Ensure consistent order
BEGIN
	OPEN cur_all_movies_by_year(custom_year);

	-- Step 1: Go to LAST row
	FETCH ABSOLUTE 2 FROM cur_all_movies_by_year INTO rec_movie;

	IF FOUND THEN
		-- Optional: capture last row
		movie_names := 'Last: ' || rec_movie.movie_name || ':' || rec_movie.release_year;
	END IF;

	CLOSE cur_all_movies_by_year;

	RETURN movie_names;
END;
$$;

SELECT fn_get_movie_names_before_absolute(1979);
select * from movies where EXTRACT('YEAR' FROM release_date) = '1979';

--
-- Scrollable cursor with RELATIVE -1 
CREATE OR REPLACE FUNCTION fn_get_movie_names_before_relative(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
DECLARE
	movie_names TEXT DEFAULT '';
	rec_movie record;
	cur_all_movies_by_year SCROLL CURSOR(custom_year integer)
	FOR
		SELECT
			movie_name,
			EXTRACT('YEAR' FROM release_date) AS release_year
		FROM movies
		WHERE
			EXTRACT('YEAR' FROM release_date) = custom_year
		ORDER BY release_date;  -- Ensure consistent order
BEGIN
	OPEN cur_all_movies_by_year(custom_year);

	-- Step 1: Go to LAST row
	FETCH LAST FROM cur_all_movies_by_year INTO rec_movie;

	IF FOUND THEN
		-- Optional: capture last row
		movie_names := 'Last: ' || rec_movie.movie_name || ':' || rec_movie.release_year;

		-- Step 2: Move to row before last
		FETCH RELATIVE -1 FROM cur_all_movies_by_year INTO rec_movie;

		IF FOUND THEN
			-- Append second-last row
			movie_names := movie_names || ' | Before Last: ' || rec_movie.movie_name || ':' || rec_movie.release_year;
		END IF;
	END IF;

	CLOSE cur_all_movies_by_year;

	RETURN movie_names;
END;
$$;

SELECT fn_get_movie_names_before_relative(1979);
select * from movies where EXTRACT('YEAR' FROM release_date) = '1979';\


--
-- Scrollable cursor with FORWARD 1 ROW fetch
CREATE OR REPLACE FUNCTION fn_get_movie_names_by_year_scrollable_forward(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
DECLARE
	movie_names TEXT DEFAULT '';
	rec_movie record;
	cur_all_movies_by_year SCROLL CURSOR(custom_year integer)
	FOR
		SELECT
			movie_name,
			EXTRACT('YEAR' FROM release_date) AS release_year
		FROM movies
		WHERE
			EXTRACT('YEAR' FROM release_date) = custom_year;

BEGIN
	OPEN cur_all_movies_by_year(custom_year);

	-- Fetch only the FIRST row
	FETCH FIRST FROM cur_all_movies_by_year INTO rec_movie;

	IF FOUND THEN
			movie_names := movie_names || '| First:' || rec_movie.movie_name || ':' || rec_movie.release_year;
	END IF;

	FETCH FORWARD 1 FROM cur_all_movies_by_year INTO rec_movie;

		IF FOUND THEN
			movie_names := movie_names || ' | Forward Second: ' || rec_movie.movie_name || ':' || rec_movie.release_year;
		END IF;

	CLOSE cur_all_movies_by_year;

	RETURN movie_names;
END;
$$;

-- update cursor.
CREATE OR REPLACE FUNCTION fn_update_classic_movies(year_cutoff integer)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
    rec_movie record;
    cur_movies CURSOR FOR
        SELECT movie_id, movie_name
        FROM movies
        WHERE EXTRACT('YEAR' FROM release_date) < year_cutoff
        FOR UPDATE;  
BEGIN
    OPEN cur_movies;

    LOOP
        FETCH cur_movies INTO rec_movie;
        EXIT WHEN NOT FOUND;

        -- Update movie name by appending ' (Classic)'
        UPDATE movies
        SET movie_name = movie_name || ' (Classic)'
        WHERE movie_id = rec_movie.movie_id;
    END LOOP;

    CLOSE cur_movies;
END;
$$;















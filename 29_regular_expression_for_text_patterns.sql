-- Text to structured data

-- Case formatting
SELECT UPPER('world');
SELECT LOWER('loweR');
SELECT INITCAP('hello mahesh');


-- Character information
SELECT char_length('world');

-- Removing charactes
SELECT TRIM(' Hello ');

-- Using regular expressions for text patterns
-- . :-> A dot is a wildcard that finds any character expect a new line
-- [FGz] :-> Any character in the square bracket[], here is F,G or z.
-- [a-z] :-> A range of characters. Here lowercase a to z.
-- [^a-z] :-> The caret negatee the match.here not lowercase a to z.
-- \w :-> Any word character or underscore. Same as [A-Za-z0-9_].
-- \d :-> Any digit
-- \t :-> tab character
-- \s :-> A space
-- \n : -> A newline character
-- \r :-> Carriage return character
-- ^ :-> Match at the start of the string.
-- $ :-> Match at the end of the string
-- ? :-> Get the preceding match zero or one time
-- * :-> Get the precedind match zero or more time.
-- + :-> Get the precedind match one or more time.
-- {m} :-> Get the precedind match exactly m times
-- {m,n} :-> Get the precedind match between m and n times.
-- a|b :-> The pipe | denotes alternation. Find eithere a or b.
-- () :-> create a report a capture group or set precedence
-- (?: ):-> Negate the reporting of a capture group

-- SIMILLAR TO operator
-- The SIMILAR TO operator returns true or flase depending on whether its pattern matches the given string.
-- It is simillar to LIKE,except that it interprets the pattern using the SQL standards definition of a regjular expression.
SELECT 'same' SIMILAR TO 'same';
SELECT 'same' SIMILAR TO 'Same';
SELECT 'same' SIMILAR TO 's';
SELECT 'same' SIMILAR TO 's%'
SELECT 'same' SIMILAR TO '%s';
SELECT 'same' SIMILAR TO 'sa%';
SELECT 'same' SIMILAR TO '%(s|a)%';
SELECT 'same' SIMILAR TO '(m|e)%';

-- POSIX regular expressions
-- POSIX regular expressions provide a more powerful means for pattern matching than like and similar to operators.
-- it supports following 
-- ~ (Matches regular expression, case sensitive)
-- ~* (Matches regular expression, case insensitive)
-- !~ (Does not match regular expression, case sensitive)
-- !~* (Does not match regular expression, case insensitive)

SELECT 'same' ~ 'same' as result;
SELECT 'same' ~ 'Same' as result;

SELECT 'same' ~* 'Same' as result;
SELECT 'same' !~ 'Same' as result;
SELECT 'same' !~* 'Same' as result;

-- Substring with POSIX regular expressions
-- single character
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '.');

-- all characters
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '.*');

-- any characters after say 'movie'
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM 'movie.+');

-- one or more word characters from the start
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '\w+');

-- one or more word characters followed by any characters from the end
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '\w+.$');


-- a.m or p.m
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '\d{1,2}');
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '\d{1,2} (a.m|p.m)');
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '\d{1,2} (?:a.m|p.m)');

-- Lets get the year
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM '\d{4}');

-- Either the word 'Nov' or 'Dec'
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM 'Nov|Dec');

-- Dec 10, 2020
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM 'Dec');
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM 'Dec \d{2},');
SELECT substring('The movie will start at 8 p.m on Dec 10, 2020.' FROM 'Dec \d{2}, \d{4}');


-- REGEXP_MATCHES Function
SELECT REGEXP_MATCHES('Amazing #PostgreSQL','#([A-Za-z0-9_]+)');

-- multiple matches
SELECT REGEXP_MATCHES('Amazing #PostgreSQL, #SQL','#([A-Za-z0-9_]+)','g');

-- REGEP_REPLACE() function
SELECT REGEXP_REPLACE('Adnan Waheed','(.*) (.*)','\2 \1');

-- Have only character data
SELECT REGEXP_REPLACE('ABCD12345xyz','[[:digit:]]','','g');
SELECT REGEXP_REPLACE('ABCD12345xyz','[[:alpha:]]','','g');

-- Data change
SELECT REGEXP_REPLACE('2019-10-10','\d{4}','2020');

-- REGEXP_SPLIT_TO_TABLE Function
SELECT REGEXP_SPLIT_TO_TABLE('1,2,3,4',',');
SELECT REGEXP_SPLIT_TO_TABLE('Adnan,James,Linda',',');

-- REGEXP_SPLIT_TO_ARRAY
SELECT REGEXP_SPLIT_TO_ARRAY('Adnan,James,Linda',',');
SELECT REGEXP_SPLIT_TO_ARRAY('Adnan,James,Linda',' ');
SELECT ARRAY_LENGTH(REGEXP_SPLIT_TO_ARRAY('Adnan,James,Linda',' '),1);







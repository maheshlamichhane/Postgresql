-- Character set support
/*
	The whole idea over here is: 'How to make PostgreSQL support global language data'!!!

	1. PostgreSQL allows you to store text in a variety of character sets
		- single-byte character sets ISO 8859 series and
		- multiple-byte character sets EUC,UTF-8 and Mule internal code
	2. The defautl character set is selected while initializing your PostgreSQL
		database cluster using initdb.
	3. You can have multiple databases each with a different character set.
*/

-- To Create a UTF-8 based database
CREATE DATABASE database_utf8
WITH OWNER "postgres"
ENCODING 'UTF8'
LC_COLLATE = 'en_US.UTF-8'
LC_CTYPE = 'en_US.UTF-8'
TEMPLATE template0;

-- To create a say korean based language database with char set EUC_KR
CREATE DATABASE database_euc_kr
WITH OWNER "postgres"
ENCODING 'EUC_KR'
LC_COLLATE = 'ko_KR.euckr'
LC_CTYPE = 'ko_KR.euckr'
TEMPLATE template0;

-- Client and Server Encoding
/*
	1. The first notation to understand when processing text in any program 
		is of coursethe notion of encoding.
	2. An encoding is a aparticular representation of characters in bits and bytes
*/

-- Server Encoding
SHOW SERVER_ENCODING;

-- Client Encoding
SHOW CLIENT_ENCODING;

-- Small project
CREATE TABLE table_encoding(
lang_id SERIAL PRIMARY KEY,
lang_code TEXT,
lang_text TEXT
);
INSERT INTO table_encoding(lang_code,lang_text) VALUES
('Georgian','გამარჯობა');

SELECT * FROM table_encoding;

-- change client encoding
SET CLIENT_ENCODING TO Latin1;









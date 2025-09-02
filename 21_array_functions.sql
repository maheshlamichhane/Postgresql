-- Array functions
SELECT
	INT4RANGE(1,6) AS "Default [( = closed - opened",
	NUMRANGE(1.4213,6.286,'[]') AS "[] closed - closed",
	DATERANGE('20100101','20201220','()') AS "Dates () = opened - opened",
	TSRANGE(LOCALTIMESTAMP, LOCALTIMESTAMP + INTERVAL '8 DAYS', '(]')
	AS "opened-closed";
	
SELECT 
	ARRAY[1,2,3] AS "INT arrays",
	ARRAY[2.12225::float] AS "floating numbers with putting explicit typing",
	ARRAY[CURRENT_DATE,CURRENT_DATE + 5];

-- Using operators 
SELECT
	ARRAY[1,2,3,4] = ARRAY[1,2,3,4] AS "Equality",
	ARRAY[1,2,3,4] = ARRAY[1,2,3] AS "Equality",
	ARRAY[1,2,3,4] <> ARRAY[2,3,4,5] AS "Not Equal to",
	ARRAY[1,2,3,4] < ARRAY[2,3,4,5] AS "Less than",
	ARRAY[1,2,3,4] <= ARRAY[2,3,4,5] AS "Less than and equal to",
	ARRAY[1,2,3,4] > ARRAY[2,3,4,5] AS "Greater than",
	ARRAY[1,2,3,4] >= ARRAY[2,3,4,5] AS "Greater than and equal to";


-- For ranges
SELECT
	INT4RANGE(1,4) @> INT4RANGE(2,3) AS "Contains",
	DATERANGE(CURRENT_DATE,CURRENT_DATE + 30) @> CURRENT_DATE + 15 AS "Contains value",
	NUMRANGE(1.6,5.2) && NUMRANGE(0,4);

-- Inclusion operators
-- @>, <@, && 
SELECT
	ARRAY[1,2,3,4] @> ARRAY[2,3,4] AS "Contains",
	ARRAY['a','b'] <@ ARRAY['a1','b1','c'] AS "Contained by",
	ARRAY[1,2,3,4] && ARRAY[21,31,41] AS "Is overlap";

SELECT 
	INT4RANGE(1,4) @> INT4RANGE(2,3) AS "Contains",
	DATERANGE(CURRENT_DATE,CURRENT_DATE + 30) @> CURRENT_DATE + 15 AS "Contains value",
	NUMRANGE(1.6,5.2) && NUMRANGE(0,4);

-- Array consturction
SELECT
	ARRAY[1,2,3] || ARRAY[4,5,6] AS "Combine arrays";
SELECT
	ARRAY_CAT(ARRAY[1,2,3], ARRAY[4,5,6]) AS "Combine arrays via ARRAY_CAT";
SELECT
	4 || ARRAY[1,2,3] AS "Adding to an array";
SELECT
	ARRAY_PREPEND(4, ARRAY[1,2,3]) AS "Using preprend";
SELECT
	ARRAY[1,2,3] || 4 AS "Adding to an array";
SELECT 
	ARRAY_APPEND(ARRAY[1,2,3],4) AS "Using append";


-- Array metadata functions
SELECT
	ARRAY_NDIMS(ARRAY[[11],[2]]) AS "Dimensions";
SELECT
	ARRAY_NDIMS(ARRAY[[1,2,3],[4,5,6]]);
SELECT
	ARRAY_DIMS(ARRAY[[1],[2]]);
SELECT
	ARRAY_LENGTH(ARRAY[1,2,3,4],1);
SELECT
	ARRAY_LENGTH(ARRAY[1,2,3,4,5,6],1);
SELECT
	ARRAY_LOWER(ARRAY[1,2,3,4],1);
SELECT
	ARRAY_UPPER(ARRAY[1,2,2,4],1);
SELECT
	CARDINALITY(ARRAY[[1],[2],[3],[4]]),
	CARDINALITY(ARRAY[[1],[2],[3],[4],[5]]);


-- Array search functions
SELECT
	ARRAY_POSITION(ARRAY['Jan','Feb','March','April9'],'Feb');
SELECT
	ARRAY_POSITION(ARRAY[1,2,3,4],3);


-- Array modifications functions
SELECT
	ARRAY_CAT(ARRAY['Jan','Feb'],ARRAY['March','April']);
SELECT
	ARRAY_REMOVE(ARRAY[1,2,3,4,4],4);
SELECT 
	ARRAY_REPLACE(ARRAY[1,2,3,4],2,10);


-- Array comparision with IN, ALL, ANY and SOME
SELECT
	20 IN (1,2,20,40) AS "result";
SELECT
	20 NOT IN (1,2,20,40) AS "result";
SELECT
	25 = ALL(ARRAY[25,25]) AS "Results";
SELECT
	25 = ANY(ARRAY[1,2,25]) AS "Results";
SELECT
	25 = SOME(ARRAY[1,2,3,4]) AS "SOME";
SELECT
	25 = SOME(ARRAY[1,2,3,4,25]) AS "SOME";


-- Formatting and converting arrays
SELECT
	STRING_TO_ARRAY('1,2,3,4',',');
SELECT
	STRING_TO_ARRAY('1,2,3,4,ABC',',','ABC');
SELECT
	ARRAY_TO_STRING(ARRAY[1,2,3,4],'|');
SELECT
	ARRAY_TO_STRING(ARRAY[1,2,3,4,NULL],'|');
SELECT
	ARRAY_TO_STRING(ARRAY[1,2,3,4,NULL],'|','EMPTY_DATA');


-- Using Arrays in Tables
CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT[]
);
CREATE TABLE teachers1(
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT ARRAY
);

INSERT INTO teachers (name,phones)
VALUES
('Adam',ARRAY['(111)-222-3333','(555)-666-7777']);

INSERT INTO teachers (name,phones)
VALUES
('Linda','{"(111)-123-4567"}'),
('Jeff','{"(222)-555-3333","(444)-786-12345"}');


-- Query array data
SELECT name,phones FROM teachers;
SELECT name,phones[1] FROM teachers;
SELECT * FROM teachers WHERE phones[1] = '(111)-222-3333';

-- Modify Array contents
UPDATE teachers 
SET phones[2] = '(800)-123-4567'
WHERE teacher_id = 2;

-- Dimensions are ignored by PostgreSQlATE 
CREATE TABLE teachers2(
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT ARRAY[1]
);
INSERT INTO teachers2 (name,phones)
VALUES
('Jeff','{"(222)-555-3333","(444)-786-12345"}');


-- Display all array elements
SELECT teacher_id,name,unnest(phones) FROM teachers;

-- USING MULTI-DIMENSIONAL ARRAY
CREATE TABLE students(
	student_id SERIAL PRIMARY KEY,
	student_name VARCHAR(100),
	student_grade INTEGER[][]
);

INSERT INTO students (student_name,student_grade) 
VALUES ('s1','{80,2020}');










	
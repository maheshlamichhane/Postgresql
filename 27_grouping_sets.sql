-- Computing subtotals
-- Intro to summarization

-- Lets create ourt test table in which we will be calculating the subtotals
CREATE TABLE courses(
	course_id SERIAL PRIMARY KEY,
	course_name VARCHAR(100) NOT NULL,
	course_level VARCHAR(100) NOT NULL,
	sold_units INT NOT NULL
);

INSERT INTO courses (course_name,course_level,sold_units) VALUES
('Machine Learning with Paython','Premium',100),
('Data Science Bootcamp','Premium',50),
('Introduction to Python','Basic',200),
('Understanding MongoDB','Premium',100),
('Algorithim Design in Python','Premium',200);


SELECT * FROM courses;

SELECT * FROM courses
ORDER BY course_level,sold_units;

SELECT
	course_level,
	course_name,
	sold_units
FROM courses;

SELECT
	course_level,
	SUM(sold_units) AS "Total Sold"
FROM courses
GROUP BY course_level;

SELECT
	course_level,
	course_name,
	SUM(sold_units) AS "Total Sold"
FROM courses
GROUP BY course_level,course_name
ORDER BY course_level,course_name;

SELECT
	course_level,
	course_name,
	SUM(sold_units) AS "Total Sold"
FROM courses
GROUP BY ROLLUP(course_level,course_name)
ORDER BY course_level,course_name;

SELECT
	course_level,
	course_name,
	SUM(sold_units) AS "Total Sold"
FROM courses
GROUP BY course_level,
		ROLLUP(course_name)
ORDER BY course_level,course_name;


-- Adding subtotals with ROOLUP
CREATE TABLE inventory(
	inventory_id SERIAL PRIMARY KEY,
	category VARCHAR(100) NOT NULL,
	sub_category VARCHAR(100) NOT NULL,
	product VARCHAR(100) NOT NULL,
	quantity int
);
select * from inventory;
INSERT INTO inventory (category, sub_category,product,quantity) VALUES
('Furniture','Chair','Black',10),
('Furniture','Chair','Brown',10),
('Furniture','Desk','Blue',10),
('Equipment','Computer','Mac',5),
('Equipment','Computer','PC',5),
('Equipment','Monitor','Dell',10);

SELECT * FROM inventory;

-- lets group the data by category and sub_category. i.e product is broken down by category and sub category
SELECT
	category,
	sub_category,
	SUM(quantity) AS "Quantity"
FROM inventory
GROUP BY category,sub_category
ORDER BY category,sub_category;

-- What if we want to see the subtotal of each category and final total??
SELECT
	category,
	sub_category,
	SUM(quantity) AS "Quantity"
FROM inventory
GROUP BY ROLLUP(category,sub_category)
ORDER BY category,sub_category;

-- Using GROUPING with ROLLUP
SELECT
	category,
	sub_category,
	SUM(quantity) AS "Quantity",
	GROUPING(category) AS "Category Grouping",
	GROUPING(sub_category) AS "SubCategory Grouping"
FROM inventory
GROUP BY ROLLUP(category,sub_category)
ORDER BY category,sub_category;





-- OFFUTRE QUALITY CONTROL 
-- TEAM WHERE
-- Lydia Drabkin-Reiter, George Brignell-Cash, Edward Boynton, Andrew Scannell

-- W-01: Table Creation

CREATE TABLE student.ofwhere
(
	row_id int,
	order_id varchar(20),
	order_date varchar(20),
	ship_date varchar(20),
	ship_mode varchar(20),
	customer_id varchar(20),
	customer_name varchar(30),
	segment varchar(15),
	city varchar(75),
	state varchar(75),
	country varchar(50),
	postal_code varchar(10),
	market varchar(10),
	region varchar(25),
	product_id varchar(30),
	category varchar(20),
	sub_category varchar(25),
	product_name varchar(250),
	sales numeric,
	quantity int,
	discount numeric,
	profit numeric,
	shipping_cost numeric,
	order_priority varchar(10)
);

-- W-02: Table Alteration

-- Altering the two date columns, which were uploaded into SQL as a varchar, to the date format
ALTER TABLE student.ofwhere  
ALTER COLUMN order_date TYPE date
USING TO_DATE(order_date, 'DD/MM/YYYY');

ALTER TABLE student.ofwhere  
ALTER COLUMN ship_date TYPE date
USING TO_DATE(ship_date, 'DD/MM/YYYY');

-- Altering the data type of postal_code to integer
ALTER TABLE student.ofwhere  
ALTER COLUMN "postal_code" TYPE int
USING postal_code::integer;

--=--=-==-=-==-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=--


-- Quality Control testing

-- W-03: Count of Rows (51290)

SELECT 
	COUNT(*) as count_of_rows
FROM 
	student.ofwhere;

-- W-04: Count of Distinct Rows (51290)

SELECT 
	COUNT(DISTINCT(row_id)) as count_of_distinct_rows
FROM 
	student.ofwhere;

-- W-05: Count of Columns (24)

SELECT 
	COUNT(*) AS column_count
FROM 
	information_schema.columns
WHERE 
	table_schema = 'student'
  	AND table_name = 'ofwhere'
 ;

-- W-06: Sum of Column Sums (1882578768.62)
	
SELECT 
	ROUND((
	SUM(postal_code) +
	SUM(row_id) +
	SUM(sales) +
	SUM(quantity) +
	SUM(discount) +
	SUM(profit) +
	SUM(shipping_cost)
 	),2) AS sum_of_column_sums
 FROM
  student.ofwhere;
 
 -- W-07: Sum of Row Sums (1882578768.62)
-- We needed to add COALESCE to the postal_code column in order to replace the null entries so that they were summed as 0
 
SELECT 
	ROUND(SUM(
	ofw."row_id" +
	COALESCE(ofw."postal_code", 0) +
	ofw."sales" +
	ofw."quantity" +
	ofw."discount" +
	ofw."profit" +
	ofw."shipping_cost" 
	),2) AS sum_of_row_sums
FROM
	student.ofwhere ofw;

-- W-08: Row ID Date Format Check 

 SELECT
 	row_id,
 	order_date, 
 	ship_date 
 FROM 
 	student.ofwhere
 WHERE 
	row_id IN (27677, 21381, 48225) ;

-- W-09: Row ID Eyeball Check

SELECT 
	* 
FROM 
	student.ofwhere
WHERE 
	row_id IN (31483, 13190, 44410) ;


-- W-10: Count of NULLs: This code counts the number of null values in all columns of the table (41296)

select 
	count(*)
from
	student.ofwhere o 
where 		
	row_id is null or
	order_id is null or
	order_date is null or
	ship_date is null or
	ship_mode is null or
	customer_id is null or
	customer_name is null or
	segment is null or
	city is null or
	state is null or
	country is null or
	postal_code is null or
	market is null or
	region is null or
	product_id is null or
	category is null or
	sub_category is null or
	product_name is null or
	sales is null or
	quantity is null or
	discount is null or
	profit is null or
	shipping_cost is null or
	order_priority is null ; -- 41296


-- W-11: Sum, Min, Max Values for each Column

select
	round(sum("row_id"), 2) as Sum_row_id,
    round(min("row_id"), 2) as Min_row_id,
    round(max("row_id"), 2) as Max_row_id,
    round(sum("postal_code"), 2) as Sum_postal_code,
    round(min("postal_code"), 2) as Min_postal_code,
    round(max("postal_code"), 2) as Max_postal_code,
    round(sum("sales"), 2) as Sum_Sales,
    round(min("sales"), 2) as Min_Sales,
    round(max("sales"), 2) as Max_Sales,  
    round(sum("quantity"), 2) as Sum_quantity,
    round(min("quantity"), 2) as Min_quantity,
    round(max("quantity"), 2) as Max_quantity,
    round(sum("discount"), 2) as Sum_discount,
    round(min("discount"), 2) as Min_discount,
    round(max("discount"), 2) as Max_discount,
    round(sum("profit"), 2) as Sum_profit,
    round(min("profit"), 2) as Min_profit,
    round(max("profit"), 2) as Max_profit,
	round(sum("shipping_cost"), 2) as Sum_shipping_cost,
    round(min("shipping_cost"), 2) as Min_shipping_cost,
    round(max("shipping_cost"), 2) as Max_shipping_cost
from student.ofwhere;


-- W-12: Profit by Category

select 
	category ,
	sum(profit)
from 
	student.ofwhere o
group by 
	category  
order by 
	category ;

-- W-13: Adding a true profit (profit - shipping cost) column

ALTER TABLE student.ofwhere 
ADD COLUMN true_profit numeric;

UPDATE student.ofwhere
SET true_profit = profit - shipping_cost;

-- This just to check if the table is loaded correctly and am able to read it properly
select*
from workspace.default.brightcoffee_shop_sales 
limit 10;

--------------------------------------
-- checking the date range
--------------------------------------
--They staarted collecting the data on 2023-01-01
SELECT MIN(transaction_date)AS start_date
FROM workspace.default.brightcoffee_shop_sales; 

--when last did they collect data 2023-06-30
SELECT MAX(transaction_date)AS lastest_date
FROM workspace.default.brightcoffee_shop_sales;



 ---checking the store location
--------------------------------------
-- we have 3 store locations

SELECT DISTINCT store_location
FROM workspace.default.brightcoffee_shop_sales;

-------------------------------------------------
-- checking products sold across all stores
-------------------------------------------------
-- we have 9 products categories
SELECT DISTINCT product_category
FROM workspace.default.brightcoffee_shop_sales;

--we have 80 products detail
SELECT DISTINCT  product_category As product_name,
                 product_type,
                 product_detail AS category
FROM workspace.default.brightcoffee_shop_sales;


SELECT MIN(unit_price) AS cheapest_price,
       MAX(unit_price) AS expensive_price
FROM workspace.default.brightcoffee_shop_sales;


--------------------------------------------
SELECT COUNT(*) AS number_of_rows,
       COUNT(DISTINCT transaction_id) AS number_of_sales,
       COUNT(DISTINCT store_id) AS number_of_stores,
       COUNT(DISTINCT product_id) AS number_of_products
FROM workspace.default.brightcoffee_shop_sales;


-------------------------------------------------
--DATE FUNCTIONS  
SELECT  transaction_id,
        transaction_date, 
        DAYNAME(transaction_date)AS Day_name,
        Monthname(transaction_date)AS Month_name,
        transaction_qty*unit_price AS revenue_per_trans
FROM workspace.default.brightcoffee_shop_sales;


-- DATES
SELECT 
        transaction_date, 
        Dayname(transaction_date)AS Day_name,
        Monthname(transaction_date)AS Month_name,
        dayofmonth(transaction_date)AS day_of_month,
     
CASE 
  WHEN DAYNAME(transaction_date) IN ('Sun','Sat') THEN 'weekend'
  ELSE 'weekday'
END AS day_classification,
      

--TIME

CASE 
    WHEN  DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN 'morning'
    WHEN  DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'afternoon'
    WHEN  DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'evening'
    ELSE 'unknown'
END AS time_buckets,




-- COUNTS of id's


        COUNT(DISTINCT product_id) AS number_of_products, 
        COUNT(DISTINCT store_id) AS number_of_stores,
        COUNT(DISTINCT transaction_id) AS number_of_sales,
--revenue

        SUM(transaction_qty*unit_price)AS revenue_per_day,
  CASE 
    WHEN revenue_per_day <=50 THEN 'low spend'
    WHEN revenue_per_day BETWEEN 51 AND 100 THEN 'med spend'
    ELSE 'high spend'

    END AS spend_bucket,


--categorical column
  store_location,
  product_category,
  product_detail
FROM workspace.default.brightcoffee_shop_sales
GROUP BY transaction_date, 
        Dayname(transaction_date),
         Monthname(transaction_date),
         store_location,
         product_category,
         day_of_month,

         CASE 
           WHEN  DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN 'morning'
           WHEN  DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'afternoon'
           WHEN  DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'evening'
           ELSE 'unknown'
         END,
         CASE 
           WHEN DAYNAME(transaction_date) IN ('Sun','Sat') THEN 'weekend'
           ELSE 'weekday'
         END,

         product_detail;

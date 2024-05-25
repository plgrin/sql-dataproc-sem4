--Retrieve all sales in a specific month(may)
SELECT *
FROM sales_data
WHERE sale_date BETWEEN '2023-05-01' AND '2023-05-31';

-- Calculate the total sale_amount for each month
SELECT EXTRACT(YEAR FROM sale_date) AS year, EXTRACT(MONTH FROM sale_date) AS month, SUM(sale_amount) AS total_sales
FROM sales_data
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
ORDER BY year, month;

--Identify the top three salesperson_id values by sale_amount within a specific region (2) across all partitions
SELECT salesperson_id, SUM(sale_amount) AS total_sales
FROM sales_data
WHERE region_id = '2'  
GROUP BY salesperson_id
ORDER BY total_sales DESC
LIMIT 3;


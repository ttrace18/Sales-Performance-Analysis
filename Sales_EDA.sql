# View the sales table
SELECT *
FROM sales_dataset LIMIT 10;

# Find the number of sales transactions in the table
SELECT COUNT(*)
FROM sales_dataset;

# Convert Order Date column to date
UPDATE sales_dataset
SET `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

# Check for duplicate rows
SELECT `Order ID`, Amount, Profit, Quantity, Category, `Sub-Category`, PaymentMode, `Order Date`, State, City, `Year-Month`, COUNT(*)
FROM sales_dataset
GROUP BY `Order ID`, Amount, Profit, Quantity, Category, `Sub-Category`, PaymentMode, `Order Date`, State, City, `Year-Month`
HAVING COUNT(*) > 1;

# Find sub-categories with greatest total profit
SELECT Category, `Sub-Category`, SUM(Profit) AS Total_Profit 
FROM sales_dataset
GROUP BY Category, `Sub-Category`
ORDER BY Category, Total_Profit DESC;

# Calculate total revenue and profit by year
SELECT YEAR(`Order Date`) as Year, SUM(Amount) as Revenue, SUM(Profit) as Profit
FROM sales_dataset
GROUP BY YEAR(`Order Date`)
ORDER BY 1 DESC;

# Find the top 10 months and years by state with the highest revenue
SELECT YEAR(`Order Date`) as Year, MONTH(`Order Date`) as Month, State, SUM(Amount) as Total_Revenue
FROM sales_dataset
GROUP BY Year, Month, State
ORDER BY Total_Revenue DESC LIMIT 10;

# Calculate the top 10 most profitable products grouped by city and category
SELECT City, Category, SUM(Profit) as Profit
FROM sales_dataset
GROUP BY City, Category
ORDER BY Profit DESC LIMIT 10;

# Find the most profitable months of the year
SELECT MONTH(`Order Date`) as Month, SUM(Profit) as Profit
FROM sales_dataset
GROUP BY Month 
ORDER BY Profit DESC;

# Calculate total revenue by product sub-category and city
SELECT `Sub-Category`, City, SUM(Amount) as Revenue
FROM sales_dataset
GROUP BY `Sub-Category`, City
ORDER BY Revenue DESC;

# Find the top 5 most profitable product categories by city
SELECT City, Category, Profit
FROM (
SELECT City, Category, Profit,
DENSE_RANK() OVER (PARTITION BY Category
ORDER BY Profit DESC) AS Profit_Rank
FROM sales_dataset
) AS Category_Profit_Rank
WHERE Profit_Rank <= 5;
    
# Calculate the percentage of total sales by product sub-category
SELECT `Sub-Category`, SUM(Amount) as Revenue, SUM(Amount) / (SELECT SUM(Amount) FROM sales_dataset) AS Percent_of_Total_Sales
FROM sales_dataset
GROUP BY `Sub-Category`;

# Find the city with the highest revenue for each month
SELECT City, `Year-Month`, Amount as Revenue
FROM (
SELECT City, `Year-Month`, Amount,
DENSE_RANK() OVER (PARTITION BY `Year-Month`
ORDER BY Amount DESC) AS Revenue_Rank
FROM sales_dataset
) AS Year_Month_Revenue_Ranking
WHERE Revenue_Rank = 1;

# Calculate the profit margin of each state by year
SELECT State, YEAR(`Order Date`) AS Year, SUM(Amount) as Total_Revenue, SUM(Profit) as Total_Profit, SUM(Profit) / SUM(Amount) AS Profit_Margin
FROM sales_dataset
GROUP BY State, Year
ORDER BY Year ASC;
--Create scripts (SQLs) to cover the following business requirements:
--1)no data
--2)
SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    COUNT(*) AS NumTransactions,
    SUM(fs.TotalAmount) AS TotalSales,
    SUM(fs.TaxAmount) AS TotalTax
FROM FactSales fs
JOIN DimProduct p ON fs.ProductID = p.ProductID
JOIN DimCategory c ON fs.CategoryID = c.CategoryID
GROUP BY  p.ProductID, p.ProductName, c.CategoryName
ORDER BY NumTransactions ASC, TotalSales ASC, TotalTax ASC
LIMIT 5;
--3)
SELECT
    c.CustomerID,
    c.ContactName,
    c.Region,
    COUNT(fs.SalesID) AS NumberofTransactions,
    SUM(fs.TotalAmount) AS TotalPurchaseAmount
FROM FactSales fs
JOIN DimCustomer c ON fs.CustomerID = c.CustomerID
GROUP BY
    c.CustomerID,
    c.ContactName,
    c.Region,
ORDER BY
    NumberofTransactions ASC,
    TotalPurchaseAmount ASC
LIMIT 5;
--4)
SELECT
    EXTRACT(MONTH FROM d.Date) AS SalesMonth,
    d.Date,
    SUM(f.TotalAmount) AS TotalSales,
    SUM(f.QuantitySold) AS TotalQuantitySold
FROM FactSales f
JOIN DimDate d ON f.DateID = d.DateID
WHERE d.Day <= 7
GROUP BY SalesMonth, d.Date
ORDER BY SalesMonth, d.Date;
--5)
SELECT
    EXTRACT(MONTH FROM d.Date) AS SalesMonth,
    p.CategoryName,
    SUM(f.TotalAmount) AS TotalSales
FROM FactSales f
JOIN DimDate d ON f.DateID = d.DateID
JOIN DimProduct p ON f.ProductID = p.ProductID
WHERE d.Date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY SalesMonth, p.CategoryName
ORDER BY SalesMonth, p.CategoryName;
--6)
SELECT
    d.Month,
    p.CategoryName,
    c.Country,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY f.TotalAmount) OVER (PARTITION BY d.Month, p.CategoryName, c.Country) AS MedianSales
FROM FactSales f
JOIN DimDate d ON f.DateID = d.DateID
JOIN DimProduct p ON f.ProductID = p.ProductID
JOIN DimCustomer c ON f.CustomerID = c.CustomerID
GROUP BY d.Month, p.CategoryName, c.Country;
--7)
SELECT
    p.CategoryName,
    SUM(f.TotalAmount) AS TotalSales
FROM FactSales f
JOIN DimProduct p ON f.ProductID = p.ProductID
GROUP BY p.CategoryName
ORDER BY TotalSales DESC;

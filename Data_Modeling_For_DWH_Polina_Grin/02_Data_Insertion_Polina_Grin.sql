--Create a corresponding staging table and load data into it. 
INSERT INTO staging_orders SELECT * FROM Orders;
INSERT INTO staging_order_details SELECT * FROM Order_Details;
INSERT INTO staging_products SELECT * FROM Products;
INSERT INTO staging_customers SELECT * FROM Customers;
INSERT INTO staging_employees SELECT * FROM Employees;
INSERT INTO staging_categories SELECT * FROM Categories;
INSERT INTO staging_shippers SELECT * FROM Shippers;
INSERT INTO staging_suppliers SELECT * FROM Suppliers;

--Transform the data from the staging tables and load it into the respective dimension tables
INSERT INTO DimProduct (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)
SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock
FROM staging_products;

INSERT INTO DimCustomer (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone) 
SELECT customerid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone 
FROM staging_customers ;

INSERT INTO DimCategory (CategoryID, CategoryName, Description)
SELECT categoryid, categoryname, description
FROM staging_categories;

INSERT INTO DimEmployee (EmployeeID, LastName, FirstName, Title, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension)
SELECT employeeid, lastname, firstname, title, birthdate, hiredate, address, city, region, postalcode, country, phone, extension
FROM staging_employees;

INSERT INTO DimShipper (ShipperID, CompanyName, Phone)
SELECT shipperid, companyname, phone
FROM staging_shippers;

INSERT INTO DimSupplier (SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone)
SELECT supplierid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone
FROM staging_suppliers;

INSERT INTO DimDate (Date, Day, Month, Year, Quarter, WeekOfYear)
SELECT
    DISTINCT DATE(orderdate) AS Date,
    EXTRACT(DAY FROM DATE(orderdate)) AS Day,
    EXTRACT(MONTH FROM DATE(orderdate)) AS Month,
    EXTRACT(YEAR FROM DATE(orderdate)) AS Year,
    EXTRACT(QUARTER FROM DATE(orderdate)) AS Quarter,
    EXTRACT(WEEK FROM DATE(orderdate)) AS WeekOfYear
FROM
    staging_orders;
	
INSERT INTO FactSales (DateID, CustomerID, ProductID, EmployeeID, CategoryID, ShipperID, SupplierID, QuantitySold, UnitPrice, Discount, TotalAmount, TaxAmount) 
SELECT
    d.DateID,   
    c.CustomerID,  
    p.ProductID,  
    e.EmployeeID,  
    cat.CategoryID,  
    s.ShipperID,  
    sup.SupplierID, 
    od.qty, 
    od.UnitPrice, 
    od.Discount,    
    (od.qty * od.UnitPrice - od.Discount) AS TotalAmount,
    (od.qty * od.UnitPrice - od.Discount) * 0.1 AS TaxAmount     
FROM staging_order_details od 
JOIN staging_orders o ON od.OrderID = o.OrderID 
JOIN staging_customers c ON o.CustomerID = c.CustomerID 
JOIN staging_products p ON od.ProductID = p.ProductID  
LEFT JOIN staging_employees e ON o.EmployeeID = e.EmployeeID 
 LEFT JOIN staging_categories cat ON p.CategoryID = cat.CategoryID 
 LEFT JOIN staging_shippers s ON o.shipperid = s.ShipperID  
LEFT JOIN staging_suppliers sup ON p.SupplierID = sup.SupplierID
LEFT JOIN DimDate d ON o.OrderDate = d.Date;

--Validate the data to ensure it is accurate and complete
SELECT 'DimDate' AS Table_Name, COUNT(*) AS Record_Count FROM DimDate
UNION ALL
SELECT 'DimCustomer', COUNT(*) FROM DimCustomer
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM DimProduct
UNION ALL
SELECT 'DimEmployee', COUNT(*) FROM DimEmployee
UNION ALL
SELECT 'DimCategory', COUNT(*) FROM DimCategory
UNION ALL
SELECT 'DimShipper', COUNT(*) FROM DimShipper
UNION ALL
SELECT 'DimSupplier', COUNT(*) FROM DimSupplier
UNION ALL
SELECT 'FactSales', COUNT(*) FROM FactSales
UNION ALL
SELECT 'staging_customers', COUNT(*) FROM staging_customers
UNION ALL
SELECT 'staging_products', COUNT(*) FROM staging_products
UNION ALL
SELECT 'staging_categories', COUNT(*) FROM staging_categories
UNION ALL
SELECT 'staging_employees', COUNT(*) FROM staging_employees
UNION ALL
SELECT 'staging_shippers', COUNT(*) FROM staging_shippers
UNION ALL
SELECT 'staging_suppliers', COUNT(*) FROM staging_suppliers
UNION ALL
SELECT 'staging_order_details', COUNT(*) FROM staging_order_details
UNION ALL
SELECT 'staging_orders_unique_orderdates', COUNT(DISTINCT orderdate) FROM staging_orders;

SELECT COUNT(*) AS Broken_Record_Count 
FROM FactSales 
WHERE DateID NOT IN (SELECT DateID FROM DimDate)
   OR CustomerID NOT IN (SELECT CustomerID FROM DimCustomer)
   OR ProductID NOT IN (SELECT ProductID FROM DimProduct)
   OR EmployeeID NOT IN (SELECT EmployeeID FROM DimEmployee)
   OR CategoryID NOT IN (SELECT CategoryID FROM DimCategory)
   OR ShipperID NOT IN (SELECT ShipperID FROM DimShipper)
   OR SupplierID NOT IN (SELECT SupplierID FROM DimSupplier);
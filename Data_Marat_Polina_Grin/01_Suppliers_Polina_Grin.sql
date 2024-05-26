--Create a fact table: FactSupplierPurchases
CREATE TABLE FactSupplierPurchases (
    PurchaseID SERIAL PRIMARY KEY,
    SupplierID INT,
    TotalPurchaseAmount DECIMAL,
    PurchaseDate DATE,
    NumberOfProducts INT,
    FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID)
);
--Populate the FactSupplierPurchases table with data aggregated from the staging tables
INSERT INTO FactSupplierPurchases (SupplierID, TotalPurchaseAmount, PurchaseDate, NumberOfProducts)
SELECT 
    p.SupplierID, 
    SUM(od.UnitPrice * od.Quantity) AS TotalPurchaseAmount, 
    CURRENT_DATE AS PurchaseDate, (Simplified for demonstration purposes)
    COUNT(DISTINCT od.ProductID) AS NumberOfProducts
FROM staging_order_details od
JOIN staging_products p ON od.ProductID = p.ProductID
GROUP BY p.SupplierID;

--Supplier spending analysis
select
    s.companyname,
    sum(fsp.totalpurchaseamount) as totalspend,
    extract(year from fsp.purchasedate) as year,
    extract(month from fsp.purchasedate) as month
from factsupplierpurchases fsp
join dimsupplier s on fsp.supplierid = s.supplierid
group by s.companyname, year, month
order by totalspend desc;

--Product cost breakdown by supplier
select
    s.companyname,
    p.productname,
    avg(od.unitprice) as averageunitprice,
    sum(od.qty) as totalquantitypurchased,
    sum(od.unitprice * od.qty) as totalspend
from staging_order_details od
join staging_products p on od.productid = p.productid
join dimsupplier s on p.supplierid = s.supplierid
group by s.companyname, p.productname
order by s.companyname, totalspend desc;

--Top five products by total purchases per supplier
select
    s.companyname,
    p.productname,
    sum(od.unitprice * od.qty) as totalspend
from staging_order_details od
join staging_products p on od.productid = p.productid
join dimsupplier s on p.supplierid = s.supplierid
group by s.companyname, p.productname
order by s.companyname, totalspend desc
limit 5;


--Supplier performance report (do not work)

--supplier reliability score report (do not work)

--1)Creating staging tables
CREATE  TABLE staging_orders (
    orderid        SERIAL PRIMARY KEY NOT NULL,
    customerid      VARCHAR(15) NULL,
    employeeid          INT NULL,
    orderdate      TIMESTAMP NULL,
    requireddate   TIMESTAMP NULL,
    shippeddate    TIMESTAMP NULL,
    shipperid      INT NULL,
    freight        DECIMAL(10, 2) NULL,
    shipname       VARCHAR(40) NULL,
    shipaddress    VARCHAR(60) NULL,
    shipcity       VARCHAR(15) NULL,
    shipregion     VARCHAR(15) NULL,
    shippostalcode VARCHAR(10) NULL,
    shipcountry    VARCHAR(15) NULL
);

CREATE TABLE staging_order_details (
    orderid     INT NOT NULL,
    productid   INT NOT NULL,
    unitprice   DECIMAL(10, 2) NOT NULL,
    qty         SMALLINT NOT NULL,
    discount    DECIMAL(10, 2) NOT NULL

);

CREATE TABLE staging_products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR(255),
    UnitPrice DECIMAL,
    UnitsInStock INT,
	unitsonorder    SMALLINT NULL,
    reorderlevel    SMALLINT NULL,
    discontinued    CHAR(1) NOT NULL
);

CREATE TABLE staging_customers (
    CustomerID VARCHAR(255) PRIMARY KEY,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(255),
    Country VARCHAR(255),
    Phone VARCHAR(255),
	fax VARCHAR(24) NULL
);

CREATE TABLE staging_employees (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    Title VARCHAR(255),
	titleofcourtesy VARCHAR (25), 
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(255),
    Country VARCHAR(255),
    Phone VARCHAR(255),
    Extension VARCHAR(255),
	photo           BYTEA NULL, 
     notes           TEXT NULL, 
     mgrid       INT NULL, 
     photopath       VARCHAR (255) NULL
);

CREATE TABLE staging_categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255),
    Description TEXT,
	picture BYTEA
);

CREATE TABLE staging_shippers (
    ShipperID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    Phone VARCHAR(255)
);

CREATE TABLE staging_suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(255),
    Country VARCHAR(255),
    Phone VARCHAR(255),
	fax VARCHAR(24) NULL,
    homepage TEXT NULL
);

--2)Use the proposed set of dimension tables and their respective columns
CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    WeekOfYear INT
);

drop table DimCustomer
CREATE TABLE DimCustomer (
    CustomerID VARCHAR(255) PRIMARY KEY,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(255),
    Country VARCHAR(255),
    Phone VARCHAR(255)
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR(255),
    UnitPrice DECIMAL,
    UnitsInStock INT
);

CREATE TABLE DimEmployee (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    Title VARCHAR(255),
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(255),
    Country VARCHAR(255),
    HomePhone VARCHAR(255),
    Extension VARCHAR(255)
);

CREATE TABLE DimCategory (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255),
    Description TEXT
);

CREATE TABLE DimShipper (
    ShipperID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    Phone VARCHAR(255)
);

CREATE TABLE DimSupplier (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(255),
    Country VARCHAR(255),
    Phone VARCHAR(255)
);

-- Fact Table
CREATE TABLE FactSales (
    SalesID SERIAL PRIMARY KEY,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    EmployeeID INT,
    CategoryID INT,
    ShipperID INT,
    SupplierID INT,
    QuantitySold INT,
    UnitPrice DECIMAL,
    Discount DECIMAL,
    TotalAmount DECIMAL GENERATED ALWAYS AS ((QuantitySold * UnitPrice) - Discount) STORED,
    TaxAmount DECIMAL
);


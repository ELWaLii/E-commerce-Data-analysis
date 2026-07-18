-- Create the Database
CREATE DATABASE EcommerceDB;
GO

USE EcommerceDB;
GO

-- ==============================================================================
-- 1. INDEPENDENT TABLES (No Foreign Keys)
-- ==============================================================================

-- Create Categories Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL
);

-- Create Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255) NULL,
    Phone VARCHAR(100) NULL,
    Email VARCHAR(255) NULL,
    City VARCHAR(100) NULL,
    Country VARCHAR(100) NULL
);

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NULL,
    Phone VARCHAR(100) NULL,
    Address NVARCHAR(500) NULL,
    City VARCHAR(100) NULL,
    Country VARCHAR(100) NULL,
    JoinDate DATE NULL
);

-- ==============================================================================
-- 2. DEPENDENT TABLES (Contains Foreign Keys)
-- ==============================================================================

-- Create Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(255) NOT NULL,
    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity INT NOT NULL DEFAULT 0 CHECK (StockQuantity >= 0),
    Unit VARCHAR(50) NULL,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    OrderStatus VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ==============================================================================
-- 3. WEAK ENTITIES (Depends on Orders and Products)
-- ==============================================================================

-- Create Order Details Table
CREATE TABLE Order_Details (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    Discount DECIMAL(10,2) NOT NULL DEFAULT 0,
    LineTotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    AmountPaid DECIMAL(10,2) NOT NULL CHECK (AmountPaid > 0),
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentStatus VARCHAR(50) NOT NULL,
    PaymentDate DATETIME NOT NULL,
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Create Shipments Table
CREATE TABLE Shipments (
    shipment_id INT IDENTITY(1,1) PRIMARY KEY,
    shipper_id INT NULL,
    service_id VARCHAR(50) NULL,
    weight_kg DECIMAL(10,2) NULL,
    shipment_date DATE NULL,
    delivery_date DATE NULL,
    status VARCHAR(50) NOT NULL,
    shipping_cost DECIMAL(10,2) NULL,
    OrderID INT NOT NULL UNIQUE, 
    CONSTRAINT FK_Shipments_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO
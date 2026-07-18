USE EcommerceDB;
GO

-- 1. vw_OrderSummary
CREATE VIEW vw_OrderSummary AS
SELECT  
    O.OrderID,  
    O.CustomerID, 
    O.OrderDate, 
    O.OrderStatus, 
    SUM(OD.LineTotal) AS TotalOrderAmount
FROM Orders O 
INNER JOIN Order_Details OD ON O.OrderID = OD.OrderID
GROUP BY 
    O.OrderID, 
    O.CustomerID, 
    O.OrderDate, 
    O.OrderStatus;
GO

-- 2. vw_ProductSales
CREATE VIEW vw_ProductSales AS
SELECT 
    P.ProductID, 
    P.ProductName, 
    SUM(OD.Quantity) AS Total_Quantity_Sold, 
    SUM(OD.LineTotal) AS Total_Revenue 
FROM Products P 
INNER JOIN Order_Details OD ON P.ProductID = OD.ProductID
GROUP BY 
    P.ProductID, 
    P.ProductName;
GO

-- 3. vw_CustomerOrders
CREATE VIEW vw_CustomerOrders AS
SELECT  
    C.CustomerID,
    C.FirstName, 
    COUNT(O.OrderID) AS Total_orders 
FROM Customers C 
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.CustomerID,
    C.FirstName;
GO

-- 4. vw_InventoryStatus
CREATE VIEW vw_InventoryStatus AS
SELECT 
    ProductID, 
    ProductName, 
    UnitPrice, 
    StockQuantity AS Available_Quantity 
FROM Products;
GO
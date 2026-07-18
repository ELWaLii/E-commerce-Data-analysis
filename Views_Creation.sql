USE EcommerceDB;
GO

-- ==============================================================================
-- 1. Order Summary View
-- WHAT IT DOES: Shows each order with its total amount (summing up the order details).
-- ==============================================================================
CREATE VIEW Order_Summary AS
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

-- ==============================================================================
-- 2. Product Sales View
-- WHAT IT DOES: Calculates total quantity sold and total revenue for each product.
-- ==============================================================================
CREATE VIEW Product_Sales AS
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

-- ==============================================================================
-- 3. Customers Orders View
-- WHAT IT DOES: Shows all customers and the total number of orders they placed.
-- ==============================================================================
CREATE VIEW Customers_Orders AS
SELECT  
    C.CustomerID,
    C.FirstName + ' ' + C.LastName AS FullName, 
    COUNT(O.OrderID) AS Total_orders 
FROM Customers C 
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.CustomerID,
    C.FirstName, 
    C.LastName;
GO

-- ==============================================================================
-- 4. Available Stock View
-- WHAT IT DOES: Shows the current available stock and price for each product.
-- (Fixed: No need to join with Order_Details to know available stock, it's in Products)
-- ==============================================================================
CREATE VIEW Available_Stock AS
SELECT 
    ProductID, 
    ProductName, 
    UnitPrice, 
    StockQuantity AS Available_Quantity 
FROM Products;
GO
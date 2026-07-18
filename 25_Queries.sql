-- ==============================================================================
-- Query 1: Basic INNER JOIN between Customers and Orders
-- WHAT IT DOES: Retrieves a list of all orders along with the customer's full name.
-- WHY WE USE INNER JOIN: We only want orders that belong to a valid customer. 
-- INNER JOIN filters out any orphaned records (though our FKs prevent this anyway).
-- ==============================================================================
SELECT 
    O.OrderID, 
    O.OrderDate, 
    C.FirstName + ' ' + C.LastName AS FullName, 
    O.OrderStatus
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID;

-- ==============================================================================
-- Query 2: Multiple INNER JOINs (Order Details, Products, Categories)
-- WHAT IT DOES: Shows exactly what products were sold in each order and their category.
-- WHY MULTIPLE JOINS: Normalization split this data into 3 tables. We need to chain 
-- the joins (Order_Details -> Products -> Categories) to reconstruct the full context.
-- ==============================================================================
SELECT 
    OD.OrderID, 
    P.ProductName, 
    C.CategoryName, 
    OD.Quantity, 
    OD.LineTotal
FROM Order_Details OD
INNER JOIN Products P ON OD.ProductID = P.ProductID
INNER JOIN Categories C ON P.CategoryID = C.CategoryID;

-- ==============================================================================
-- Query 3: LEFT OUTER JOIN to find Customers with NO Orders
-- WHAT IT DOES: Identifies registered users who haven't made a purchase yet.
-- WHY WE USE LEFT JOIN: A LEFT JOIN takes ALL records from the left table (Customers)
-- even if there is no match in the right table (Orders). Where OrderID is NULL, 
-- we know the customer never bought anything.
-- ==============================================================================
SELECT 
    C.CustomerID, 
    C.FirstName, 
    C.Email
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

-- ==============================================================================
-- Query 4: RIGHT OUTER JOIN to find Products never sold
-- WHAT IT DOES: Lists products that exist in our inventory but have no order details.
-- WHY WE USE RIGHT JOIN: We want ALL Products (the right table) regardless of whether 
-- they appear in the Order_Details (left table) to spot dead stock.
-- ==============================================================================
SELECT 
    P.ProductID, 
    P.ProductName, 
    P.StockQuantity
FROM Order_Details OD
RIGHT JOIN Products P ON OD.ProductID = P.ProductID
WHERE OD.OrderDetailID IS NULL;

-- ==============================================================================
-- Query 5: INNER JOIN for 1:1 Relationship (Orders and Shipments)
-- WHAT IT DOES: Tracks the shipping status and cost for each specific order.
-- WHY INNER JOIN: Since the relationship is 1:1 (One order = One shipment), an 
-- INNER JOIN perfectly aligns the shipping data next to the order data.
-- ==============================================================================
SELECT 
    O.OrderID, 
    O.OrderStatus, 
    S.status AS ShipmentStatus, 
    S.delivery_date
FROM Orders O
INNER JOIN Shipments S ON O.OrderID = S.OrderID;

-- ==============================================================================
-- Query 6: Combining JOIN and WHERE for Filtering
-- WHAT IT DOES: Finds all successful payments made via 'Credit Card'.
-- WHY USE THIS: To isolate specific business channels for financial auditing.
-- ==============================================================================
SELECT PaymentMethod,
COUNT(PaymentID) AS NumOfTransactions, 
SUM(AmountPaid) AS TotalMoney
FROM Payments
GROUP BY PaymentMethod;

-- ==============================================================================
-- Query 7: Joining Products and Suppliers
-- WHAT IT DOES: Shows the company name supplying each product and their contact.
-- WHY INNER JOIN: To quickly know who to call when a product stock is running low.
-- ==============================================================================
SELECT 
    P.ProductName, 
    P.StockQuantity, 
    S.CompanyName, 
    S.Phone
FROM Products P
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE P.StockQuantity < 20;

-- ==============================================================================
-- Query 8: Full Lifecycle JOIN (Customer -> Order -> Payment)
-- WHAT IT DOES: Gives a comprehensive view of who ordered, when, and how much they paid.
-- WHY 3-WAY JOIN: To tie the user (Customer), the action (Order), and the money (Payment).
-- ==============================================================================
SELECT 
    C.FirstName, 
    O.OrderID, 
    O.OrderDate, 
    P.AmountPaid
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN Payments P ON O.OrderID = P.OrderID;

-- ==============================================================================
-- Query 9: Filtering by Date Range
-- WHAT IT DOES: Retrieves orders placed in the last quarter of 2023.
-- WHY USE BETWEEN: It is faster and more readable than using >= and <= for dates.
-- ==============================================================================
SELECT 
    OrderID, 
    OrderDate, 
    OrderStatus
FROM Orders
WHERE OrderDate BETWEEN '2023-10-01' AND '2023-12-31';

-- ==============================================================================
-- Query 10: Pattern Matching using LIKE
-- WHAT IT DOES: Finds customers whose email ends with '@gmail.com'.
-- WHY USE LIKE: Essential for text mining and cleaning up specific data segments.
-- ==============================================================================
SELECT 
    FirstName, 
    LastName, 
    Email 
FROM Customers
WHERE Email LIKE '%@gmail.com';


-- ==============================================================================
-- Query 11: GROUP BY and SUM (Total Revenue per Category)
-- WHAT IT DOES: Calculates the total money made from each product category.
-- WHY GROUP BY: We need to aggregate (squash) multiple rows into a single summary 
-- row per category to see which category is the most profitable.
-- ==============================================================================
SELECT 
    C.CategoryName, 
    SUM(OD.LineTotal) AS TotalRevenue
FROM Categories C
INNER JOIN Products P ON C.CategoryID = P.CategoryID
INNER JOIN Order_Details OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName;

-- ==============================================================================
-- Query 12: GROUP BY and COUNT (Order Count per Customer)
-- WHAT IT DOES: Shows how many orders each customer has made.
-- WHY WE USE IT: To identify our most loyal returning customers.
-- ==============================================================================
SELECT 
    C.CustomerID, 
    C.FirstName, 
    COUNT(O.OrderID) AS TotalOrders
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName
ORDER BY TotalOrders DESC;

-- ==============================================================================
-- Query 13: Using HAVING with GROUP BY
-- WHAT IT DOES: Finds VIP customers who have spent more than $1000 in total.
-- WHY HAVING AND NOT WHERE: WHERE filters rows BEFORE aggregation. HAVING filters 
-- groups AFTER aggregation (like SUM). We cannot use WHERE SUM() > 1000.
-- ==============================================================================
SELECT 
    C.FirstName, 
    SUM(P.AmountPaid) AS TotalSpent
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN Payments P ON O.OrderID = P.OrderID
GROUP BY C.FirstName
HAVING SUM(P.AmountPaid) > 1000;

-- ==============================================================================
-- Query 14: AVG Function
-- WHAT IT DOES: Calculates the average order value across the entire store.
-- WHY USE AVG: Provides a baseline KPI (Key Performance Indicator) for the business.
-- ==============================================================================
SELECT 
    AVG(AmountPaid) AS AverageOrderValue
FROM Payments;

-- ==============================================================================
-- Query 15: MAX and MIN 
-- WHAT IT DOES: Finds the most expensive and least expensive products in stock.
-- WHY USE MAX/MIN: Quick statistical summary of pricing distribution.
-- ==============================================================================
SELECT 
    MAX(UnitPrice) AS MostExpensive, 
    MIN(UnitPrice) AS LeastExpensive
FROM Products;

-- ==============================================================================
-- Query 16: Monthly Sales Analysis (Using Date Functions)
-- WHAT IT DOES: Groups total revenue by Year and Month.
-- WHY EXTRACT DATES: To plot a time-series chart in Power BI showing sales trends.
-- ==============================================================================
SELECT 
    YEAR(OrderDate) AS SalesYear, 
    MONTH(OrderDate) AS SalesMonth, 
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;

-- ==============================================================================
-- Query 17: Aggregating Inventory by Supplier
-- WHAT IT DOES: Shows total items in stock provided by each supplier.
-- WHY USE IT: Helps procurement teams know which supplier holds most of our assets.
-- ==============================================================================
SELECT 
    S.CompanyName, 
    SUM(P.StockQuantity) AS TotalItemsInStock
FROM Suppliers S
INNER JOIN Products P ON S.SupplierID = P.SupplierID
GROUP BY S.CompanyName;

-- ==============================================================================
-- Query 18: COUNT DISTINCT
-- WHAT IT DOES: Counts exactly how many unique products were actually sold.
-- WHY USE DISTINCT: If product 5 was sold in 10 different orders, COUNT() returns 10,
-- but COUNT(DISTINCT) correctly returns 1 (it counts the unique ProductID).
-- ==============================================================================
SELECT 
    COUNT(DISTINCT ProductID) AS UniqueProductsSold
FROM Order_Details;

-- ==============================================================================
-- Query 19: Subquery in the WHERE clause
-- WHAT IT DOES: Finds products priced higher than the average product price.
-- WHY USE A SUBQUERY: We don't know the average price dynamically. The inner query 
-- calculates it first, then passes it to the outer query as a filter.
-- ==============================================================================
SELECT 
    ProductName, 
    UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

-- ==============================================================================
-- Query 20: The CASE Statement (Conditional Logic)
-- WHAT IT DOES: Categorizes stock levels into 'Critical', 'Low', and 'Healthy'.
-- WHY USE CASE: To create a derived categorical column on the fly for dashboards,
-- without altering the physical database schema.
-- ==============================================================================
SELECT 
    ProductName, 
    StockQuantity,
    CASE 
        WHEN StockQuantity = 0 THEN 'Out of Stock'
        WHEN StockQuantity < 20 THEN 'Critical Low'
        ELSE 'Healthy'
    END AS StockStatus
FROM Products;

-- ==============================================================================
-- Query 21: Date Math (DATEDIFF)
-- WHAT IT DOES: Calculates the exact number of days it took to deliver an order.
-- WHY DATEDIFF: Critical for calculating the 'Delivery Time KPI' in supply chains.
-- ==============================================================================
SELECT 
    OrderID, 
    shipment_date, 
    delivery_date, 
    DATEDIFF(day, shipment_date, delivery_date) AS DaysToDeliver
FROM Shipments
WHERE delivery_date IS NOT NULL;

-- ==============================================================================
-- Query 22: Window Function (ROW_NUMBER)
-- WHAT IT DOES: Ranks products within their category by price (highest to lowest).
-- WHY WINDOW FUNCTIONS: Unlike GROUP BY which collapses rows, Window Functions allow 
-- us to see individual rows while assigning a calculated rank over a specific partition.
-- ==============================================================================
SELECT 
    ProductName, 
    CategoryID, 
    UnitPrice,
    ROW_NUMBER() OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS PriceRank
FROM Products;

-- ==============================================================================
-- Query 23: CTE (Common Table Expression)
-- WHAT IT DOES: Finds the total revenue per order, then filters for orders > $500.
-- WHY USE CTE: CTEs (WITH clause) make complex queries readable. We define a 
-- virtual table of totals first, then query from it cleanly.
-- ==============================================================================
WITH OrderTotals AS (
    SELECT OrderID, SUM(LineTotal) AS TotalOrderValue
    FROM Order_Details
    GROUP BY OrderID
)
SELECT OrderID, TotalOrderValue
FROM OrderTotals
WHERE TotalOrderValue > 500;

-- ==============================================================================
-- Query 24: Correlated Subquery
-- WHAT IT DOES: Finds the most recent order date for each customer.
-- WHY CORRELATED: The inner query references the outer query's CustomerID to 
-- calculate the max date specific to that single customer row by row.
-- ==============================================================================
SELECT 
    C.FirstName,
    (SELECT MAX(OrderDate) 
     FROM Orders O 
     WHERE O.CustomerID = C.CustomerID) AS LastPurchaseDate
FROM Customers C;

-- ==============================================================================
-- Query 25: The Master Report (Comprehensive Multi-Join with Aggregation)
-- WHAT IT DOES: The ultimate executive summary. Customer name, their total orders, 
-- total amount spent, and their shipping status.
-- WHY WE BUILT THIS: This combines INNER JOINS, GROUP BY, and aggregates to provide 
-- a ready-to-use dataset for a Power BI summary table.
-- ==============================================================================
SELECT 
    C.FirstName + ' ' + C.LastName AS CustomerName,
    COUNT(DISTINCT O.OrderID) AS NumberOfOrders,
    SUM(OD.LineTotal) AS TotalLifetimeValue,
    MAX(S.status) AS LatestShippingStatus
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN Order_Details OD ON O.OrderID = OD.OrderID
LEFT JOIN Shipments S ON O.OrderID = S.OrderID
GROUP BY C.FirstName, C.LastName;
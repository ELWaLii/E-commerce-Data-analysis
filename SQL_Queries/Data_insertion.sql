USE EcommerceDB;
GO

BULK INSERT Categories
FROM 'D:\E_commerce_Data_Analysis\Fianal_Data_Set\Categories.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);

BULK INSERT Suppliers
FROM 'D:\E_commerce_Data_Analysis\Fianal_Data_Set\Suppliers.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);

BULK INSERT Customers
FROM 'D:\E_commerce_Data_Analysis\Fianal_Data_Set\Customers.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);

BULK INSERT Products
FROM 'D:\E_commerce_Data_Analysis\Fianal_Data_Set\Products.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);

BULK INSERT Orders
FROM 'D:\E_commerce_Data_Analysis\Fianal_Data_Set\Orders.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);

BULK INSERT Order_Details
FROM 'D:\E_commerce_Data_Analysis\Fianal_Data_Set\Order_Details.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);

BULK INSERT Payments
FROM 'D:\E_commerce_Data_Analysis\Fianal_Data_Set\Payments.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);

BULK INSERT Shipments
FROM 'D:\E_commerce_Data_nalysis\Fianal_Data_Set\Shipments.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', KEEPIDENTITY);
GO
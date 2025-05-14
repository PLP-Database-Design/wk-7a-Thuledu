-- File name: answers.sql

-- Question 1: Achieving 1NF (First Normal Form)
-- Transforming the ProductDetail table into 1NF by ensuring each row represents a single product for an order.
-- We will use a UNION ALL to create separate rows for each product in the original table.

SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product
FROM ProductDetail
UNION ALL
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(Products, ',', -1)) AS Product
FROM ProductDetail
WHERE Products LIKE '%,%'
UNION ALL
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', 2), ',', -1)) AS Product
FROM ProductDetail
WHERE Products LIKE '%,%'
AND LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= 1;



-- Question 2: Achieving 2NF (Second Normal Form)
-- Transforming the OrderDetails table into 2NF by removing partial dependencies.
-- We will create two tables: Orders and OrderItems.

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM OrderDetails;

-- Insert data into OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetails;

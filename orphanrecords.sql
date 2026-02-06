IF OBJECT_ID('OrderItems') IS NOT NULL DROP TABLE OrderItems;
IF OBJECT_ID('Orders') IS NOT NULL DROP TABLE Orders;

CREATE TABLE Orders(
    OrderId INT PRIMARY KEY,
    OrderDate DATE
);

CREATE TABLE OrderItems(
    ItemId INT PRIMARY KEY,
    OrderId INT,
    ProductName VARCHAR(50)
);


INSERT INTO Orders VALUES
(1, '2024-01-10'),
(2, '2024-01-11');

INSERT INTO OrderItems VALUES
(101, 1, 'Pen'),
(102, 2, 'Book'),
(103, 3, 'Pencil'),   -- Orphan (no OrderId = 3)
(104, 4, 'Bag');      -- Orphan (no OrderId = 4)


SELECT *
FROM OrderItems oi
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.OrderId = oi.OrderId
);

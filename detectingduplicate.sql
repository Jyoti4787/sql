IF OBJECT_ID('Users') IS NOT NULL
    DROP TABLE Users;

CREATE TABLE Users(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email VARCHAR(100)
);


INSERT INTO Users (Email) VALUES
('a@gmail.com'),
('b@gmail.com'),
('a@gmail.com'),
('c@gmail.com'),
('b@gmail.com'),
('d@gmail.com');


SELECT * FROM Users;


SELECT 
    Email,
    COUNT(*) AS DuplicateCount
FROM Users
GROUP BY Email
HAVING COUNT(*) > 1;

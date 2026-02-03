CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY,
    CustomerName TEXT,
    PhoneNumber TEXT,
    City TEXT,
    CreatedDate DATE
);
--One row = one customer.


CREATE TABLE Accounts (
    AccountID INTEGER PRIMARY KEY,
    CustomerID INTEGER,
    AccountNumber TEXT,
    AccountType TEXT,
    OpeningBalance REAL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
--each account belongs to a customer.Customers


CREATE TABLE Transactions (
    TransactionID INTEGER PRIMARY KEY,
    AccountID INTEGER,
    TransactionDate DATE,
    TransactionType TEXT,
    Amount REAL,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--all deposits and withdrwals are stored here.


CREATE TABLE Bonus (
    BonusID INTEGER PRIMARY KEY AUTOINCREMENT,
    AccountID INTEGER,
    BonusMonth TEXT,
    BonusYear TEXT,
    BonusAmount REAL,
    CreatedDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--Bonus money stored here. AUTOINCREMENT handles IDs.


INSERT INTO Customers VALUES
(1, 'Kisan Lal', '9876543210', 'Bihar', '2023-01-10'),
(2, 'Jyoti Singh', '9123456789', 'UP', '2023-03-15'),
(3, 'Shivansh Sharma', '9988776655', 'Hyderabad', '2023-06-20');


INSERT INTO Accounts VALUES
(101, 1, 'SB1001', 'Savings', 20000),
(102, 2, 'SB1002', 'Savings', 15000),
(103, 3, 'SB1003', 'Savings', 30000);


INSERT INTO Transactions VALUES
(1, 101, '2024-01-05', 'Deposit', 30000),
(2, 101, '2024-01-18', 'Withdraw', 5000),
(3, 101, '2024-02-10', 'Deposit', 25000),
(4, 102, '2024-01-07', 'Deposit', 20000),
(5, 102, '2024-01-25', 'Deposit', 35000),
(6, 102, '2024-02-05', 'Withdraw', 10000),
(7, 103, '2024-01-10', 'Deposit', 15000),
(8, 103, '2024-01-20', 'Withdraw', 5000);


--Question 1 — Total Deposit & Withdraw (Date range)
SELECT 
    IFNULL(SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount ELSE 0 END), 0) AS TotalDeposited,
    IFNULL(SUM(CASE WHEN TransactionType = 'Withdraw' THEN Amount ELSE 0 END), 0) AS TotalWithdrawn
FROM Transactions
WHERE AccountID = 101
  AND TransactionDate BETWEEN '2024-01-01' AND '2024-01-31';

SELECT TransactionDate FROM Transactions;



--Question 2 — Monthly Bonus Rule
--Rule
--If monthly deposit > 50,000 → give ₹1000 bonus once.

--find eligible accounts 
INSERT INTO Bonus (AccountID, BonusMonth, BonusYear, BonusAmount, CreatedDate)
SELECT 
    t.AccountID,
    strftime('%m', t.TransactionDate),
    strftime('%Y', t.TransactionDate),
    1000,
    date('now')
FROM Transactions t
WHERE t.TransactionType = 'Deposit'
GROUP BY 
    t.AccountID,
    strftime('%m', t.TransactionDate),
    strftime('%Y', t.TransactionDate)
HAVING SUM(t.Amount) > 50000
AND NOT EXISTS (
    SELECT 1 FROM Bonus b
    WHERE b.AccountID = t.AccountID
      AND b.BonusMonth = strftime('%m', t.TransactionDate)
      AND b.BonusYear = strftime('%Y', t.TransactionDate)
);



--Question 3 : current balance 
--OpeningBalance + Deposits − Withdrawals + Bonus

SELECT 
    c.CustomerName,
    a.AccountNumber,
    (
        a.OpeningBalance
        + IFNULL(SUM(CASE WHEN t.TransactionType = 'Deposit' THEN t.Amount END), 0)
        - IFNULL(SUM(CASE WHEN t.TransactionType = 'Withdraw' THEN t.Amount END), 0)
        + IFNULL(SUM(b.BonusAmount), 0)
    ) AS CurrentBalance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
LEFT JOIN Bonus b ON a.AccountID = b.AccountID
GROUP BY c.CustomerName, a.AccountNumber, a.OpeningBalance;














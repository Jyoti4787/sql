vairagi@vairagi:~$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.45-0ubuntu0.24.04.1 (Ubuntu)

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE EmployeeSalesDB;
Query OK, 1 row affected (0.02 sec)

mysql> GO
ERROR: 
No query specified

mysql> 
mysql> USE EmployeeSalesDB;
Database changed
mysql> GO
ERROR: 
No query specified

mysql> CREATE DATABASE EmployeeSalesDB;
ERROR 1007 (HY000): Can't create database 'EmployeeSalesDB'; database exists
mysql> USE EmployeeSalesDB;
Database changed
mysql> DROP DATABASE EmployeeSalesDB;
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE DATABASE EmployeeSalesDB;
Query OK, 1 row affected (0.01 sec)

mysql> USE EmployeeSalesDB;
Database changed
mysql> CREATE TABLE Department (
    ->     DepartmentId INT AUTO_INCREMENT PRIMARY KEY,
    ->     DepartmentName VARCHAR(100) NOT NULL
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> CREATE TABLE Employee (
    ->     EmpId INT PRIMARY KEY,
    ->     EmpName VARCHAR(100) NOT NULL,
    ->     Email VARCHAR(100) UNIQUE NOT NULL,
    ->     DepartmentId INT NOT NULL,
    ->     BonusPoints INT DEFAULT 0,
    ->     CONSTRAINT FK_Employee_Department
    ->         FOREIGN KEY (DepartmentId)
    ->         REFERENCES Department(DepartmentId),
    ->     CONSTRAINT CK_Employee_BonusPoints
    ->         CHECK (BonusPoints BETWEEN 0 AND 100)
    -> );
Query OK, 0 rows affected (0.10 sec)

mysql> CREATE TABLE Sales (
    ->     SaleId INT AUTO_INCREMENT PRIMARY KEY,
    ->     EmpId INT NOT NULL,
    ->     SaleMonth INT NOT NULL,
    ->     SaleYear INT NOT NULL,
    ->     SaleAmount DECIMAL(10,2) NOT NULL,
    ->     CONSTRAINT CK_Sales_Month CHECK (SaleMonth BETWEEN 1 AND 12),
    ->     CONSTRAINT FK_Sales_Employee
    ->         FOREIGN KEY (EmpId)
    ->         REFERENCES Employee(EmpId)
    -> );
Query OK, 0 rows affected (0.09 sec)

mysql> INSERT INTO Department (DepartmentName) VALUES
    -> ('Sales'),
    -> ('Marketing'),
    -> ('Finance');
Query OK, 3 rows affected (0.03 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Employee (EmpId, EmpName, Email, DepartmentId, BonusPoints) VALUES
    -> (1, 'Jyoti', 'jyoti@gmail.com', 1, 10),
    -> (2, 'Kisan', 'kisan@gmail.com', 1, 20),
    -> (3, 'Deepak', 'deepak@gmail.com', 2, 15);
Query OK, 3 rows affected (0.03 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Sales (EmpId, SaleMonth, SaleYear, SaleAmount) VALUES
    -> (1, 1, YEAR(CURDATE()), 5000),
    -> (1, 2, YEAR(CURDATE()), 3000),
    -> (2, 3, YEAR(CURDATE()), 7000),
    -> (2, 12, YEAR(CURDATE()) - 1, 4000);
Query OK, 4 rows affected (0.02 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM Department;
+--------------+----------------+
| DepartmentId | DepartmentName |
+--------------+----------------+
|            1 | Sales          |
|            2 | Marketing      |
|            3 | Finance        |
+--------------+----------------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM Employee;
+-------+---------+------------------+--------------+-------------+
| EmpId | EmpName | Email            | DepartmentId | BonusPoints |
+-------+---------+------------------+--------------+-------------+
|     1 | Jyoti   | jyoti@gmail.com  |            1 |          10 |
|     2 | Kisan   | kisan@gmail.com  |            1 |          20 |
|     3 | Deepak  | deepak@gmail.com |            2 |          15 |
+-------+---------+------------------+--------------+-------------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM Sales;
+--------+-------+-----------+----------+------------+
| SaleId | EmpId | SaleMonth | SaleYear | SaleAmount |
+--------+-------+-----------+----------+------------+
|      1 |     1 |         1 |     2026 |    5000.00 |
|      2 |     1 |         2 |     2026 |    3000.00 |
|      3 |     2 |         3 |     2026 |    7000.00 |
|      4 |     2 |        12 |     2025 |    4000.00 |
+--------+-------+-----------+----------+------------+
4 rows in set (0.00 sec)

mysql> SELECT
    ->     e.EmpName,
    ->     d.DepartmentName,
    ->     s.SaleMonth,
    ->     s.SaleYear,
    ->     s.SaleAmount
    -> FROM Employee e
    -> INNER JOIN Department d
    ->     ON e.DepartmentId = d.DepartmentId
    -> INNER JOIN Sales s
    ->     ON e.EmpId = s.EmpId;
+---------+----------------+-----------+----------+------------+
| EmpName | DepartmentName | SaleMonth | SaleYear | SaleAmount |
+---------+----------------+-----------+----------+------------+
| Jyoti   | Sales          |         1 |     2026 |    5000.00 |
| Jyoti   | Sales          |         2 |     2026 |    3000.00 |
| Kisan   | Sales          |         3 |     2026 |    7000.00 |
| Kisan   | Sales          |        12 |     2025 |    4000.00 |
+---------+----------------+-----------+----------+------------+
4 rows in set (0.00 sec)

mysql> SELECT
    ->     e.EmpName,
    ->     SUM(s.SaleAmount) AS TotalSales_CurrentYear
    -> FROM Employee e
    -> INNER JOIN Sales s
    ->     ON e.EmpId = s.EmpId
    -> WHERE YEAR(
    ->         STR_TO_DATE(
    ->             CONCAT(s.SaleYear, '-', s.SaleMonth, '-01'),
    ->             '%Y-%m-%d'
    ->         )
    ->       ) = YEAR(CURDATE())
    -> GROUP BY e.EmpName;
+---------+------------------------+
| EmpName | TotalSales_CurrentYear |
+---------+------------------------+
| Jyoti   |                8000.00 |
| Kisan   |                7000.00 |
+---------+------------------------+
2 rows in set (0.01 sec)


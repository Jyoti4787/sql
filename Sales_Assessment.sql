/**

use MyDatabase;
--cities table--
create table Cities (
    CityId int primary key identity(1,1),
    CityName varchar(50)
);

--customers table--
create table Customers (
    CustomerId int primary key identity(1,1),
    CustomerName varchar(100),
    CustomerPhone varchar(20),
    CityId int,
    foreign key (CityId) references Cities(CityId)
);

--products table--
create table Products (
    ProductId int primary key identity(1,1),
    ProductName varchar(100),
    UnitPrice int
);

--salesperson table--
create table SalesPersons (
    SalesId int primary key identity(1,1),
    SalesPersonName varchar(100)
);

--customerorders table--
create table CustomerOrders (
    OrderId int primary key identity(1,1),
    OrderDate date,
    CustomerId int,
    SalesId int,
    foreign key (CustomerId) references Customers(CustomerId),
    foreign key (SalesId) references SalesPersons(SalesId)
);

--order details table--
create table OrderDetails (
    OrderDetailId int primary key identity(1,1),
    OrderId int,
    ProductId int,
    Quantity int,
    foreign key (OrderId) references CustomerOrders(OrderId),
    foreign key (ProductId) references Products(ProductId)
);


--Q2 3rd Highest--
with OrderTotals as (
select o.OrderId, c.CustomerName, sum(ord.Quantity * p.UnitPrice) as TotalSales
from CustomerOrders o
join Customers c on o.CustomerId = c.CustomerId
join OrderDetails ord on o.OrderId = ord.OrderId
join Products p on ord.ProductId = p.ProductId
group by o.OrderId, c.CustomerName
)
select CustomerName, TotalSales
from OrderTotals

order by TotalSales desc
offset 2 rows fetch next 1 row only;


--SalesPerson sales>60000--
select s.SalesPersonName, sum(ord.Quantity * p.UnitPrice) as TotalSales
from CustomerOrders o
join SalesPersons s on o.SalesId = s.SalesId
join OrderDetails ord on o.OrderId = ord.OrderId
join Products p on ord.ProductId = p.ProductId
group by s.SalesPersonName

having sum(ord.Quantity * p.UnitPrice) > 60000;

-- Customers above avg spending--
with CustomerTotals as (
select c.CustomerId,c.CustomerName, sum(ord.Quantity * p.UnitPrice) as TotalSpent
from Customers c
join CustomerOrders o on c.CustomerId = o.CustomerId
join OrderDetails ord on o.OrderId = ord.OrderId
join Products p on ord.ProductId = p.ProductId
group by c.CustomerId, c.CustomerName
)
select CustomerName, TotalSpent
from CustomerTotals

where TotalSpent > (select avg(TotalSpent) from CustomerTotals);

--Uppercase name & ord month
select upper(c.CustomerName) as CustomerNameUpper, month(o.OrderDate) as OrderMonth, o.OrderId
from Customers c
join CustomerOrders o on c.CustomerId = o.CustomerId;

--Orders placed in Jan2026--
select o.OrderId,c.CustomerName,o.OrderDate
from CustomerOrders o
join Customers c on o.CustomerId = c.CustomerId

where month(o.OrderDate) = 1 and year(o.OrderDate) = 2026;

**/
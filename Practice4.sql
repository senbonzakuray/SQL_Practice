USE Northwind
GO

--1.Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_X
AS
SELECT P.ProductName, SUM(OD.Quantity) AS Total_Quant FROM Products P JOIN [Order Details] OD 
ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

SELECT * FROM view_product_order_X
--
--2.Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
ALTER PROC sp_product_order_quantity_X
@ProductID INT,
@TotalOrderQty INT OUT
AS
BEGIN
SELECT @TotalOrderQty = SUM(OD.Quantity) FROM Products P JOIN [Order Details] OD 
ON P.ProductID = OD.ProductID
WHERE P.ProductID = @ProductID
GROUP BY P.ProductName
RETURN @TotalOrderQty
END

DECLARE @Tot INT
EXEC sp_Product_Order_Quantity_X 11,@Tot OUT
PRINT @Tot 
-
--3.Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
SELECT * FROM [Order Details]
SELECT * FROM Products
SELECT * FROM Orders

ALTER PROC sp_product_order_city_X
@ProductName NVARCHAR(50)
AS
BEGIN
SELECT DT.ShipCity, DT.QTY FROM
(SELECT P.ProductName, O.ShipCity, SUM(OD.Quantity) AS QTY, RANK()OVER(PARTITION BY P.ProductName ORDER BY SUM(OD.Quantity) DESC) AS RNK FROM Orders O 
JOIN [Order Details] OD ON O.OrderID = OD.OrderID JOIN Products P ON  OD.ProductID = P.ProductID
GROUP BY P.ProductName,O.ShipCity) DT
WHERE DT.ProductName = @ProductName AND RNK <= 5
END

EXEC sp_Product_Order_City_X 'Queso Cabrales'

--
USE FebBatch
GO
--
--4.Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
--Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE people_X(
id int,
PName varchar(40),
City int
)
INSERT INTO people_X VALUES (1, 'Aaron Rodgers', 2)
INSERT INTO people_X VALUES (2, 'Russell Wilson', 1)
INSERT INTO people_X VALUES ( 3, 'Jody Nelson', 2)
--
CREATE TABLE city_X(
id int,
City VARCHAR(20)
)
INSERT INTO city_X VALUES (1, 'Seattle')
INSERT INTO city_X VALUES (2, 'Green Bay')
--
SELECT * FROM people_X
SELECT * FROM city_X
DELETE city_X
WHERE City = 'Seattle'
INSERT INTO city_X VALUES (1, 'Madison')
---
CREATE VIEW Packers_X
AS 
SELECT P.PName FROM people_X P JOIN city_X C ON P.City = C.id
WHERE C.City = 'Green Bay'
SELECT * FROM Packers_X
---
DROP TABLE people_X
GO
DROP TABLE city_X
GO
DROP VIEW Packers_X
GO
--
--5.Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_X
AS
BEGIN
SELECT * INTO #EmployeeTemp
FROM Employees WHERE DATEPART(MM,BirthDate) = 02
SELECT * FROM #EmployeeTemp
END

--6.How do you make sure two tables have the same data?
--USE UNION


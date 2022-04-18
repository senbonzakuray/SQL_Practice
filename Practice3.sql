USE Northwind
GO
--1. List all cities that have both Employees and Customers.
SELECT DISTINCT E.City FROM Employees E JOIN Customers C ON E.City = C.City 
--or
SELECT DISTINCT City FROM Customers 
WHERE City IN (SELECT DISTINCT City FROM Employees)
--
--2. List all cities that have Customers but no Employee.

--a. Use sub-query
SELECT DISTINCT City FROM Customers 
WHERE City NOT IN (SELECT DISTINCT City FROM Employees)
--
--b. Do not use sub-query
SELECT DISTINCT C.City FROM Customers C LEFT JOIN Employees E ON E.City = C.City 
WHERE E.City IS NULL
--
--3. List all products and their total order quantities throughout all orders.
SELECT P.ProductName, SUM(OD.Quantity) AS Total_Quant FROM Products P JOIN [Order Details] OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
--
--4. List all Customer Cities and total products ordered by that city.
SELECT O.ShipCity, SUM(OD.Quantity) AS Total_Quant FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCity
--
--5. List all Customer Cities that have at least two customers.

--a. Use union
---
--b. Use sub-query and no union
SELECT City FROM Customers
GROUP BY City 
HAVING COUNT(City)>=2
--6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT O.ShipCity, COUNT(DISTINCT OD.ProductID) FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCity
HAVING COUNT(OD.ProductID)>=2 
--
--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT C.ContactName FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID 
WHERE C.City != O.ShipCity
--
--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 ProductID, (SUM(UnitPrice * Quantity))/SUM(Quantity) AS Avg_Price FROM [Order Details]
GROUP BY ProductID
ORDER BY SUM(Quantity) DESC
--9. List all cities that have never ordered something but we have employees there.

--a. Use sub-query
SELECT E.City FROM Employees E
WHERE E.City NOT IN (SELECT O.ShipCity FROM Orders O)
--b. Do not use sub-query
SELECT DISTINCT E.City FROM Employees E LEFT JOIN Orders O 
ON E.City = O.ShipCity
WHERE O.ShipCity IS NULL
--
--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT * FROM Employees

--11. How do you remove the duplicates record of a table?
--GROUP BY and count(*)
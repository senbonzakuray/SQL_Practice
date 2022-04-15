USE AdventureWorks2019
GO
--1.      How many products can you find in the Production.Product table?
SELECT COUNT(Name) FROM Production.Product
-- 504 products
--
--2.      Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(P.NAME) FROM Production.Product P 
JOIN Production.ProductSubcategory S 
ON P.ProductSubcategoryID = S.ProductSubcategoryID
-- 295 products
--
--3.      How many Products reside in each SubCategory? Write a query to display the results with the following titles.

--ProductSubcategoryID CountedProducts
SELECT P.ProductSubcategoryID, COUNT(P.ProductSubcategoryID) AS CountedProducts FROM Production.Product P 
JOIN Production.ProductSubcategory S 
ON P.ProductSubcategoryID = S.ProductSubcategoryID
GROUP BY P.ProductSubcategoryID
--
--4.      How many products that do not have a product subcategory.
SELECT COUNT(Name) FROM Production.Product
WHERE ProductSubcategoryID IS NULL
-- 209
--
--5.      Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) FROM Production.ProductInventory
GROUP BY ProductID
--
--6.    Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.

--            ProductID    TheSum

SELECT ProductID, SUM(Quantity) AS TheSum FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100
--7.    Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

--  Shelf      ProductID    TheSum
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100
--
--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(Quantity) FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID
--
--9.    Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory

--    ProductID   Shelf      TheAvg

SELECT ProductID,Shelf, AVG(Quantity) AS TheAvg FROM Production.ProductInventory
GROUP BY ProductID,Shelf
--
--10.  Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

--    ProductID   Shelf      TheAvg
SELECT ProductID,Shelf, AVG(Quantity) AS TheAvg FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID,Shelf
--
--11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

--    Color                        Class              TheCount          AvgPrice
SELECT Color, Class,  COUNT(Color) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class
--Joins:

--12.   Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.

--    Country                        Province
SELECT C.Name AS Country, S.Name AS Province FROM person.CountryRegion C JOIN person.StateProvince S
ON C.CountryRegionCode = S.CountryRegionCode
ORDER BY C.Name
--
--13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

--    Country                        Province
SELECT C.Name AS Country, S.Name AS Province FROM person.CountryRegion C JOIN person.StateProvince S
ON C.CountryRegionCode = S.CountryRegionCode
WHERE C.Name in ('Germany', 'Canada')
ORDER BY C.Name

-- Using Northwnd Database: (Use aliases for all the Joins)
USE Northwind
GO
--
--14.  List all Products that has been sold at least once in last 25 years.
SELECT  DISTINCT P.ProductName FROM dbo.Products P JOIN dbo.[Order Details] OD ON P.ProductID = OD.ProductID
JOIN dbo.Orders O ON O.OrderID = OD.OrderID
WHERE DATEDIFF(year,o.OrderDate,GETDATE()) < 25


--15.  List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS CT FROM Orders o JOIN [Order Details] od 
ON o.OrderID = od.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
ORDER BY CT DESC
--
--16.  List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS CT FROM Orders o JOIN [Order Details] od 
ON o.OrderID = od.OrderID
WHERE o.ShipPostalCode IS NOT NULL AND
DATEDIFF(year,o.OrderDate,GETDATE()) < 25
GROUP BY ShipPostalCode
ORDER BY CT DESC

--17.   List all city names and number of customers in that city.     
SELECT City, COUNT(DISTINCT CustomerID) AS CT FROM Customers
GROUP BY City
--
--18.  List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(DISTINCT CustomerID) AS CT FROM Customers
GROUP BY City
HAVING COUNT(DISTINCT CustomerID) >2
--
--19.  List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT C.ContactName FROM dbo.Customers C JOIN dbo.Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderDate > '1998-01-01'
--
--20.  List the names of all customers with most recent order dates
SELECT DISTINCT ContactName FROM dbo.Customers  
WHERE CustomerID IN (SELECT CustomerID FROM dbo.Orders
WHERE OrderDate = (SELECT MAX(OrderDate) FROM dbo.Orders))
--
--21.  Display the names of all customers  along with the  count of products they bought
SELECT C.ContactName, SUM(OD.Quantity) AS Ct_of_Product FROM dbo.Customers C JOIN dbo.Orders O ON C.CustomerID = O.CustomerID
JOIN dbo.[Order Details] OD on O.OrderID = OD.OrderID
GROUP BY C.ContactName
--
--22.  Display the customer ids who bought more than 100 Products with count of products.
SELECT O.CustomerID, SUM(OD.Quantity) AS Ct_of_Product FROM dbo.Orders O 
JOIN dbo.[Order Details] OD on O.OrderID = OD.OrderID
GROUP BY O.CustomerID
HAVING SUM(OD.Quantity) >100
--
--23.  List all of the possible ways that suppliers can ship their products. Display the results as below

--    Supplier Company Name                Shipping Company Name
SELECT DISTINCT SU.CompanyName AS Supplier_Company, SP.CompanyName AS Shipping_Company 
FROM dbo.Suppliers SU CROSS JOIN dbo.Shippers SP
ORDER BY SU.CompanyName
--
--24.  Display the products order each day. Show Order date and Product Name.
SELECT O.OrderDate,  P.ProductName FROM dbo.Orders O JOIN dbo.[Order Details] OD on O.OrderID = OD.OrderID
JOIN dbo.Products P ON OD.ProductID = P.ProductID
ORDER BY O.OrderDate
--
--25.  Displays pairs of employees who have the same job title.
SELECT Title, LastName + ' '+ FirstName AS Name
FROM Employees
ORDER BY Title
--
--26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT E2.FirstName, E2.LastName From dbo.Employees E1 JOIN dbo.Employees E2 ON E1.ReportsTo = E2.EmployeeID
--
--27.  Display the customers and suppliers by city. The results should have the following columns
--City,Name,Contact Name,Type (Customer or Supplier)
SELECT C.City, C.CompanyName, C.ContactName, 'Customer' AS Type  FROM Customers C
UNION
SELECT S.City, S.CompanyName, S.ContactName, 'Supplier' AS Type FROM Suppliers S
/*============================================= SQL Class  Day 3 =================================================*/
/* Q1 Display the products names of all products that belongs to the 'Beverrages' Category. */
-- Case 1:
SELECT 
    ProductName
FROM Products p
JOIN Categories c 
    ON p.CategoryID = c.CategoryID
WHERE CategoryName = 'Beverages';

-- Case 2:
SELECT ProductName
FROM Products
WHERE CategoryID = (SELECT CategoryID 
                        FROM Categories
                        WHERE CategoryName = 'Beverages');



/* ---------------------------------------------------- UNION -----------------------------------------------*/
-- UNION function the tables have to have the same number of column. It keep everthing but once only.
-- UNION = OR (exclusive) then UNION ALL = UNION = OR (It keeps everything).
SELECT ProductID, RetailPrice
FROM Product
UNION ALL
SELECT ProductID, UnitPrice
FROM Sales;

-- INTERSECT = intersion = AND
SELECT ProductID, RetailPrice
FROM Product
INTERSECT
SELECT ProductID, UnitPrice
FROM Sales;
---
SELECT *
FROM Product
WHERE ProductID = 15; --- TetailPrice = 401.95



/* ++++++++++++++++++++++++++++++++++++++++ Data Manipulation Language (DML) +++++++++++++++++++++++++++++++++++++++++++++++*/
-- Consider the Region table here :
SELECT *
FROM Region;

-- INSERT a new region below
INSERT INTO Region (RegionName)
VALUES ('South France')

-- UPDATE permet d’effectuer des modifications sur des lignes existantes.
UPDATE Region
SET RegionName = 'Senegal' 
WHERE RegionID = 8;

-- DELETE FROM remove a specfic row. By default, it removes all the rows.
DELETE FROM region
WHERE RegionID IN (12, 11);
--- 

-- Q: For every product that has the same category than product n°10, change the channel to the same as product n°5
UPDATE Product
SET channels = (SELECT Channels 
                FROM Product
                WHERE ProductID = 5)
WHERE ProductCategory = (SELECT ProductCategory
                            FROM Product
                            WHERE ProductID = 10); -- A : Be careful executing this query.
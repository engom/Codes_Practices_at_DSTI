/* ================================================ SQL Class Day 2 (07 décembre 2021) ====================================*/
SELECT 
    OrderNumber,
    ProductID,
    ShipDate,
    OrderDate,
    DATEDIFF(day, OrderDate, ShipDate) AS ShipDelayInDay, /* Delay in days: possible in minute or month */
    DATEDIFF(year, OrderDate, GETDATE()) AS OrderDelayInYear /* Delay in years */
FROM Sales;

/* -------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    'The order ' + OrderNumber +  ' was made on ' + CAST(OrderDate AS VARCHAR) AS OrderDescription/* CAST method to convert */
FROM Sales;

/* -------------------------------------------------------------------------------------------------------------------------*/

SELECT
    MONTH(OrderDate) AS MonthOrderDate, /* Month of the order */
    YEAR(OrderDate) AS YearOrderDate  /*  Year of the date */
FROM Sales;

 /* COALESCE function */

SELECT
    OrderNUmber,
    OrderDate,
    PromotionCode,
    COALESCE(PromotionCode, 'No Discount') AS PromotionStatus  /* COALESCE checks here NULL and remplaces them by the given string */
FROM Sales;

/* ---------------------------------- CASE + WHEN + THEN + ELSE + END -------------------------------------------------------------*/

SELECT 
    OrderNumber,
    Quantity*UnitPrice AS SalesAmount,
    CASE 
        WHEN Quantity*UnitPrice < 100
            THEN 'Low sell'
        WHEN Quantity*UnitPrice < 200
            THEN 'Medium sell'
        WHEN Quantity*UnitPrice < 500
            THEN 'High sell'
        ELSE 
            'Very high sell'
    END AS SellRating /* Alias cames after the END !!!! */
FROM Sales;

/* __________________________________________ AGGREGATE FUNCTIONS _____________________________________________________ */

SELECT
    SUM(UnitPrice * Quantity) AS TotalSalesAmont,
    AVG(UnitPrice * Quantity) AS MeanSalesAmount,
    MIN(UnitPrice * Quantity) AS MinSalesAmount,
    MAX(UnitPrice * Quantity) AS MaxSalesAmount
    FROM Sales;

SELECT
    COUNT(*),
    COUNT(OrderNumber),
    COUNT(UnitPrice),
    COUNT(Quantity),
    COUNT(PromotionCode) /* COUNT method does not  NULL values*/
FROM Sales;

/* ------------------------------------ HAVING method to disguish groups ------------------------------------------------*/

SELECT 
    ProductCategory,
    AVG(RetailPrice) AS AvgPrice,
    COUNT(*) AS NumberOfProduct
FROM Product
WHERE ProductCategory NOT IN ('Trainer', 'Glider') /* Fiter categories with WHERE */
GROUP BY ProductCategory
HAVING AVG(RetailPrice) > 200
ORDER BY AvgPrice DESC; /* We can use the alias alter FROM */

/* ==================================================== JOIN TABLES ====================================================*/

/* Oberverve the Sales foreign keys  */
SELECT *
FROM Sales
WHERE OrderNumber = 'TT00017434'

/* JOIN Product table and  Sales as they have both ProductID foreign keys */
SELECT *
FROM Sales
JOIN Product
    ON Sales.ProductID = Product.ProductID;

SELECT
    OrderDate, -- coming from Sales table
    ProductName, --  coming from Product table
    P.ProductID,
    S.ProductID
FROM Sales AS S -- with alias but it's not always useful
JOIN Product AS P -- alias P 
    ON S.ProductID = P.ProductID;


-- Another way of joining
SELECT 
    OrderDate, -- coming from Sales table
    ProductName --  coming from Product table
FROM Sales, Product  -- Call tables 
WHERE Sales.ProductID = Product.ProductID;

/* ------------ Join selected items for tables ----------- */
SELECT 
    OrderNumber,
    ProductName,
    ProductCategory,
    UnitPrice*Quantity AS SalesAmount
FROM Sales s
INNER JOIN Product p 
    On s.ProductID = p.ProductID
ORDER BY ProductName, UnitPrice;

--- INNER JOIN : Tous les employers ayant un departement et leur departement.
--- LEFT OUTER JOIN : Tous les employers avec leurs departements et les employers n'ayant pas de departement.
--- RIGHT OUTER JOIN : Tous les employer et leu departement ansi que les departements n'ayan pas d'employers.


SELECT *
FROM [State] s  -- Left table
RIGHT JOIN Region r -- Right table
    ON s.RegionID = r.RegionID;

SELECT *
FROM [State], Region
WHERE [State].RegionID = Region.RegionID;

SELECT *
FROM [State] s 
FULL JOIN  Region r
    ON s.RegionID = r.RegionID;


--- Multiple JOIN in query : Fraom Sales JOIN State ON JOIN Region ON
SELECT
    OrderNumber,
    Quantity*UnitPrice AS SalesAmount,
    StateName
FROM Sales sa 
JOIN State st 
    ON sa.CustomerStateID = st.StateID
JOIN Region r 
    ON st.RegionID = r.RegionID;

/* ================================================ SQL Class Day 3 (08 décembre 2021) ====================================*/
/* --------------------------------------- EXERCICES ---------------------------------------*/
-- Q1 : Dispaly the number of Order for each year
-- Q2 : What is the total sales amount for each category of product
-- Q3 : What is the average sale amount for sales that occured 
        -- in a region that contains 'W'
-- Q4 : For each sale where is discount was applied, display the order number, the state and the product name

-- A1 : Dispaly the number of Order for each year
/* _________________________________________SOLUTIONS__________________________________________*/
SELECT 
    COUNT(OrderNumber) AS TotalOrder,
    YEAR(OrderDate) AS YearOrderDate  /*  Year of the date */
FROM Sales
GROUP BY YEAR(OrderDate);

-- A2 : What is the total sales amount for each category of product
SELECT 
    SUM(UnitPrice*Quantity) AS SalesAmount,
    ProductCategory
FROM Sales, Product  -- Call tables 
WHERE Sales.ProductID = Product.ProductID
GROUP BY ProductCategory;
-- second method 
SELECT 
    ProductCategory,
    SUM(UnitPrice*Quantity) AS SalesAmount
FROM Sales s 
JOIN Product p 
        ON s.ProductID = p.ProductID
GROUP BY ProductCategory;

-- Q3 : What is the average sale amount for sales that occured 
        -- in a region that contains 'W'

SELECT
    AVG(UnitPrice*Quantity) AS AvgSalesAmount
FROM Sales sa 
JOIN  [State] st 
    ON sa.CustomerStateID = st.StateID
JOIN Region r
    On st.StateID = r.RegionID
WHERE RegionName LIKE '%W%';

/* Dans le cas où on veut voir par regions : on ajoute toujours group by */
SELECT
    RegionName,
    AVG(UnitPrice*Quantity) AS AvgSalesAmount
FROM Sales sa 
JOIN  [State] st 
    ON sa.CustomerStateID = st.StateID
JOIN Region r
    On st.StateID = r.RegionID
WHERE RegionName LIKE '%W%'
GROUP By RegionName;

-- Q4 : For each sale where a discount was applied, display the order number, the state and the product name
SELECT 
    OrderNumber,
    StateName,
    ProductName
FROM Sales sa 
JOIN  [State] st 
    ON sa.CustomerStateID = st.StateID
JOIN Product p 
    ON sa.ProductID = p.ProductID
WHERE DiscountAmount = 0; --- Use DiscountAmount egals to zero
-- or 
SELECT 
    OrderNumber,
    StateName,
    ProductName
FROM Sales sa 
JOIN  [State] st 
    ON sa.CustomerStateID = st.StateID
JOIN Product p 
    ON sa.ProductID = p.ProductID
WHERE PromotionCode IS NOT NULL; --- Select not NULL PromotionCode
----------------------------------------------------------- END -------------------------------------------------------------

SELECT 
ProductCategory,
SUBSTRING(ProductSKU, 6, LEN(ProductCategory) - 3) AS SKU /*  From the 6th item  3rd string up to the end*/
FROM Product;

SELECT
     ProductSKU,
     ProductID,
     REPLACE(ProductSKU, '-', ' ') /* Remplace dash by space  */
FROM 
    Product;

/* JOIN funcyion */

SELECT *
FROM State s
JOIN Region r 
     ON s.RegionID = r.RegionID;

SELECT 
     OrderDate,
     OrderNumber,
     Quantity,
     UnitPrice
FROM Sales;
     
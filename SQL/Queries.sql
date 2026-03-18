-- BASIC LEVEL (1–20)
-- 1. Display all records from the table.
SELECT * FROM zepto;

-- 2. Show only the name and mrp of all products
SELECT name,mrp  FROM zepto;

-- 3. List all products where Category = 'Fruits & Vegetables'
SELECT *
FROM zepto
WHERE category = 'Fruits & Vegetables';

-- 4. Find products where mrp is greater than 3000.
SELECT *
FROM zepto
WHERE mrp >= 3000;

-- 5. Show products where discountPercent is 15.
SELECT *
FROM zepto
WHERE discountPercent = 15;

-- 6. Display products where outOfStock is FALSE
SELECT *
FROM zepto
WHERE outOfStock = 'FALSE';

-- 7. List the names of products with weightInGms greater than 500.
SELECT name
FROM zepto
WHERE weightInGms > 500;

-- 8.  Find products where availableQuantity is less than 5.
SELECT *
FROM zepto
WHERE availableQuantity < 5;

-- 9. Show distinct categories available in the table.
SELECT DISTINCT category FROM zepto;

-- 10. Count the total number of products
SELECT COUNT(*) AS total_products FROM zepto;

-- 11. Display products sorted by mrp in ascending order.
SELECT * FROM zepto ORDER BY mrp ASC;

-- 12. Display products sorted by discountPercent in descending order.
SELECT * FROM zepto ORDER BY discountPercent DESC;

-- 13. Show top 10 most expensive products based on mrp.
SELECT * FROM zepto ORDER BY mrp DESC LIMIT 10;

-- 14. Find products where name starts with letter ‘T’
SELECT * FROM zepto WHERE name LIKE 'T%';

-- 15. Count how many products are out of stock.
SELECT COUNT(*) 
FROM zepto
WHERE outOfStock = TRUE;

-- 16. Show products where quantity is greater than 50.
SELECT *
FROM zepto
WHERE quantity > 50 ;

-- 17. Find products where mrp is between 2000 and 4000.
SELECT *
FROM zepto
WHERE mrp BETWEEN 2000 and 4000 ;

-- 18. Display products where discountedSellingPrice is less than 1500.
SELECT *
FROM zepto
WHERE discountedSellingPrice < 1500 ;

-- 19. List products where weightInGms equals 1000.
SELECT *
FROM zepto
WHERE  weightInGms = 1000 ;

-- 20. Show all products whose category contains the word ‘Vegetables’
SELECT *
FROM zepto
WHERE  category LIKE '%Vegetables%' ;

-- INTERMEDIATE LEVEL (21–35)
-- 21. Find the maximum mrp in each category
SELECT category, MAX(mrp) FROM zepto GROUP BY category;

-- 22. Find the minimum discountedSellingPrice in each category.
SELECT category, MIN(discountedSellingPrice) FROM zepto GROUP BY category;

-- 23. Count the number of products in each category.
SELECT category, COUNT(*) FROM zepto GROUP BY category;

-- 24. Calculate the average mrp of all products.
SELECT AVG(mrp)
FROM zepto;

-- 25. Show total available quantity of products category-wise
SELECT category, SUM(availableQuantity ) as Available_Quantity
FROM zepto
GROUP BY category;

-- 26. Find products where the difference between mrp and discountedSellingPrice is greater than 1000
SELECT *
FROM zepto
WHERE  (mrp - discountedSellingPrice) > 1000 ;

-- 27. Display products with discount greater than the average discount.
SELECT *
FROM zepto
WHERE  discountPercent > (SELECT AVG(discountPercent) FROM zepto);

-- 28. Show categories having more than 50 products
SELECT category 
FROM zepto
GROUP BY category
HAVING COUNT(*) > 50 ;

-- 29. Find top 5 products with highest discount percent.
SELECT name, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 5;

-- 30. Display total inventory weight (weightInGms * availableQuantity) for each product
SELECT name, 
       (weightInGms * availableQuantity) AS inventory_weight
FROM zepto;

-- 31. Find products where discountedSellingPrice is less than 50% of mrp.
SELECT *
FROM zepto
WHERE discountedSellingPrice < (mrp * 0.5);

-- 32. Show products whose names contain the word ‘Coconut’.
SELECT * FROM zepto
WHERE name LIKE '%Coconut%';

-- 33. Calculate total stock value (discountedSellingPrice * availableQuantity) for each product.
SELECT name, (discountedSellingPrice * availableQuantity) AS totalstockvalue FROM zepto;

-- 34. Display the category with the highest average discount.
SELECT Category, AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY Category
ORDER BY avg_discount DESC
LIMIT 1;

-- 35. Show products where availableQuantity is zero but outOfStock is FALSE (data inconsistency check).
SELECT * FROM zepto
WHERE availableQuantity = 0 AND outOfStock = FALSE;

-- ADVANCED LEVEL (36–50)
-- 36. Rank products within each category based on mrp.
SELECT *,RANK() OVER (PARTITION BY Category ORDER BY mrp DESC) AS rank_mrp
FROM zepto;

-- 37. Find the second highest mrp product in each category.
 SELECT * FROM (
        SELECT *,
        DENSE_RANK() OVER (PARTITION BY Category ORDER BY mrp DESC) AS rnk
        FROM zepto
    ) t WHERE rnk = 2;

-- 38. Display cumulative sum of availableQuantity category-wise
SELECT *,SUM(availableQuantity) OVER(PARTITION BY category ORDER BY name) AS cumulative_qty
FROM zepto;

-- 39. Find products whose mrp is higher than the average mrp of their category.
SELECT *
FROM zepto z
WHERE mrp > (
    SELECT AVG(mrp)
    FROM zepto
    WHERE category = z.category
);
SELECT * FROM zepto
WHERE mrp > (SELECT AVG(mrp) FROM zepto);

-- 40. Identify products where discount percent is above category average discount.
SELECT *
FROM zepto z
WHERE discountPercent >
      (SELECT AVG(discountPercent)
       FROM zepto
       WHERE category = z.category);

-- 41. Create a view showing only in-stock products with discount greater than 20%.
CREATE VIEW high_discount_instock AS
SELECT *
FROM zepto
WHERE outOfStock = FALSE
  AND discountPercent > 20;

-- 42. Write a query to update outOfStock = TRUE where availableQuantity = 0.
UPDATE zepto
SET outOfStock = TRUE
WHERE availableQuantity = 0;

-- 43. Create a stored procedure to fetch products by category name.
DELIMITER //
CREATE PROCEDURE get_products_by_category(IN cat_name VARCHAR(100))
BEGIN
    SELECT *
    FROM zepto
    WHERE category = cat_name;
END //
DELIMITER ;
CALL get_products_by_category('Fruits & Vegetables');

-- 44. Create a function to calculate discount amount (mrp - discountedSellingPrice).
DELIMITER //
CREATE FUNCTION discount_amount(mrp INT, selling_price INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN mrp - selling_price;
END //
DELIMITER ;
SELECT name, discount_amount(mrp, discountedSellingPrice) AS discount
FROM zepto;

-- 45. Find duplicate product names if any exist.
SELECT name, COUNT(*) AS count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1;

-- 46. Show top 3 cheapest products in each category.
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY category
               ORDER BY discountedSellingPrice ASC
           ) AS price_rank
    FROM zepto
) t
WHERE price_rank <= 3;

-- 47. Find categories where total stock value exceeds 1,00,000
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_stock_value
FROM zepto
GROUP BY category
HAVING total_stock_value > 100000;

-- 48. Create a trigger that sets outOfStock to TRUE when availableQuantity becomes 0.
DELIMITER //
CREATE TRIGGER set_out_of_stock
BEFORE UPDATE ON zepto
FOR EACH ROW
BEGIN
    IF NEW.availableQuantity = 0 THEN
        SET NEW.outOfStock = TRUE;
    ELSE
        SET NEW.outOfStock = FALSE;
    END IF;
END //
DELIMITER ;

-- 49. Generate a report showing: Category, Total Products, Avg MRP, Avg Discount.
SELECT category,
       COUNT(*) AS total_products,
       AVG(mrp) AS avg_mrp,
       AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY category;

-- 50. Write a query using a subquery to find products with mrp greater than overall average mrp.
SELECT *
FROM zepto
WHERE mrp >
      (SELECT AVG(mrp) FROM zepto);
/*
Project: Restaurant Operations Analysis
Client: Taste of the World Cafe
Role: Data Analyst
Database: PostgreSQL

Objectives:
1. Explore the menu_items table to understand what's on the new menu
2. Explore the order_details table to understand order trends
3. Analyze customer behavior and spending patterns
*/


-- ========================================
-- OBJECTIVE 1: EXPLORE THE MENU_ITEMS TABLE
-- ========================================

-- View the menu_items table
SELECT * FROM menu_items;

-- Find the number of items on the menu
SELECT COUNT(DISTINCT item_name) AS total_menu_items
FROM menu_items;

-- What are the least and most expensive items on the menu?
(
  SELECT * FROM menu_items
  ORDER BY price ASC
  LIMIT 1
)
UNION ALL
(
  SELECT * FROM menu_items
  ORDER BY price DESC
  LIMIT 1
);

-- How many Italian dishes are there on the menu?
SELECT COUNT(*) AS italian_dish_count
FROM menu_items
WHERE category = 'Italian';

-- What are the least and most expensive Italian dishes?
(
  SELECT * FROM menu_items
  WHERE category = 'Italian'
  ORDER BY price ASC
  LIMIT 1
)
UNION ALL
(
  SELECT * FROM menu_items
  WHERE category = 'Italian'
  ORDER BY price DESC
  LIMIT 1
);

-- How many dishes are in each category? What is the average dish price within each category?
SELECT 
  category,
  COUNT(item_name) AS item_count,
  ROUND(AVG(price), 2) AS avg_price
FROM menu_items
GROUP BY category
ORDER BY item_count DESC;


-- ========================================
-- OBJECTIVE 2: EXPLORE THE ORDER_DETAILS TABLE
-- ========================================

-- View the order_details table
SELECT * FROM order_details;

-- What is the date range of the orders table?
SELECT 
  MIN(order_date) AS start_date, 
  MAX(order_date) AS end_date
FROM order_details;

-- How many orders were made within this date range?
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM order_details;

-- How many items were ordered within this date range?
SELECT COUNT(item_id) AS total_items_ordered
FROM order_details;

-- Which orders had the most number of items?
SELECT 
  order_id, 
  COUNT(item_id) AS item_count
FROM order_details
GROUP BY order_id
ORDER BY item_count DESC;

-- How many orders had more than 12 items?
SELECT COUNT(*) AS orders_above_12_items
FROM (
  SELECT order_id, COUNT(item_id) AS item_count
  FROM order_details
  GROUP BY order_id
  HAVING COUNT(item_id) > 12
) AS subquery;


-- ========================================
-- OBJECTIVE 3: ANALYZE CUSTOMER BEHAVIOR
-- ========================================

-- Combine the menu_items and order_details table into a single table
SELECT * 
FROM order_details AS od
LEFT JOIN menu_items AS mi
  ON od.item_id = mi.menu_item_id;

-- What were the least and most ordered items? What categories were they in?
SELECT
  mi.category,
  mi.item_name,
  COUNT(*) AS item_count
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
WHERE mi.item_name IS NOT NULL
GROUP BY mi.category, mi.item_name
ORDER BY item_count ASC;

-- What were the top 5 orders that spent the most money?
SELECT 
  od.order_id,
  ROUND(SUM(mi.price), 2) AS total_spent
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id
HAVING SUM(mi.price) IS NOT NULL
ORDER BY total_spent DESC
LIMIT 5;

-- View the details of the highest-spending order
SELECT 
  od.order_id, 
  od.order_date, 
  od.order_time, 
  ROUND(SUM(mi.price), 2) AS total_spent
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id, od.order_date, od.order_time
ORDER BY total_spent DESC
LIMIT 1;

-- View the details of the top 5 highest-spending orders
SELECT 
  od.order_id, 
  od.order_date, 
  od.order_time, 
  ROUND(SUM(mi.price), 2) AS total_spent
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id, od.order_date, od.order_time
ORDER BY total_spent DESC
LIMIT 5;

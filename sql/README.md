# 🍽️ Restaurant Operations Analysis – SQL Queries

**Client:** Taste of the World Cafe  
**Role:** Data Analyst  
**Database:** PostgreSQL  

This project explores the performance of a new menu using SQL to identify customer preferences, menu trends, and high-impact product insights.

## 🎯 Project Objectives

1. Explore the `menu_items` table to understand what's on the new menu  
2. Explore the `order_details` table to understand order trends  
3. Analyze customer behavior and spending patterns  


## 🧾 Objective 1: Explore the `menu_items` Table

### View the Menu Items Table
```sql
SELECT * FROM menu_items;
```
<img width="396" alt="Screenshot 2025-05-08 183610" src="https://github.com/user-attachments/assets/e16b3ca8-e2ec-4e09-a7e9-245f8aa68fd0" />

### Find the number of items on the menu
```sql
SELECT COUNT(DISTINCT item_name) AS total_menu_items
FROM menu_items;
```
<img width="128" alt="image" src="https://github.com/user-attachments/assets/589770f6-7083-4818-ba40-d700d864e634" />

### Least and most expensive items on the menu
```sql
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
```
<img width="398" alt="image" src="https://github.com/user-attachments/assets/7d3ad230-b08b-42c7-a727-7000b9912a9d" />

### No.of Italian dishes on the menu
```sql
SELECT COUNT(*) AS italian_dish_count
FROM menu_items
WHERE category = 'Italian';
```
<img width="131" alt="image" src="https://github.com/user-attachments/assets/57c171e0-67d5-4d1c-abcd-7e46d0297ae0" />

### Least and most expensive Italian dishes
```sql
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
```
<img width="397" alt="image" src="https://github.com/user-attachments/assets/979cb3f7-b5e8-4ea3-8994-72b4c451e7cb" />

### How many dishes are in each category? What is the average dish price within each category?
```sql
SELECT 
  category,
  COUNT(item_name) AS item_count,
  ROUND(AVG(price), 2) AS avg_price
FROM menu_items
GROUP BY category
ORDER BY item_count DESC;
```
<img width="280" alt="image" src="https://github.com/user-attachments/assets/dc9442ea-94d9-4166-93c3-0efffe25fc4a" />

## 🧾 Objective 2: EXPLORE THE 'order_details' TABLE

### View the order_details table
```sql
SELECT * FROM order_details;
```
<img width="418" alt="image" src="https://github.com/user-attachments/assets/acf7688b-2bf4-49fd-8f8f-7b1e553b8d50" />

### What is the date range of the orders table?
```sql
SELECT 
  MIN(order_date) AS start_date, 
  MAX(order_date) AS end_date
FROM order_details;
```
<img width="160" alt="image" src="https://github.com/user-attachments/assets/dbd0dee6-50cb-494c-96e4-29462f727e02" />

### How many orders were made within this date range?
```sql
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM order_details;
```
<img width="107" alt="image" src="https://github.com/user-attachments/assets/9b734f94-6bd3-4fd3-85a3-cf6676798c83" />

### How many items were ordered within this date range?
```sql
SELECT COUNT(item_id) AS total_items_ordered
FROM order_details;
```
<img width="140" alt="image" src="https://github.com/user-attachments/assets/df30a7f8-f9ef-464e-be1f-39b66c5d8b1e" />

### Which orders had the most number of items?
```sql
SELECT 
  order_id, 
  COUNT(item_id) AS item_count
FROM order_details
GROUP BY order_id
ORDER BY item_count DESC;
```
<img width="159" alt="image" src="https://github.com/user-attachments/assets/5278eac6-0da4-46c6-93ed-75c359126263" />

### How many orders had more than 12 items?
```sql
SELECT COUNT(*) AS orders_above_12_items
FROM (
  SELECT order_id, COUNT(item_id) AS item_count
  FROM order_details
  GROUP BY order_id
  HAVING COUNT(item_id) > 12
) AS subquery;
```
## OBJECTIVE 3: ANALYZE CUSTOMER BEHAVIOR

### Combine the menu_items and order_details table into a single table
```sql
SELECT * 
FROM order_details AS od
LEFT JOIN menu_items AS mi
  ON od.item_id = mi.menu_item_id;
```
<img width="782" alt="image" src="https://github.com/user-attachments/assets/51e1be7e-f74d-4463-87dd-91bedf9d7eb1" />

### What were the least and most ordered items? What categories were they in?
```sql
SELECT
  mi.category,
  mi.item_name,
  COUNT(*) AS item_count
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
WHERE mi.item_name IS NOT NULL
GROUP BY mi.category, mi.item_name
ORDER BY item_count ASC;
```
<img width="329" alt="image" src="https://github.com/user-attachments/assets/85382463-2f5a-4eb3-8280-16d78856df68" />
<img width="328" alt="image" src="https://github.com/user-attachments/assets/1b427eb9-0162-45d9-8b56-4164a8afb15e" />

### What were the top 5 orders that spent the most money?
```sql
SELECT 
  od.order_id,
  ROUND(SUM(mi.price), 2) AS total_spent
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id
HAVING SUM(mi.price) IS NOT NULL
ORDER BY total_spent DESC
LIMIT 5;
```
<img width="160" alt="image" src="https://github.com/user-attachments/assets/c1487881-cb71-4071-8ede-4165455e0d3e" />

### View the details of the highest-spending order
```sql
SELECT 
  od.order_id, 
  od.order_date, 
  od.order_time,
  ROUND(SUM(mi.price), 2) AS total_spent
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id, od.order_date, od.order_time
HAVING SUM(mi.price) IS NOT NULL
ORDER BY total_spent DESC
LIMIT 1;
```
<img width="341" alt="image" src="https://github.com/user-attachments/assets/8dd8e104-d605-4a46-9165-a83270a90a43" />

### View the details of the top 5 highest-spending orders
```sql
SELECT 
  od.order_id, 
  od.order_date, 
  od.order_time,
  ROUND(SUM(mi.price), 2) AS total_spent
FROM order_details AS od
LEFT JOIN menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id, od.order_date, od.order_time
HAVING SUM(mi.price) IS NOT NULL
ORDER BY total_spent DESC
LIMIT 5;
```
<img width="344" alt="image" src="https://github.com/user-attachments/assets/f4f527d3-cc14-473b-8761-1edff27e11ab" />
















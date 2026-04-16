{\rtf1\ansi\ansicpg1252\cocoartf2868
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww30040\viewh18260\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- ============================================\
-- BASIC ANALYSIS: PIZZA SALES DATA\
-- ============================================\
\
-- --------------------------------------------\
-- 1. OVERALL BUSINESS METRICS\
-- --------------------------------------------\
\
-- Total number of orders\
SELECT COUNT(order_id) AS total_orders \
FROM orders;\
\
-- Total revenue\
WITH revenue_data AS (\
    SELECT od.quantity * p.price AS revenue\
    FROM order_details od\
    JOIN pizzas p ON od.pizza_id = p.pizza_id\
)\
SELECT ROUND(SUM(revenue), 2) AS total_revenue\
FROM revenue_data;\
\
-- --------------------------------------------\
-- 2. PRODUCT ANALYSIS\
-- --------------------------------------------\
\
-- Highest priced pizza\
SELECT p.price, t.name\
FROM pizzas p\
JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id\
ORDER BY p.price DESC\
LIMIT 1;\
\
-- Most common pizza size\
SELECT p.size, COUNT(o.order_details_id) AS order_count\
FROM pizzas p\
JOIN order_details o ON p.pizza_id = o.pizza_id\
GROUP BY p.size\
ORDER BY order_count DESC\
LIMIT 1;\
\
-- Top 5 most ordered pizzas\
SELECT pt.name, SUM(o.quantity) AS quantity\
FROM pizzas p\
JOIN order_details o ON o.pizza_id = p.pizza_id\
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id\
GROUP BY pt.name\
ORDER BY quantity DESC\
LIMIT 5;\
\
-- Least performing pizzas\
SELECT pt.name, SUM(od.quantity) AS total_orders\
FROM order_details od\
JOIN pizzas p ON od.pizza_id = p.pizza_id\
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id\
GROUP BY pt.name\
ORDER BY total_orders ASC\
LIMIT 5;\
\
-- --------------------------------------------\
-- 3. CATEGORY ANALYSIS\
-- --------------------------------------------\
\
-- Quantity by category\
SELECT pt.category, SUM(o.quantity) AS quantity\
FROM order_details o\
JOIN pizzas p ON o.pizza_id = p.pizza_id\
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id\
GROUP BY pt.category\
ORDER BY quantity DESC;\
\
-- Category distribution\
SELECT category, COUNT(name) AS total_pizzas\
FROM pizza_types\
GROUP BY category;\
\
-- --------------------------------------------\
-- 4. TIME-BASED ANALYSIS\
-- --------------------------------------------\
\
-- Orders by hour\
SELECT \
    HOUR(order_time) AS hour,\
    COUNT(*) AS order_count\
FROM orders\
GROUP BY hour\
ORDER BY hour;\
\
-- Average pizzas ordered per day\
SELECT ROUND(AVG(quantity), 0) AS avg_daily_orders\
FROM (\
    SELECT o.order_date, SUM(od.quantity) AS quantity\
    FROM orders o\
    JOIN order_details od ON o.order_id = od.order_id\
    GROUP BY o.order_date\
) avg_quantity;\
\
-- --------------------------------------------\
-- 5. REVENUE ANALYSIS\
-- --------------------------------------------\
\
-- Top 3 pizzas by revenue\
SELECT \
    pt.name,\
    SUM(od.quantity * p.price) AS revenue\
FROM order_details od\
JOIN pizzas p ON p.pizza_id = od.pizza_id\
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id\
GROUP BY pt.name\
ORDER BY revenue DESC\
LIMIT 3;\
\
-- Revenue contribution by category\
SELECT \
    pt.category,\
    ROUND(SUM(od.quantity * p.price) * 100 / \
          SUM(SUM(od.quantity * p.price)) OVER (), 2) AS revenue_percentage\
FROM order_details od\
JOIN pizzas p ON od.pizza_id = p.pizza_id\
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id\
GROUP BY pt.category;\
\
-- --------------------------------------------\
-- 6. TREND ANALYSIS\
-- --------------------------------------------\
\
-- Cumulative revenue over time\
WITH daily_sales AS (\
    SELECT \
        o.order_date,\
        SUM(od.quantity * p.price) AS revenue\
    FROM orders o\
    JOIN order_details od ON o.order_id = od.order_id\
    JOIN pizzas p ON p.pizza_id = od.pizza_id\
    GROUP BY o.order_date\
)\
SELECT \
    order_date,\
    SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue\
FROM daily_sales;\
\
-- --------------------------------------------\
-- 7. ADVANCED (CATEGORY-WISE TOP PRODUCTS)\
-- --------------------------------------------\
\
WITH sales AS (\
    SELECT \
        pt.category,\
        pt.name,\
        SUM(od.quantity * p.price) AS revenue\
    FROM order_details od\
    JOIN pizzas p ON od.pizza_id = p.pizza_id\
    JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id\
    GROUP BY pt.category, pt.name\
),\
ranked AS (\
    SELECT *,\
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk\
    FROM sales\
)\
SELECT *\
FROM ranked\
WHERE rnk <= 3;}
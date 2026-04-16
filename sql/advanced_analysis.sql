-- Which day brings most revenue/orders?
SELECT 
    DAYNAME(order_date) AS day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY day
ORDER BY total_orders DESC;

-- Average Order Value (AOV)
SELECT 
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS avg_order_value
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Top Revenue Day
SELECT 
    o.order_date,
    SUM(od.quantity * p.price) AS revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.order_date
ORDER BY revenue DESC
LIMIT 1;

-- Least Performing Pizzas
SELECT 
    pt.name,
    SUM(od.quantity) AS total_orders
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY total_orders ASC
LIMIT 5;

-- Contribution of Top 20% Products
WITH sales AS (
    SELECT 
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pt.name
),
ranked AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY revenue DESC) AS bucket
    FROM sales
)
SELECT *
FROM ranked
WHERE bucket = 1;
-- How did each region perform month by month on completed orders?
-- Join choice: INNER JOIN, because every order has a matching customer (that is where the region comes from), and orders with no customer would have no region to group by.
-- DISTINCT is needed because one customer can place several orders in the same month, so COUNT(*) would count orders, not people.
SELECT c.region,
       o.order_month,
       COUNT(*) AS number_of_orders,
       COUNT(DISTINCT o.customer_id) AS number_of_customers,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS average_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region, o.order_month;

-- Corrected D1: which regions earned more than 80000 in completed revenue?
SELECT c.region,
       SUM(o.amount) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY revenue DESC;

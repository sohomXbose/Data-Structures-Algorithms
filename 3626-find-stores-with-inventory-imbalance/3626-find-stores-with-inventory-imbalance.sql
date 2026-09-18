# Write your MySQL query statement below
WITH ranked AS (SELECT i.*, ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY price DESC) AS expensive_rank, ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY price ASC) AS cheap_rank, COUNT(*) OVER (PARTITION BY store_id) AS product_count
FROM inventory i)
SELECT s.store_id, s.store_name, s.location, MAX(CASE WHEN r.expensive_rank=1 THEN r.product_name END) AS most_exp_product, MAX(CASE WHEN r.cheap_rank=1 THEN r.product_name END) AS cheapest_product, ROUND(MAX(CASE WHEN r.cheap_rank=1 THEN r.quantity END)/MAX(CASE WHEN r.expensive_rank=1 THEN r.quantity END), 2) AS imbalance_ratio
FROM stores s
JOIN ranked r ON s.store_id=r.store_id
WHERE r.product_count>=3
GROUP BY s.store_id, s.store_name, s.location
HAVING MAX(CASE WHEN r.expensive_rank=1 THEN r.quantity END)<MAX(CASE WHEN r.cheap_rank=1 THEN r.quantity END)
ORDER BY imbalance_ratio DESC, s.store_name ASC
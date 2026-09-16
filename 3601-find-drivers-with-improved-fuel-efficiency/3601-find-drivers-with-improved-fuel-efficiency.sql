# Write your MySQL query statement below
SELECT d.driver_id, d.driver_name, ROUND(AVG(CASE WHEN EXTRACT(MONTH FROM t.trip_date) BETWEEN 1 AND 6 THEN t.distance_km/t.fuel_consumed END), 2) AS first_half_avg, ROUND(AVG(CASE WHEN EXTRACT(MONTH FROM t.trip_date) BETWEEN 7 AND 12 THEN t.distance_km/t.fuel_consumed END), 2) AS second_half_avg, ROUND( AVG(CASE WHEN EXTRACT(MONTH FROM t.trip_date) BETWEEN 7 AND 12 THEN t.distance_km/t.fuel_consumed END)-AVG(CASE WHEN EXTRACT(MONTH FROM t.trip_date) BETWEEN 1 AND 6 THEN t.distance_km/t.fuel_consumed END), 2) AS efficiency_improvement
FROM drivers d
JOIN trips t ON d.driver_id = t.driver_id
GROUP BY d.driver_id, d.driver_name
HAVING COUNT(CASE WHEN EXTRACT(MONTH FROM t.trip_date) BETWEEN 1 AND 6 THEN 1 END)>0 AND COUNT(CASE WHEN EXTRACT(MONTH FROM t.trip_date) BETWEEN 7 AND 12 THEN 1 END)>0 AND second_half_avg>first_half_avg
ORDER BY efficiency_improvement DESC, driver_name ASC
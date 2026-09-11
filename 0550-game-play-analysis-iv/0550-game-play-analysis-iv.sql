# Write your MySQL query statement below
SELECT ROUND(COUNT(DISTINCT a.player_id) / COUNT(DISTINCT f.player_id), 2) AS fraction
FROM Activity f
LEFT JOIN Activity a ON f.player_id = a.player_id AND a.event_date = DATE_ADD(f.event_date, INTERVAL 1 DAY) AND f.event_date = (SELECT MIN(event_date)
FROM Activity
WHERE player_id = f.player_id)
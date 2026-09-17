# Write your MySQL query statement below
WITH weekly_meetings AS (SELECT employee_id, YEARWEEK(meeting_date, 1) AS week, SUM(duration_hours) AS total_hours
FROM meetings
GROUP BY employee_id, YEARWEEK(meeting_date, 1)),
heavy_weeks AS (SELECT employee_id, COUNT(*) AS meeting_heavy_weeks
FROM weekly_meetings
WHERE total_hours>20
GROUP BY employee_id)
SELECT e.employee_id, e.employee_name, e.department, h.meeting_heavy_weeks
FROM employees e
JOIN heavy_weeks h ON e.employee_id=h.employee_id
WHERE h.meeting_heavy_weeks>=2
ORDER BY h.meeting_heavy_weeks DESC, e.employee_name ASC
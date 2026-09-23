# Write your MySQL query statement below
WITH RECURSIVE hierarchy AS (SELECT employee_id, employee_name, manager_id, salary, 1 AS level, employee_id AS root_manager
FROM Employees
WHERE manager_id IS NULL
UNION ALL
SELECT e.employee_id, e.employee_name, e.manager_id, e.salary, h.level + 1, h.root_manager
FROM Employees e
JOIN hierarchy h ON e.manager_id=h.employee_id),
ancestors AS (SELECT e.employee_id AS manager_id, e.employee_id AS employee_id
FROM Employees e
UNION ALL
SELECT a.manager_id, e.employee_id
FROM ancestors a
JOIN Employees e ON e.manager_id=a.employee_id)
SELECT h.employee_id, h.employee_name, h.level, COUNT(a.employee_id)-1 AS team_size, SUM(e.salary) AS budget
FROM hierarchy h
JOIN ancestors a ON a.manager_id=h.employee_id
JOIN Employees e ON e.employee_id=a.employee_id
GROUP BY h.employee_id, h.employee_name, h.level
ORDER BY h.level ASC, budget DESC, h.employee_name ASC
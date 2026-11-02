# Write your MySQL query statement below
UPDATE Salary
SET Sex=CASE
WHEN sex='m' THEN'f'
WHEN sex='f' THEN'm'
END;
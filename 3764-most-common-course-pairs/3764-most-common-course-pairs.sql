# Write your MySQL query statement below
WITH top_students AS (SELECT user_id
FROM course_completions
GROUP BY user_id
HAVING COUNT(*)>=5 AND AVG(course_rating)>=4),
course_sequence AS (SELECT user_id, course_name, LAG(course_name) OVER (PARTITION BY user_id ORDER BY completion_date) AS first_course
FROM course_completions
WHERE user_id IN (SELECT user_id FROM top_students))
SELECT first_course, course_name AS second_course, COUNT(*) AS transition_count
FROM course_sequence
WHERE first_course IS NOT NULL
GROUP BY first_course, course_name
ORDER BY transition_count DESC, first_course ASC, second_course ASC
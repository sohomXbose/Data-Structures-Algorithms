# Write your MySQL query statement below
SELECT p.patient_id, p.patient_name, p.age, DATEDIFF(MIN(ct2.test_date), fp.first_positive) AS recovery_time
FROM patients p
JOIN (SELECT patient_id, MIN(test_date) AS first_positive
FROM covid_tests
WHERE result='Positive'
GROUP BY patient_id) fp ON p.patient_id=fp.patient_id
JOIN covid_tests ct2 ON p.patient_id=ct2.patient_id AND ct2.result='Negative' AND ct2.test_date>fp.first_positive
GROUP BY p.patient_id, p.patient_name, p.age, fp.first_positive
ORDER BY recovery_time ASC, p.patient_name ASC
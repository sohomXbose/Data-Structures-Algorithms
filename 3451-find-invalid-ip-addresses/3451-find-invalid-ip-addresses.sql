# Write your MySQL query statement below
SELECT ip, COUNT(*) AS invalid_count
FROM logs
WHERE LENGTH(ip)-LENGTH(REPLACE(ip, '.', ''))<>3 OR ip REGEXP '(^|\\.)0[0-9]' OR EXISTS (SELECT 1
FROM JSON_TABLE(CONCAT('["', REPLACE(ip, '.', '","'), '"]'), '$[*]' COLUMNS (octet VARCHAR(10) PATH '$')) AS t
WHERE CAST(t.octet AS UNSIGNED)>255)
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC
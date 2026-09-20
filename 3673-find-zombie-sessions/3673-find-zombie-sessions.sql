# Write your MySQL query statement below
SELECT
    session_id,
    user_id,
    TIMESTAMPDIFF(
        MINUTE,
        MIN(event_timestamp),
        MAX(event_timestamp)
    ) AS session_duration_minutes,
    SUM(event_type = 'scroll') AS scroll_count
FROM app_events
GROUP BY session_id, user_id
HAVING
    session_duration_minutes > 30
    AND scroll_count >= 5
    AND SUM(event_type = 'click') / scroll_count < 0.20
    AND SUM(event_type = 'purchase') = 0
ORDER BY
    scroll_count DESC,
    session_id ASC;
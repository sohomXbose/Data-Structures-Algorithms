# Write your MySQL query statement below
WITH daily AS (
    SELECT
        user_id,
        action_date,
        MAX(action) AS action
    FROM activity
    GROUP BY user_id, action_date
    HAVING COUNT(*) = 1
),

numbered AS (
    SELECT
        user_id,
        action_date,
        action,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, action
            ORDER BY action_date
        ) AS rn
    FROM daily
),

grouped AS (
    SELECT
        user_id,
        action,
        action_date,
        DATE_SUB(action_date, INTERVAL rn DAY) AS grp
    FROM numbered
),

streaks AS (
    SELECT
        user_id,
        action,
        MIN(action_date) AS start_date,
        MAX(action_date) AS end_date,
        COUNT(*) AS streak_length
    FROM grouped
    GROUP BY user_id, action, grp
),

ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY streak_length DESC, start_date
        ) AS rnk
    FROM streaks
)

SELECT
    user_id,
    action,
    streak_length,
    start_date,
    end_date
FROM ranked
WHERE rnk = 1
  AND streak_length >= 5
ORDER BY streak_length DESC, user_id ASC;
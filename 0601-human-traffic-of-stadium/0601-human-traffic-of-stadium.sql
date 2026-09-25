# Write your MySQL query statement below
WITH t AS (
    SELECT
        id,
        visit_date,
        people,
        LAG(id, 2) OVER (ORDER BY id) AS prev2_id,
        LAG(id, 1) OVER (ORDER BY id) AS prev_id,
        LAG(people, 2) OVER (ORDER BY id) AS prev2_people,
        LAG(people, 1) OVER (ORDER BY id) AS prev_people,
        LEAD(id, 1) OVER (ORDER BY id) AS next_id,
        LEAD(id, 2) OVER (ORDER BY id) AS next2_id,
        LEAD(people, 1) OVER (ORDER BY id) AS next_people,
        LEAD(people, 2) OVER (ORDER BY id) AS next2_people
    FROM Stadium
)

SELECT id, visit_date, people
FROM t
WHERE people >= 100
AND (
    -- Current row is the FIRST of a valid group
    (
        next_id = id + 1
        AND next2_id = id + 2
        AND next_people >= 100
        AND next2_people >= 100
    )

    OR

    -- Current row is the MIDDLE of a valid group
    (
        prev_id = id - 1
        AND next_id = id + 1
        AND prev_people >= 100
        AND next_people >= 100
    )

    OR

    -- Current row is the LAST of a valid group
    (
        prev_id = id - 1
        AND prev2_id = id - 2
        AND prev_people >= 100
        AND prev2_people >= 100
    )
)
ORDER BY visit_date;
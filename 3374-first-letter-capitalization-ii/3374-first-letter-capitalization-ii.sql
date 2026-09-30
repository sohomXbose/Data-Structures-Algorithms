# Write your MySQL query statement below
WITH RECURSIVE Words AS (
    SELECT
        content_id,
        content_text,
        SUBSTRING_INDEX(content_text, ' ', 1) AS word,
        SUBSTRING(
            content_text,
            LENGTH(SUBSTRING_INDEX(content_text, ' ', 1)) + 2
        ) AS remaining_text,
        1 AS token_index
    FROM user_content

    UNION ALL

    SELECT
        content_id,
        content_text,
        SUBSTRING_INDEX(remaining_text, ' ', 1) AS word,
        SUBSTRING(
            remaining_text,
            LENGTH(SUBSTRING_INDEX(remaining_text, ' ', 1)) + 2
        ) AS remaining_text,
        token_index + 1
    FROM Words
    WHERE remaining_text <> ''
),

Parts AS (
    SELECT
        content_id,
        token_index,
        word,
        SUBSTRING_INDEX(word, '-', 1) AS part,
        SUBSTRING(
            word,
            LENGTH(SUBSTRING_INDEX(word, '-', 1)) + 2
        ) AS remaining_part,
        1 AS part_index
    FROM Words
    WHERE word REGEXP '^[A-Za-z]+(-[A-Za-z]+)+$'

    UNION ALL

    SELECT
        content_id,
        token_index,
        word,
        SUBSTRING_INDEX(remaining_part, '-', 1) AS part,
        SUBSTRING(
            remaining_part,
            LENGTH(SUBSTRING_INDEX(remaining_part, '-', 1)) + 2
        ) AS remaining_part,
        part_index + 1
    FROM Parts
    WHERE remaining_part <> ''
),

Hyphenated AS (
    SELECT
        content_id,
        token_index,
        GROUP_CONCAT(
            CONCAT(
                UPPER(LEFT(part, 1)),
                LOWER(SUBSTRING(part, 2))
            )
            ORDER BY part_index
            SEPARATOR '-'
        ) AS converted_word
    FROM Parts
    GROUP BY content_id, token_index
),

Converted AS (
    SELECT
        w.content_id,
        w.token_index,

        CASE
            -- Starts with a non-English letter:
            -- leave the whole word unchanged
            WHEN w.word NOT REGEXP '^[A-Za-z]'
                THEN w.word

            -- Valid hyphenated word
            WHEN w.word REGEXP '^[A-Za-z]+(-[A-Za-z]+)+$'
                THEN h.converted_word

            -- Normal word
            ELSE CONCAT(
                UPPER(LEFT(w.word, 1)),
                LOWER(SUBSTRING(w.word, 2))
            )
        END AS converted_word

    FROM Words w
    LEFT JOIN Hyphenated h
        ON w.content_id = h.content_id
        AND w.token_index = h.token_index
)

SELECT
    u.content_id,
    u.content_text AS original_text,
    GROUP_CONCAT(
        c.converted_word
        ORDER BY c.token_index
        SEPARATOR ' '
    ) AS converted_text
FROM user_content u
JOIN Converted c
    ON u.content_id = c.content_id
GROUP BY
    u.content_id,
    u.content_text
ORDER BY
    u.content_id;
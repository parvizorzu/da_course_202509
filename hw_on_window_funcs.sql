-- Задача 1. Window Functions

WITH base AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        EXTRACT(YEAR FROM i.invoice_date) AS year,
        EXTRACT(YEAR FROM i.invoice_date) * 100
            + EXTRACT(MONTH FROM i.invoice_date) AS monthkey,
        SUM(i.total) AS total
    FROM invoice i
    JOIN customer c ON c.customer_id = i.customer_id
    GROUP BY
        c.customer_id,
        full_name,
        year,
        monthkey
)
SELECT
    customer_id,
    full_name,
    monthkey,
    total,
    total / SUM(total) OVER (PARTITION BY monthkey) AS month_share,
    SUM(total) OVER (
    PARTITION BY customer_id, year
    ORDER BY monthkey
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_total_year,

AVG(total) OVER (
    PARTITION BY customer_id
    ORDER BY monthkey
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS moving_avg_3,
total - LAG(total) OVER (
        PARTITION BY customer_id
        ORDER BY monthkey
    ) AS diff_from_prev
FROM base
ORDER BY customer_id, monthkey;



-- Задача 2. Топ 3 продаваемых альбома

WITH album_sales AS (
    SELECT
        a.album_id,
        a.title AS album_name,
        ar.name AS artist_name,
        EXTRACT(YEAR FROM i.invoice_date) AS year,
        SUM(il.quantity) AS tracks_sold
    FROM album a
    JOIN artist ar ON a.artist_id = ar.artist_id
    JOIN track t ON t.album_id = a.album_id
    JOIN invoice_line il ON il.track_id = t.track_id
    JOIN invoice i ON i.invoice_id = il.invoice_id
    GROUP BY a.album_id, album_name, artist_name, year
)
SELECT
    year,
    album_name,
    artist_name,
    tracks_sold
FROM (
    SELECT *,
        RANK() OVER (PARTITION BY year ORDER BY tracks_sold DESC) AS rnk
    FROM album_sales
) ranked
WHERE rnk <= 3
ORDER BY year, rnk;


-- Задача 3. клиенты на сотрудника и процент

SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    COUNT(c.customer_id) AS num_customers
FROM employee e
LEFT JOIN customer c ON c.support_rep_id = e.employee_id
GROUP BY e.employee_id, full_name
ORDER BY num_customers DESC;

WITH customer_counts AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        COUNT(c.customer_id) AS num_customers
    FROM employee e
    LEFT JOIN customer c ON c.support_rep_id = e.employee_id
    GROUP BY e.employee_id, full_name
),
total_customers AS (
    SELECT COUNT(*) AS total FROM customer
)
SELECT
    cc.employee_id,
    cc.full_name,
    cc.num_customers,
    (cc.num_customers::decimal / t.total) * 100 AS percent_of_total
FROM customer_counts cc
CROSS JOIN total_customers t
ORDER BY percent_of_total DESC;



-- Задача 4. первая и последняя покупка

SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    MIN(i.invoice_date) AS first_purchase,
    MAX(i.invoice_date) AS last_purchase,
    EXTRACT(YEAR FROM AGE(MAX(i.invoice_date), MIN(i.invoice_date))) AS years_between
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY c.customer_id, full_name
ORDER BY customer_id;

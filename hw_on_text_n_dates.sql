-- 1. Самая первая и самая последняя покупка
SELECT
    MIN(invoice_date) AS first_purchase,
    MAX(invoice_date) AS last_purchase
FROM invoice;

-- 2. Средний чек для покупок из США
SELECT
    AVG(total) AS avg_check_usa
FROM invoice
WHERE billing_country = 'USA';

-- 3. Города с более чем одним клиентом
SELECT
    city,
    COUNT(*) AS customers_cnt
FROM customer
GROUP BY city
HAVING COUNT(*) > 1;

-- 4. Телефоны без скобок
SELECT
    REPLACE(REPLACE(phone, '(', ''), ')', '') AS clean_phone
FROM customer;

-- 6. Песни, содержащие слово 'run'
SELECT
    name
FROM track
WHERE LOWER(name) LIKE '%run%';

-- 7. Клиенты с почтой gmail
SELECT
    first_name,
    last_name,
    email
FROM customer
WHERE email ILIKE '%@gmail%';

-- 8. Произведение с самым длинным названием
SELECT
    name,
    LENGTH(name) AS name_length
FROM track
ORDER BY LENGTH(name) DESC
LIMIT 1;

-- 9. Сумма продаж за 2021 год по месяцам
SELECT
    EXTRACT(MONTH FROM invoice_date) AS month_id,
    SUM(total) AS sales_sum
FROM invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id
ORDER BY month_id;

-- 10. Сумма продаж за 2021 год по месяцам с названием месяца
SELECT
    EXTRACT(MONTH FROM invoice_date) AS month_id,
    TRIM(TO_CHAR(invoice_date, 'month')) AS month_name,
    SUM(total) AS sales_sum
FROM invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id, month_name
ORDER BY month_id;

-- 11. Три самых возрастных сотрудника
SELECT
    first_name || ' ' || last_name AS full_name,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age_now
FROM employee
ORDER BY birth_date
LIMIT 3;

-- 12. Средний возраст сотрудников через 3 года и 4 месяца
SELECT
    AVG(
        EXTRACT(
            YEAR FROM AGE(
                CURRENT_DATE + INTERVAL '3 years 4 months',
                birth_date
            )
        )
    ) AS avg_age_future
FROM employee;

-- 13. Продажи по годам и странам (сумма > 20)
SELECT
    EXTRACT(YEAR FROM invoice_date) AS sale_year,
    billing_country,
    SUM(total) AS sales_sum
FROM invoice
GROUP BY sale_year, billing_country
HAVING SUM(total) > 20
ORDER BY sale_year ASC, sales_sum DESC;
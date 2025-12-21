/*
Имя Фамилия: Парвиз Орзукул
Описание: Введение в SQL. Базовые SELECT-запросы к таблице track
*/

SELECT name, genre_id
FROM track;

SELECT
    name AS song,
    unit_price AS price,
    composer AS author
FROM track;

SELECT
    name,
    milliseconds / 60000.0 AS duration_minutes
FROM track
ORDER BY duration_minutes DESC;

SELECT name, genre_id
FROM track
LIMIT 15;


SELECT *
FROM track
OFFSET 49;

SELECT name
FROM track
WHERE bytes > 100 * 1048576;

SELECT name, composer
FROM track
WHERE composer <> 'U2'
LIMIT 11 OFFSET 9;
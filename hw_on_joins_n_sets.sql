-- Задача 1

SELECT
    e.EmployeeId AS employee_id,
    e.FirstName || ' ' || e.LastName AS full_name,
    COUNT(c.CustomerId) AS customers_count,
    ROUND(
        COUNT(c.CustomerId) * 100.0 /
        (SELECT COUNT(*) FROM Customer),
        2
    ) AS customers_percent
FROM Employee e
LEFT JOIN Customer c
    ON e.EmployeeId = c.SupportRepId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY customers_count DESC;


-- Задача 2

SELECT DISTINCT
    a.Title AS album_title,
    ar.Name AS artist_name
FROM Album a
JOIN Artist ar
    ON a.ArtistId = ar.ArtistId
JOIN Track t
    ON a.AlbumId = t.AlbumId
LEFT JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
WHERE il.TrackId IS NULL
ORDER BY album_title;

-- Задача 3
SELECT
    e.EmployeeId,
    e.FirstName,
    e.LastName
FROM Employee e
LEFT JOIN Employee sub
    ON e.EmployeeId = sub.ReportsTo
WHERE sub.EmployeeId IS NULL;


-- Задача 4

SELECT
    t.TrackId,
    t.Name
FROM Track t
WHERE t.TrackId IN (
    SELECT il.TrackId
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.BillingCountry = 'USA'

    INTERSECT

    SELECT il.TrackId
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.BillingCountry = 'Canada'
);


-- Задача 5

SELECT
    t.TrackId,
    t.Name
FROM Track t
WHERE t.TrackId IN (
    SELECT il.TrackId
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.BillingCountry = 'Canada'

    EXCEPT

    SELECT il.TrackId
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.BillingCountry = 'USA'
);
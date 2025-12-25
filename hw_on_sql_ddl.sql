-- 1. Подготовка схемы
CREATE SCHEMA IF NOT EXISTS store;

-- Удаляем старые таблицы, чтобы избежать ошибок "already exists" или "duplicate key"
DROP TABLE IF EXISTS store.sales CASCADE;
DROP TABLE IF EXISTS store.products CASCADE;
DROP TABLE IF EXISTS store.customers CASCADE;

-- 2. Создание таблицы клиентов
CREATE TABLE store.customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(260),
    address TEXT
);

-- 3. Заполнение клиентов из Chinook
INSERT INTO store.customers (customer_id, customer_name, email, address)
SELECT 
    customer_id,
    LEFT(first_name || ' ' || last_name, 50), 
    email,
    country || ' ' || COALESCE(state, '') || ' ' || city || ' ' || address
FROM public.customer;

-- 4. Создание и заполнение товаров
CREATE TABLE store.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC NOT NULL
);

INSERT INTO store.products (product_id, product_name, price)
VALUES 
    (1, 'Ноутбук Lenovo Thinkpad', 12000),
    (2, 'Мышь для компьютера, беспроводная', 90),
    (3, 'Подставка для ноутбука', 300),
    (4, 'Шнур электрический для ПК', 160);

-- 5. Создание таблицы продаж
CREATE TABLE store.sales (
    sale_id SERIAL PRIMARY KEY,
    sale_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL REFERENCES store.customers(customer_id),
    product_id INT NOT NULL REFERENCES store.products(product_id),
    quantity INT NOT NULL DEFAULT 1
);

-- 6. Заполнение продаж
INSERT INTO store.sales (customer_id, product_id, quantity)
VALUES 
    (3, 4, 1), (56, 2, 3), (11, 2, 1), (31, 2, 1), (24, 2, 3), 
    (27, 2, 1), (37, 3, 2), (35, 1, 2), (21, 1, 2), (31, 2, 2), 
    (15, 1, 1), (29, 2, 1), (12, 2, 1);

-- 7. Добавление скидки
ALTER TABLE store.sales ADD COLUMN discount NUMERIC DEFAULT 0;
UPDATE store.sales SET discount = 0.2 WHERE product_id = 1;

-- 8. Создание представления
CREATE OR REPLACE VIEW store.v_usa_customers AS
SELECT * FROM store.customers WHERE address LIKE 'USA%';

SELECT * FROM store.v_usa_customers;
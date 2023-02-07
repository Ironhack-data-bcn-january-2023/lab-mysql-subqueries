-- 1
SELECT COUNT(i.film_id) 
FROM sakila.inventory i
JOIN sakila.film f
ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible";

-- 2

SELECT title
FROM sakila.film
WHERE length > (SELECT AVG(length) FROM sakila.film);

-- 3

SELECT 
a.first_name,
a.last_name

FROM sakila.actor a
JOIN sakila.film_actor fa
ON a.actor_id = fa.actor_id
AND fa.film_id in (SELECT film_id FROM sakila.film WHERE title = "Alone Trip");

-- 4

SELECT 
f.film_id,
f.title
FROM sakila.film f
JOIN sakila.film_category fc
ON f.film_id = fc.film_id
JOIN sakila.category c
ON fc.category_id = c.category_id
AND c.name = "Family";

-- 5 
SELECT
first_name,
last_name,
email
FROM sakila.customer cu
JOIN sakila.address a
ON cu.address_id = a.address_id
JOIN sakila.city c
ON a.city_id = c.city_id
JOIN sakila.country cty
ON c.country_id =cty.country_id
AND cty.country = "Canada";

SELECT
first_name,
last_name,
email
FROM sakila.customer
WHERE customer_id in 
(
SELECT customer_id
FROM sakila.customer cu
JOIN sakila.address a
ON cu.address_id = a.address_id
JOIN sakila.city c
ON a.city_id = c.city_id
JOIN sakila.country cty
ON c.country_id =cty.country_id
AND cty.country = "Canada"
);


-- 6 
with prof_author as (
SELECT actor_id, COUNT(film_id) count_films
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY count_films desc
LIMIT 1
)

SELECT f.title 
FROM sakila.film f
JOIN sakila.film_actor a
ON f.film_id = a.film_id
AND a.actor_id = (SELECT actor_id FROM prof_author);

-- 7

with prof_cust as (
SELECT c.customer_id, SUM(p.amount) as sum_prof
FROM sakila.customer c
JOIN sakila.payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY sum_prof desc
LIMIT 1
)

SELECT f.title 
FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
JOIN sakila.rental r
ON i.inventory_id = r.inventory_id
AND r.customer_id = (SELECT customer_id FROM prof_cust);

-- 8

with avg_prof as (
SELECT c.customer_id, SUM(p.amount) as sum_prof
FROM sakila.customer c
JOIN sakila.payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
)

SELECT customer_id, sum_prof
FROM avg_prof
WHERE sum_prof > (SELECT AVG(sum_prof) FROM avg_prof)




SELECT COUNT(inventory_id)
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip'));


SELECT title, rating
FROM film
WHERE rating = 'G' OR rating = 'PG';

SELECT first_name, email
FROM customer
WHERE customer_id IN (SELECT customer_id FROM address WHERE country = 'Canada');

WITH actor_film_counts AS (
  SELECT actor_id, COUNT(actor_id) AS films_acted_in
  FROM film_actor
  GROUP BY actor_id
)
SELECT title
FROM film
WHERE film_id IN (
  SELECT film_id
  FROM film_actor
  WHERE actor_id = (
    SELECT actor_id
    FROM actor_film_counts
    ORDER BY films_acted_in DESC
    LIMIT 1
  )
);


WITH customer_payment_totals AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM payment
  GROUP BY customer_id
)
SELECT customer.first_name, customer.last_name, customer_payment_totals.total_spent
FROM customer
JOIN customer_payment_totals ON customer.customer_id = customer_payment_totals.customer_id
ORDER BY customer_payment_totals.total_spent DESC
LIMIT 1;


WITH customer_payment_totals AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM payment
  GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM customer_payment_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_payment_totals);


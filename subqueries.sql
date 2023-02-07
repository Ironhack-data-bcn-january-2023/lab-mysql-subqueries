-- Query 1
SELECT COUNT(*)
	FROM inventory
	WHERE film_id = 439;
    
-- Query 2
SELECT *
	FROM film
	WHERE length > (SELECT AVG(length) FROM film);

-- Query 3
SELECT first_name, last_name
	FROM actor
		WHERE actor_id IN (
		SELECT actor_id
	FROM film_actor
		WHERE film_id = (
		SELECT film_id
	FROM film
		WHERE title = 'Alone Trip'
  )
);

-- Query 4
SELECT film.film_id, film.title
	FROM film
		JOIN film_category
			ON film.film_id = film_category.film_id
		JOIN category
			ON film_category.category_id = category.category_id
	WHERE category.name = 'Family';

-- Query 5
SELECT customer.first_name, customer.last_name, customer.email
	FROM customer
		JOIN address
			ON customer.address_id = address.address_id
		JOIN city
			ON address.city_id = city.city_id
		JOIN country
			ON city.country_id = country.country_id
	WHERE country.country = 'Canada';
    
-- Query 6

-- First we find who out the most prolific actor/actress is
SELECT first_name, last_name, actor_id
	FROM actor
		WHERE actor_id = (
			SELECT actor_id
				FROM film_actor
		GROUP BY actor_id
		ORDER BY COUNT(film_id) DESC
  LIMIT 1
);

-- Establishing what films Gina Degeneres (id = 107) has starred in
SELECT title, actor_id
	FROM film
		JOIN film_actor
			ON film.film_id = film_actor.film_id
	WHERE film_actor.actor_id = 107;

-- Query 7
SELECT first_name, last_name, SUM(amount) AS total_spent
	FROM customer
		JOIN payment
			ON customer.customer_id = payment.customer_id
		GROUP BY customer.customer_id
		ORDER BY total_spent DESC
	LIMIT 1;

-- Query 8
SELECT customer.first_name, customer.last_name, SUM(amount) AS total_spent
	FROM customer
		JOIN payment
			ON customer.customer_id = payment.customer_id
		GROUP BY customer.customer_id
	HAVING total_spent > (SELECT AVG(amount) FROM payment);

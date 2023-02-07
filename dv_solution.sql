USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system? (id 439)

SELECT count(film.title)
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE title = "Hunchback Impossible";

-- List all films whose length is longer than the average of all the films.

SELECT title
	FROM film
		WHERE length > (SELECT AVG(length) as length FROM film);
        
-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name as name , last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_id IN (SELECT film_id FROM film WHERE title = "Alone Trip");

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films. (cat_id = 8)

SELECT title 
FROM film
JOIN film_category ON film.film_id = film_category.film_id
WHERE category_id IN (SELECT category_id 
FROM category
WHERE name = "Family");

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.



SELECT first_name, last_name, email
	FROM customer
    JOIN address
		ON customer.address_id = address.address_id
    JOIN city
		ON address.city_id = city.city_id
    JOIN country
		ON city.country_id = country.country_id
WHERE country.country = "canada"
;





-- With subqueries

SELECT first_name, last_name, email
	FROM customer
    WHERE address_id IN
		(SELECT address_id
			FROM address
			WHERE city_id IN
				(SELECT city_id
					FROM city
					WHERE country_id IN 
						(SELECT country_id
							FROM country
							WHERE country = "canada"
						)
				)
		)
;


--- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
--- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT title
FROM film
JOIN film_actor
	ON film_actor.film_id = film.film_id
WHERE film_actor.actor_id = 
		(SELECT actor.actor_id
		FROM actor
		JOIN film_actor
			ON film_actor.actor_id = actor.actor_id
		GROUP BY actor.actor_id
		ORDER BY COUNT(film_actor.film_id) DESC
		LIMIT 1
		)
;

-- 7. Films rented by most profitable customer.
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT DISTINCT(title) as title
FROM film
JOIN inventory
	ON inventory.film_id = film.film_id
JOIN rental
	ON rental.inventory_id = inventory.inventory_id
JOIN payment
	ON payment.customer_id = rental.customer_id
WHERE payment.customer_id = 
		(SELECT customer.customer_id
		FROM customer
		JOIN payment
			ON payment.customer_id = customer.customer_id
		GROUP BY customer.customer_id
		ORDER BY SUM(amount) DESC
		LIMIT 1
		)
ORDER BY title
;

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT  customer_id, SUM(amount) as total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > 
		(SELECT avg(total)
		FROM
			(SELECT  SUM(amount) as total
					FROM payment
					GROUP BY customer_id
					ORDER BY total DESC
			) AS client_spending
		)
ORDER BY total_amount_spent DESC
;








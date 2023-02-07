-- SOLUTIONS FILE

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
USE SAKILA;
SELECT *
	FROM film
    JOIN inventory 
    ON film.film_id = inventory.film_id
    WHERE title = "Hunchback Impossible";

SELECT COUNT(inventory_id)
	FROM inventory
	WHERE film_id = (SELECT film_id FROM film where title = "Hunchback Impossible");

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length
	FROM film
    WHERE length > (SELECT AVG(length) from film);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT first_name, last_name, title
	FROM actor
    JOIN film_actor
		ON actor.actor_id = film_actor.actor_id
	JOIN film
		ON film_actor.film_id = film.film_id
	WHERE title = "Alone Trip";

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT category.name, film.title
	FROM category
    JOIN film_category
		ON category.category_id = film_category.category_id
	JOIN film
		ON film_category.film_id = film.film_id
	WHERE category.name = "family";

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT customer.first_name, customer.last_name, customer.email
    FROM customer
    JOIN address
        ON customer.address_id = address.address_id
    JOIN city
        ON address.city_id = city.city_id
    JOIN country
        ON city.country_id = country.country_id
    WHERE country.country = "Canada";



SELECT customer.first_name, customer.last_name, customer.email
FROM customer 
    WHERE customer_id IN 

-- Customer IDs que se corresponden con las address', cities que entran en el Country ID de canada.
(SELECT customer_id
    FROM customer 
        WHERE address_id IN

-- Address ID que se corresponde con las ciudades que se corresponden con el ID de Canada
(SELECT address_id
	FROM address
		WHERE city_id IN

-- City ID's que se corresponden con el ID de Canada
(SELECT city_id
	FROM city
		WHERE country_id IN
        
-- Country ID de Canada
(SELECT country_id
	from country
    where country = "Canada"))));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT title
	FROM film
    JOIN film_actor
		ON film.film_id = film_actor.film_id
	WHERE actor_id = 

-- Actor ID
(SELECT actor_id
	FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1); 

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT film.title
	FROM film
    JOIN inventory
		ON film.film_id = inventory.film_id
	JOIN rental
		ON inventory.inventory_id = rental.inventory_id
	JOIN customer
		ON rental.customer_id = customer.customer_id
	WHERE customer.customer_id = 

(SELECT customer_id
	FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1);

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
SELECT customer_id, SUM(amount) as total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent >
		(SELECT avg(total)
		FROM
			(SELECT SUM(amount) as total
					FROM customer
					JOIN payment
						ON payment.customer_id = customer.customer_id
					GROUP BY customer.customer_id
					ORDER BY total DESC
			) AS client_spending
		)
ORDER BY total_amount_spent DESC
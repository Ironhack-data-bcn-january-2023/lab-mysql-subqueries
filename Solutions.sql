USE sakila;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(i.film_id)
	FROM sakila.inventory as i
	JOIN sakila.film as f
	ON f.film_id = i.film_id
	WHERE f.title = "Hunchback Impossible";

-- List all films whose length is longer than the average of all the films.
SELECT title, length
	FROM film
    WHERE length > (SELECT AVG(length) FROM film);


-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
	FROM sakila.actor as a
    JOIN sakila.film_actor as b
		ON b.actor_id = a.actor_id
		WHERE b.film_id = "17";

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT film_id, title
	FROM sakila.film as e
    WHERE film_id IN (
		SELECT film_id
			FROM sakila.film_category as c
			JOIN sakila.category as d
			ON c.category_id = d.category_id
			WHERE c.category_id = "8") ;

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will 
-- help you get the relevant information.

-- JOIN
SELECT first_name, last_name, email
	FROM sakila.customer as f
    JOIN sakila.address as g
		ON g.address_id = f.address_id
			JOIN sakila.city as h
				ON h.city_id = g.city_id
					JOIN sakila.country as i
						ON i.country_id = h.country_id
                        WHERE country = "Canada";
-- SUBQUERY                        
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id IN (
            SELECT country_id
            FROM country
            WHERE country = "Canada"
        )
    )
);

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT actor_id
	FROM film_actor
        GROUP BY actor_id
        ORDER BY count(film_id) DESC
        LIMIT 1;
	
SELECT title
	FROM film
    JOIN film_actor
		ON film.film_id = film_actor.film_id
	WHERE actor_id =(SELECT actor_id
		FROM film_actor
        GROUP BY actor_id
        ORDER BY count(film_id) DESC
        LIMIT 1)
        ;

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most 
-- profitable customer ie the customer that has made the largest sum of payments
SELECT distinct title
	FROM film
    JOIN inventory
		ON inventory.film_id=film.film_id
	JOIN rental
		ON inventory.inventory_id=rental.inventory_id
	WHERE rental.customer_id = (SELECT customer_id
	FROM payment
	GROUP BY customer_id
	ORDER BY sum(amount) DESC
    LIMIT 1)
    ;

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, sum(amount) as total_amount_spent
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
ORDER BY total_amount_spent DESC;

    
    
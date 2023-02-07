use sakila;

--  1.How many copies of the film _Hunchback Impossible_ exist in the inventory system?

SELECT COUNT(inventory_id)
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.

SELECT title
FROM film
WHERE length > (SELECT AVG(length) FROM film);


-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (SELECT film_actor.actor_id 
                        FROM film_actor
                        WHERE film_actor.film_id = (SELECT film_id FROM film WHERE title = "Alone Trip"));


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title
FROM film
WHERE rating = 'G' OR rating = 'PG';


-- 5 Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email
FROM customer
WHERE country_id = 20;

SELECT first_name, last_name, email
    FROM customer
        JOIN address
            ON customer.address_id = address.address_id
		JOIN city
            ON address.city_id = city.city_id
		JOIN country
			ON city.country_id = country.country_id
		WHERE country.country = "Canada";
        
SELECT first_name, last_name, email
    FROM customer
    WHERE address_id IN (SELECT address_id FROM address WHERE city_id
    IN (SELECT city_id FROM city WHERE country_id 
    IN (SELECT country_id FROM country WHERE country.country = "Canada")));
    

-- 6. Which are films starred by the most prolific actor?

WITH most_prolific AS (
  SELECT actor_id, COUNT(film_id) AS film_count
  FROM film_actor
  GROUP BY actor_id
  ORDER BY film_count DESC
  LIMIT 1
)
SELECT title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (SELECT actor_id FROM most_prolific);



-- 7.  Films rented by most profitable customer 


WITH most_profitable AS (
  SELECT customer_id, SUM(amount) AS profit
  FROM payment
  GROUP BY customer_id
  ORDER BY profit DESC
  LIMIT 1
)
SELECT title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (SELECT customer_id FROM most_profitable);



-- 8. . Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount`

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount_spent) FROM
  (SELECT customer_id, SUM(amount) AS total_amount_spent
   FROM payment
   GROUP BY customer_id) AS subquery);


   

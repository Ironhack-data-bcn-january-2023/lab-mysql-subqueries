USE sakila;
-- 1. COUNTING "Hunchback Impossible"
SELECT COUNT(inventory.film_id), film.title
	FROM inventory
       JOIN film
		ON inventory.film_id = film.film_id
        WHERE film.title = "Hunchback Impossible";
-- 2. List all films whose length is longer than the average of all the films

SELECT length, title
	FROM film 
    WHERE length > (SELECT AVG(length)
	FROM film);
    
-- 3. Use subqueries to display all actors who appear in the film Alone Trip
SELECT first_name, last_name, actor.actor_id, film.title
	FROM actor
	JOIN film_actor
		ON actor.actor_id = film_actor.actor_id
	JOIN film
		ON film_actor.film_id = film.film_id
	WHERE film.title = "Alone Trip";
        
-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.        
SELECT film.title, category.name
	FROM category
    JOIN film_category
		ON category.category_id = film_category.category_id
	JOIN film
		ON film_category.film_id = film.film_id
	WHERE category.name = "family";
    
-- 5.Get name and email from customers from Canada using subqueries. 
SELECT email, first_name, last_name 
FROM customer WHERE address_id IN
(SELECT address_id FROM address WHERE city_id IN
(SELECT city_id FROM city WHERE country_id IN
(SELECT country_id FROM country WHERE country= "Canada")));

-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT customer.email, customer.first_name, customer.last_name, country
	FROM country
    JOIN city
		ON country.country_id = city.country_id
	JOIN address
		ON city.city_id = address.city_id
	JOIN customer
		ON address.address_id = customer.address_id
	WHERE country = "Canada";
    
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT title 
	FROM film
    JOIN film_actor
    ON film.film_id=film_actor.film_id
    WHERE actor_id =(SELECT actor_id 
	FROM film_actor
    GROUP BY actor_id
    ORDER BY count(film_id)DESC
    LIMIT 1);
-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT title FROM film 
	JOIN inventory
		ON film.film_id = inventory.film_id
	JOIN rental
		ON inventory.inventory_id= rental.inventory_id
	JOIN customer 
		ON rental.customer_id= customer.customer_id
       		WHERE rental.customer_id = (SELECT customer_id
  			FROM payment
  			GROUP BY customer_id
  			ORDER BY sum(amount) DESC
  				LIMIT 1);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT customer_id, sumn FROM (SELECT customer_id, sum(amount) AS sumn FROM payment GROUP BY customer_id) as outer_query
WHERE sumn>
(SELECT AVG(asset_sums)	FROM(SELECT customer_id, SUM(amount) AS asset_sums FROM payment GROUP BY customer_id) as inner_query)
group by customer_id
order by sumn desc ;

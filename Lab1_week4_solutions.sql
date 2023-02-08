USE sakila;

-- 1) How many copies of the film HUNCHBACK IMPOSSIBLE exist in the inventory system?
SELECT count(inventory_id), film_id FROM inventory
	WHERE film_id = "439";
 
-- 2) List all films whose length is longer than the average of all the films? 
SELECT title FROM film
	WHERE length > (SELECT AVG(length) FROM film);
    
-- 3) Use subqueries to display all actors who appear in the film ALONE TRIP? 
SELECT first_name, last_name 
	FROM actor
	WHERE actor_id IN
					(SELECT actor_id FROM film_actor
						WHERE film_id = 
										(SELECT film_id FROM FILM
											WHERE title = 'ALONE TRIP'));
										
-- 4) Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films?
select film.title
	from film
    join film_category
		on film.film_id = film_category.film_id
	join category
		on film_category.category_id = category.category_id
	where category.name = 'family';

-- 5) Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information?

-- USING JOIN:
SELECT last_name, email
	FROM customer
    JOIN address
		ON customer.address_id = address.address_id
	JOIN city
		ON address.city_id = city.city_id
	JOIN country
		ON city.country_id = country.country_id
	WHERE country.country = "Canada";

-- USING SUBQUIERY:
SELECT last_name, email FROM customer
	WHERE address_id IN
					(SELECT address_id FROM address
					WHERE city_id IN
									(SELECT city_id FROM city
									WHERE country_id =
														(SELECT country_id FROM country
														WHERE country.country = "Canada")));

-- 6) Which are films starred by the most prolific actor? Most prolific actor is defined as the 
-- actor that has acted in the most number of films. First you will have to find the most prolific 
-- actor and then use that actor_id to find the different films that he/she starred?
SELECT actor_id FROM film_actor;
                                
-- need -> MAX(COUNT(film_id))

-- 7) Films rented by most profitable customer. You can use the customer table and payment table to
-- find the most profitable customer ie the customer that has made the largest sum of payments?





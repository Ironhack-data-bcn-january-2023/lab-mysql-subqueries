-- Lab SQL SubQueries
-- Andrés Castro
USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, COUNT(inventory.inventory_id) as ammount
	FROM inventory
    LEFT JOIN film ON inventory.film_id = film.film_id
    WHERE title = "Hunchback Impossible";
    
-- 2. List all films whose length is longer than the average of all the films.

SELECT title
	FROM film
    WHERE length > (SELECT AVG(length) AS avg_lenght
						FROM film)
    ;
    
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.


SELECT first_name, last_name
	FROM 	(SELECT first_name, last_name, film.title as movie_title
				FROM actor
				JOIN film_actor
					ON actor.actor_id = film_actor.actor_id
				JOIN film
					ON film_actor.film_id = film.film_id) as actors_films
	WHERE movie_title = "Alone Trip"
    ;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films










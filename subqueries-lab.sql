USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(film_id) FROM sakila.inventory 
WHERE film_id in (SELECT film_id from sakila.film WHERE title = 'Hunchback Impossible' ); 

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length 
	FROM film
    WHERE length > (SELECT avg(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name FROM actor
	WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = 
    (SELECT film_id FROM film WHERE title = 'Alone Trip'));
    
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title FROM film
	WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id = 
    (SELECT category_id FROM category WHERE name = 'Family'));
    
-- 5. get name and email from customers from Canada 
SELECT * from address;





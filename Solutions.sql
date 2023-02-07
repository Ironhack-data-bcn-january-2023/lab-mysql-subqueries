USE sakila;
SELECT count(inventory_id)
	FROM inventory
    JOIN film
		ON film.film_id=inventory.film_id
        WHERE film.title="Hunchback Impossible"   
;

SELECT title
	FROM film
    WHERE film.length > (select avg(length) from film)
;

SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
    SELECT film_actor.actor_id
    FROM film_actor
    WHERE film_actor.film_id = (
        SELECT film.film_id
        FROM film
        WHERE film.title = "Alone Trip"
    )
);

SELECT title
	FROM film
    JOIN film_category AS cat
		ON film.film_id=cat.film_id
	JOIN category
		ON category.category_id=cat.category_id
	WHERE category.name="Family"   
;

SELECT first_name, last_name
	FROM customer
    JOIN address
		ON address.address_id=customer.address_id
	JOIN city
		ON address.city_id=city.city_id
	JOIN country
		ON country.country_id=city.country_id
	WHERE country.country="Canada"
    ;
SELECT first_name, last_name
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

SELECT actor_id, count(film_id)
	FROM film_actor
	GROUP BY actor_id
	ORDER BY count(film_id) DESC
    LIMIT 1;
	
SELECT title
	FROM film
    JOIN film_actor
		ON film.film_id=film_actor.film_id
	WHERE actor_id=107
    ;

SELECT customer_id, sum(amount)
	FROM payment
	GROUP BY customer_id
	ORDER BY sum(amount) DESC
    LIMIT 1;

SELECT distinct title
	FROM film
    JOIN inventory
		ON inventory.film_id=film.film_id
	JOIN rental
		ON inventory.inventory_id=rental.inventory_id
	WHERE rental.customer_id=526
    ;

SELECT  customer_id, SUM(amount) as total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent >
		(SELECT avg(total)
		FROM
			(SELECT  SUM(amount) as total
					FROM customer
					JOIN payment
						ON payment.customer_id = customer.customer_id
					GROUP BY customer.customer_id
					ORDER BY total DESC
			) AS client_spending
		)
ORDER BY total_amount_spent DESC
;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select COUNT(film_id)
    from inventory
        where film_id in (select film_id
    from film
    where title = "Hunchback Impossible");   

-- 2 List all films whose length is longer than the average of all the films.
select title, lenght
	from film
    where length > (select avg(lenght) from film);

-- 3 Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
	from actor
    where actor_id in (select actor_id
		-- table with actor id and title id.
        from film_actor
		where film_id in (select film_id
			-- table with the name of the film.
            from film
			where title = "Alone Trip"));

-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title
	from film -- searching for table film_id where have ids in common of 2 tables.
    where film_id in (select film_id
		from film_category  -- select the last table where the category is label.
		where category_id in (select category_id
			from category
			where name = "Family"));

-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins.
    -- Note that to create a join, you will have to identify the correct tables with their primary 
    -- keys and foreign keys, that will help you get the relevant information.
-- 1. joins => este no me salio :o diferente respuesta.
 select first_name, last_name, email as name
	from customer
join  address_id
	on customer.address_id = address.address_id
join city
    on address.city_id = city.city_id
join country
	on city.country_id = country.country_id
		where country = "canada";
-- 2. subqueries. => este si me salio.
select first_name, last_name, email 
	from customer
    where address_id in (select address_id
		from address
        where city_id in (select city_id
			from city
            where country_id in (select country_id
				from country
                where country = "canada")));

-- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor 
    -- that has acted in the most number of films. First you will have to find the most prolific actor and 
    -- then use that actor_id to find the different films that he/she starred.
SELECT title
	FROM film
    JOIN film_actor
		ON film.film_id = film_actor.film_id
	WHERE actor_id =(SELECT actor_id
		FROM film_actor
        GROUP BY actor_id
        ORDER BY count(film_id) DESC
        LIMIT 1);

-- 7 Films rented by most profitable customer. You can use the customer table and payment table to find the 
    --most profitable customer ie the customer that has made the largest sum of payments.
select distinct title
	from film
    join inventory
		on film.film_id = inventory.film_id
	join rental 
		on inventory.inventory_id = rental.inventory_id
            where rental.customer_id = (select customer_id
			    from payment
				    group by customer_id
                    order by sum(amount) desc
                    limit 1);
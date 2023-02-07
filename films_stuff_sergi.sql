use sakila;
select film.title, count(inventory.film_id)
	from inventory
    left join film
    on film.film_id = inventory.film_id
    where film.title = "Hunchback Impossible"; 
    
select title, length 
	from film
    where length > 
		(select avg(length)
        from film);
        
select first_name, last_name 
	from actor
    where actor_id in 
		(select actor_id
			from film_actor
			where film_id = 
				(select film_id 
					from film
					where title = 'Alone Trip'));

select film.title 
	from film
		join film_category
		on film.film_id = film_category.film_id
			join category
            on film_category.category_id = category.category_id
	where category.name = 'family';
    
    
                    
-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
    
-- subquerys
select first_name, email
	from customer
	where address_id in 
		(select address_id
			from address
			where city_id in 
				(select city_id 
					from city
					where country_id in 
						(select country_id 
							from country
							where country = 'Canada')));
-- joins
select first_name,email
	from customer 
		join address
        on customer.address_id = address.address_id
			join city
            on address.city_id = city.city_id
				join country
                on city.country_id = country.country_id
where country.country = 'Canada';


-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select title
	from film
    join film_actor
		on film.film_id = film_actor.film_id
			where film_actor.actor_id =
				(select actor_id
					from film_actor
					group by actor_id
					order by count(film_id) desc
					limit 1);

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable 
-- customer ie the customer that has made the largest sum of payments

select distinct(title)
	 from film 
     join inventory
			on film.film_id = inventory.film_id
		 join rental
			on inventory.inventory_id = rental.inventory_id
				 where rental.customer_id = 
					(select customer_id 
						from payment
						group by customer_id
						order by sum(amount) desc
						limit 1);


-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select customer_id, sum(amount) as total_spent
	from payment
    group by customer_id
    having total_spent > 
		(select avg(total)
			from (select sum(amount) as total 
				from payment
				group by customer_id) as customer_total_amount);





    

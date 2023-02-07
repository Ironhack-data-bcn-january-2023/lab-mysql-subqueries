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
        
select actor.first_name, actor.last_name 
	from actor
    where actor.
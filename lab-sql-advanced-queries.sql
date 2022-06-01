use sakila;

-- 1
-- List each pair of actors that have worked together.
select distinct fa1.film_id, fa1.actor_id, a1.first_name, a1.last_name, fa2.actor_id, a2.first_name, a2.last_name,
row_number() over(order by fa1.film_id asc) as ranking_list from sakila.film_actor as fa1
join sakila.film_actor as fa2 using(film_id)
join sakila.actor as a1 on a1.actor_id = fa1.actor_id
join sakila.actor as a2 on a2.actor_id = fa2.actor_id
where a1.actor_id > a2.actor_id
order by fa1.film_id;

-- 2
-- For each film, list actor that has acted in more films.
select actor_id, film_id, count(film_id) as number_of_films, row_number() over(order by count(film_id) desc) as ranking_list from sakila.film_actor
group by film_id
order by number_of_films desc;
-- or
select fa.actor_id, a.first_name, a.last_name, fa.film_id, f.title, count(fa.film_id) as number_of_films, row_number() over(order by count(fa.film_id) desc) as ranking_list 
from sakila.film_actor as fa
join sakila.actor as a using(actor_id)
join sakila.film as f using(film_id)
group by film_id
order by number_of_films desc;
-- or if we need number_of_films > 1 , more than 1 films
with cte as (
select actor_id, film_id, count(film_id) as number_of_films, row_number() over(order by count(film_id) desc) as ranking_list from sakila.film_actor
group by film_id
order by number_of_films desc)
select actor_id, first_name, last_name, film_id, title, number_of_films, ranking_list from cte
join sakila.actor as a using(actor_id)
join sakila.film as f using(film_id)
where number_of_films > 1;

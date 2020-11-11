/*
Lab | Stored procedures

In this lab, we will continue working on the Sakila database of movie rentals.

Instructions

Write queries, stored procedures to answer the following questions:

1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:

  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
*/

use sakila;

-- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure.:

drop procedure if exists clients_by_movie;

delimiter //

create procedure clients_by_movie() 
begin

  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = 'Action'
  group by first_name, last_name, email;
  
  
end
//
delimiter ;

call clients_by_movie();



-- 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

drop procedure if exists clients_by_movie_2;

delimiter //

create procedure clients_by_movie_2(in movie_cat varchar(50)) 
begin

  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = movie_cat
  group by first_name, last_name, email;
  
  
end
//
delimiter ;

call clients_by_movie_2("Drama");

-- 3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

-- query:

select c.name, count(f.title) from film f
join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id

group by c.name 
;

-- procedure

drop procedure if exists movie_num;

delimiter //

	create procedure movie_num(in num integer) 
	begin

	select c.name, count(f.title) from film f
	join film_category fc on f.film_id = fc.film_id
	join category c on c.category_id = fc.category_id
	group by c.name 	
	having count(f.title) > num;
  
end
//
delimiter ;

call movie_num(60);

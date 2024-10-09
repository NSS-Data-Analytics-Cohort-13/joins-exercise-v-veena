-- Q.1 Give the name, release year, and worldwide gross of the lowest grossing movie.
select * from revenue;
select * from specs;
select * from rating;
select * from distributors;



select s1.film_title
	, s1.release_year
	, r1.worldwide_gross
from specs as s1
join revenue as r1
on s1.movie_id =r1.movie_id
order by r1.worldwide_gross asc;

--ans: semi-tough 1977 37187139

--Q.2 What year has the highest average imdb rating?
select s1.release_year
	, round(avg(r1.imdb_rating),3) as average_imdb_rating
from specs as s1
join rating as r1
on s1.movie_id=r1.movie_id 
group by s1.release_year
order by average_imdb_rating desc ;

--ans:1991 7.450

--Q 3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT  s1.film_title
	,	s1.mpaa_rating
	,	r1.worldwide_gross as highest_gross
from specs as s1
join distributors d1
on s1.domestic_distributor_id = d1.distributor_id
inner join revenue r1
using(movie_id)
where s1.mpaa_rating ='G' and s1.mpaa_rating is not null
--group by s1.film_title,s1.mpaa_rating
order by highest_gross desc
limit 1;
;

--Q.4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any  movies in the movies table.


select s1.film_title as movie_name
	,	d1.company_name as distributor_name
	,	count(distributor_id) as distributor_movie_count
from specs as s1
right join distributors as d1
on s1.domestic_distributor_id = d1.distributor_id
group by movie_name,distributor_name
;


--Q.5. Write a query that returns the five distributors with the highest average movie budget.

select  d1.company_name as cname -- distributor name
	--,	s1.film_title as mtitle  --movie title 
	,	avg(r1.film_budget) as avg_movie_budget
from distributors as d1
join specs as s1
on s1.domestic_distributor_id = d1.distributor_id
join revenue as r1
using(movie_id)
group by cname
order by avg_movie_budget desc
limit 5
;


--Q.6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

select  s1.film_title
	--,	count(s1.film_title) as movies_count
	--,	d1.company_name as distributor_name
	,	r1.imdb_rating
from specs as s1
join distributors as d1
on s1.domestic_distributor_id = d1.distributor_id
join rating as r1
using(movie_id)
where d1.headquarters not ilike '%CA'
group by s1.film_title,r1.imdb_rating
order by r1.imdb_rating desc
--limit 1
;

--Q.7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 
	CASE WHEN length_in_min <120 THEN 'Under 2 Hours' 
	when length_in_min >=120 then 'Over 2 Hours'
	END AS length_range, 
	AVG(r.imdb_rating) as avg_rating
FROM specs as s
LEFT JOIN rating as r
USING(movie_id)
GROUP BY length_range
ORDER BY avg_rating DESC;





--Bonus
--Q.1 Find the total worldwide gross and average imdb rating by decade. Then alter your query so it returns JUST the second highest average imdb rating and its decade. This should result in a table with just one row.

select sum(worldwide_gross) from revenue ;
select avg(imdb_rating) from rating;
select min(release_year),max(release_year) from specs

select  round((release_year/10),0)*10 as decade_year from specs

select round((s1.release_year/10),0)*10 as decade_year
	,	sum(r1.worldwide_gross) as wg
	,	avg(r2.imdb_rating) as rating
from revenue as r1
join rating r2
on r1.movie_id = r2.movie_id
join specs s1
on r1.movie_id = s1.movie_id
group by decade_year
order by rating desc
limit 1
offset 1;

/*Q.2.Our goal in this question is to compare the worldwide gross for movies compared to their sequels.
a. Start by finding all movies whose titles end with a space and then the number 2.*/

select film_title from specs
where film_title like '% 2';
/*b. For each of these movies, create a new column showing the original film’s name by removing the last two characters of the film title. For example, for the film “Cars 2”, the original title would be “Cars”. Hint: You may find the string functions listed in Table 9-10 of https://www.postgresql.org/docs/current/functions-string.html to be helpful for this. c. Bonus: This method will not work for movies like “Harry Potter and the Deathly Hallows: Part 2”, where the original title should be “Harry Potter and the Deathly Hallows: Part 1”. Modify your query to fix these issues.*/

select 

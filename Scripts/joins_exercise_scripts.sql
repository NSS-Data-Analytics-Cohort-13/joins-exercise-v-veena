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
	,	max(r1.worldwide_gross) as highest_gross
from specs as s1
join distributors d1
on s1.domestic_distributor_id = d1.distributor_id
inner join revenue r1
using(movie_id)
where s1.mpaa_rating ='G' and s1.mpaa_rating is not null
group by s1.film_title,s1.mpaa_rating
order by highest_gross desc
limit 1;
;

--Q.4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any  movies in the movies table.


select s1.film_title as movie_name
	,	d1.company_name as distributor_name
	,	count(distributor_id) as distributor_movie_count
from specs as s1
full join distributors as d1
on s1.domestic_distributor_id = d1.distributor_id
group by movie_name,distributor_name
;


--Q.5. Write a query that returns the five distributors with the highest average movie budget.

select  d1.company_name as cname -- distributor name
	,	s1.film_title as mtitle  --movie title 
	,	avg(r1.film_budget) as avg_movie_budget
from distributors as d1
join specs as s1
on s1.domestic_distributor_id = d1.distributor_id
join revenue as r1
using(movie_id)
group by cname,mtitle
order by avg_movie_budget desc
limit 5
;


--Q.6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

select  s1.film_title
	,	count(s1.film_title) as movies_count
	,	d1.company_name as distributor_name
	,	r1.imdb_rating
from specs as s1
join distributors as d1
on s1.domestic_distributor_id = d1.distributor_id
join rating as r1
using(movie_id)
where d1.headquarters not ilike '%CA'
group by distributor_name,s1.film_title,r1.imdb_rating
order by r1.imdb_rating desc
limit 1
;

--Q.7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

select * from specs;
select  s1.film_title
	,	s1.length_in_min
	,	round(avg(imdb_rating),3) as highest_avg_rating
from specs as s1
join rating r1
using(movie_id)
where s1.length_in_min > 120 or s1.length_in_min <120
group by s1.film_title,s1.length_in_min
order by highest_avg_rating desc;


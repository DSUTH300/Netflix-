select * from netflix1; -- lets see the data

select * from netflix2;

SELECT COUNT(type) AS types_of_movies ,country from netflix1
GROUP BY country
ORDER BY types_of_movies DESC;

-- Here we can see that the top 3 countries with the most netflix shows are United States, India,United Kingdom

SELECT DISTINCT(rating) from netflix2;

-- Here we can see the diffrent types of ratings

SELECT COUNT(show_id) AS types_of_rating ,rating from netflix2
GROUP BY rating
ORDER BY types_of_rating DESC;

-- Here we can see that the most number of ratings on netflix are TV-MA, TV-14 and TV-PG.It makes sence as these ratings are meant for all ages.

SELECT COUNT(rating) as rating_count,country from netflix1
INNER JOIN netflix2
ON netflix1.show_id = netflix2.show_id
WHERE rating = 'TV-MA' 
GROUP BY country
ORDER BY rating_count DESC;

--Here we can see that USA,India,UK is the top 3 countries with rating TV-MA.

SELECT COUNT(show_id) AS country_total,
CASE
WHEN (release_year > 2010) THEN 'New_Movies'
WHEN (release_year BETWEEN 2000 AND 2010) THEN 'Older'
WHEN (release_year < 2000) THEN 'Oldest'
END AS movie_era
FROM netflix1
GROUP BY movie_era
ORDER BY movie_era;

--Here we can see Netflix has 7266 movies which are released after 2010, 999 movies between 2000-2010 and 525 movies before 2000

SELECT 
SUM (CASE
WHEN (duration LIKE '___m%') THEN 1
ELSE 0
END) AS Movies_under_100min,
SUM (CASE
WHEN (duration LIKE '____m%') THEN 1
ELSE 0
END) AS Movies_over_100min,
SUM (CASE
WHEN (duration LIKE '__S%') THEN 1
ELSE 0
END) AS TV_show
FROM netflix2;

--Here we can see that on netflix there are 3201 movies which are under 100 min, 2921 movies over 2921 and 2650 TV shows

SELECT type, title,director,date_added FROM
(SELECT * FROM netflix1
INNER JOIN netflix2
ON netflix1.show_id = netflix2.show_id
WHERE rating = 'TV-MA' AND 
duration ILIKE '__s%') AS fo
ORDER BY date_added DESC
LIMIT 10;

-- The following are the latest 10 TV shows added in netflix with TV-MA rating.

SELECT show_id ,type,
CASE
WHEN (release_year > 2010) THEN 'New_Movies'
WHEN (release_year BETWEEN 2000 AND 2010) THEN 'Older'
WHEN (release_year < 2000) THEN 'Oldest'
END AS movie_era,
EXTRACT(YEAR FROM date_added) as year_added,
release_year,
country FROM netflix1
WHERE type = 'Movie'
ORDER BY release_year DESC
LIMIT 20;

-- it is intresting to see that the last 20 movies added by netflix are all new movies

SELECT show_id ,type,
CASE
WHEN (release_year > 2010) THEN 'New_Movies'
WHEN (release_year BETWEEN 2000 AND 2010) THEN 'Older'
WHEN (release_year < 2000) THEN 'Oldest'
END AS movie_era,
EXTRACT(YEAR FROM date_added) as year_added,
release_year,
country FROM netflix1
WHERE type = 'TV Show'
ORDER BY release_year DESC
LIMIT 20;

-- It is the same with TV series, the last 20 TV series released my netflix are new released TV series

SELECT type,country,director,duration,
(EXTRACT(YEAR FROM date_added)- release_year) AS period1,
CASE
WHEN ((EXTRACT(YEAR FROM date_added)- release_year)
	  = 0) THEN 'Movie_sameyear'
WHEN ((EXTRACT(YEAR FROM date_added)- release_year)
	  BETWEEN 0 AND 5)THEN 'Movie_olderrelease'
ELSE 'Movie_oldestrelease'
END AS ERA
FROM netflix1
INNER JOIN netflix2
ON netflix1.show_id = netflix2.show_id
WHERE type = 'Movie'
ORDER BY period1 DESC

--Here we can see majority of the older movies uploaded by netflix are either from USA or international movies and very few from UK.



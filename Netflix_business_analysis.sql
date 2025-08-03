-- Netflix project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
show_id VARCHAR(10),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
)
--Checking the data and import success
SELECT *
FROM netflix

--1. Count the number of movies and the number of TV shows

SELECT
	type,
	COUNT (*) AS total_content
FROM netflix
GROUP BY type;

-- 2. Find the most common ratings for the movies and the TV shows
SELECT
	type,
	rating
FROM
(
	SELECT
	    type,
	    rating,
	    COUNT(*) AS total_content,
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) as ranking
	FROM netflix
	GROUP BY type, rating
) AS t1
WHERE 
	ranking = 1

-- 3. List all movies released in a specific year
SELECT
    title,
    release_year
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

-- Find the Top 5 countires with the most content on netflix
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Identify the longest movie
SELECT
    title,
    CAST(SPLIT_PART(duration, ' ', 1) AS INT) AS Movie_duration_min
FROM netflix
WHERE type = 'Movie'
  AND duration IS NOT NULL
ORDER BY Movie_duration_min DESC
LIMIT 1;

--6. Find content added in the last 5 years
SELECT
	title,
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added
FROM netflix
WHERE date_added IS NOT NULL
	  AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY 2 DESC;

--7. Find all Movies/TV shows by director 'Rajiv Chilaka'
SELECT
	title,
	director
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons
SELECT
	type,
	title,
	CAST(SPLIT_PART(duration, ' ', 1) AS INT) AS duration_seasons
FROM netflix
WHERE type = 'TV Show'
		AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;

-- 9. Count the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	COUNT(*) AS total_content
FROM netflix
WHERE listed_in IS NOT NULL
GROUP BY genre
ORDER BY items DESC;

-- 10. Find each year and the average numbers of content release by India on netflix. Return top 5 year with highest avg content release ! 
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS release_year,
    COUNT(*) AS yearly_content,
    ROUND(
        COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%') * 100,
        2
    ) AS avg_content_per_year
FROM netflix
WHERE country ILIKE '%India%'
  AND date_added IS NOT NULL
GROUP BY 1
ORDER BY avg_content_per_year DESC
LIMIT 5;

-- 11. List all the movies that are documentaries
SELECT
	title,
	listed_in
FROM netflix
WHERE listed_in ILIKE ('%documentaries%');

-- 12. Find all content without a director
SELECT
	*
FROM netflix
WHERE director IS NULL;

-- 13. Find how many movies 'Salman Khan' appeared in last 10 years.
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
    COUNT(*) AS total_movies
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND type = 'Movie'
  AND date_added IS NOT NULL
  AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years'
GROUP BY year_added
ORDER BY year_added DESC;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE ('%India%')
AND casts IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15. Categorize the content based on the presence on the keywords 'kill' and 'violence' in the description field. 
-- LAbel content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each categorie.
WITH new_table
AS
(
SELECT 
	*,
	CASE
	WHEN description ILIKE ('%kill%') OR
		description ILIKE ('%violence%') THEN 'Bad_content'
		ELSE 'Good_content'
	END category
FROM netflix
)
SELECT
	category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY 1;


WHERE 
	description ILIKE ('%kill%')
	OR
	description ILIKE ('%violence%')
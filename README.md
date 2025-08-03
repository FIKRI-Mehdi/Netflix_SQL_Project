[logo]: [https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png](https://github.com/FIKRI-Mehdi/Netflix_SQL_Project/blob/main/logo.png) "Logo Title Text 2"
📊 Netflix Data Analysis with SQL
Overview
This project involves a comprehensive analysis of Netflix's Movies and TV Shows dataset using SQL. The goal is to extract valuable insights and answer key business questions that provide a deeper understanding of Netflix's content offerings.

🔍 Problem
Netflix offers a wide range of content globally, making it challenging to understand its composition, trends, and audience targeting. Business stakeholders need insights such as:

What type of content dominates the platform?

Which ratings are most frequent?

Which countries and genres are leading in production?

What trends can we spot over the past years?

💡 Solution
To address these questions, we used a structured SQL-based approach on the Kaggle Netflix dataset.

Dataset Schema
sql
Copy
Edit
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
Key Queries and Their Purpose
Distribution of Movies vs TV Shows

sql
Copy
Edit
SELECT type, COUNT(*) FROM netflix GROUP BY 1;
Most Common Rating per Type

Uses RANK() over grouped data to identify the top rating per content type.

Movies Released in a Specific Year (e.g. 2020)

Filters records by release_year.

Top 5 Countries with Most Content

Splits multi-country fields and counts entries.

Identify the Longest Movie

Uses SPLIT_PART(duration, ' ', 1)::INT for sorting.

Content Added in the Last 5 Years

Filters by parsed date_added using TO_DATE() and interval comparison.

Content Directed by 'Rajiv Chilaka'

Splits multi-director fields using UNNEST().

TV Shows with More Than 5 Seasons

Filters duration field after converting to integer.

Content Count per Genre

Uses STRING_TO_ARRAY() and UNNEST() on listed_in.

India’s Average Content Release by Year

Filters by country and computes average share using ROUND() and COUNT().

Documentary Movies

Filters listed_in with ILIKE '%Documentaries%'.

Content Without a Director

Filters NULL values in director.

Salman Khan's Movies in the Last 10 Years

Filters by cast name and recent release_year.

Top 10 Actors in Indian Movies

Splits and counts casts entries by frequency.

Content Categorization Based on Description

Classifies content into 'Good' or 'Bad' based on keywords like "kill" or "violence".

✅ Results
Content Mix: Balanced distribution between movies and TV shows.

Popular Ratings: TV shows and movies tend to have distinct common ratings.

Global Content: India, USA, and UK rank among the top contributors to Netflix's catalog.

Trend Spotting: Recent years have seen a steady increase in content addition.

Categorical Insights: Thematic classification gives insight into violent or light-hearted content.

📌 Conclusion
This SQL-driven analysis of Netflix's dataset provides rich insights into content distribution, country trends, genre popularity, and actor involvement. It serves as a powerful example of how raw data can answer strategic business questions when properly queried and interpreted.


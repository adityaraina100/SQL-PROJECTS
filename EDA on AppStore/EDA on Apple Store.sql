CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

union ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

union ALL

SELECT * FROM appleStore_description4

** EDA**
--Checking thr number of unique apps in both tableAppleStore----
select count(DISTINCT id) as UniqueAppIDs
from AppleStore

select count(DISTINCT id) as UniqueAppIDs
from appleStore_description_combined

--checking for missing feilds in the data tables--
select count(*) as MissingValues from AppleStore where track_name is null or  user_rating is null or prime_genre is null

select count(*) as MissingValues from appleStore_description_combined where app_desc is null
-- find out the number of apps per genre--
select prime_genre, count(*)  as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC  
-- get an overview of the apps ratings--
select min(user_rating)  as MinRating,
max(user_rating) as MaxRating,
avg(user_rating) as AvgRating 
from AppleStore

-- 2nd half: finding insights for the stakeholder--
** DATA  ANALYSIS**

--determine if paid apps have a goiod rating than free apps--
select case 
						when  price > 0 then 'Paid'
						  else 'Free'
                         end as App_Type,
                         avg(user_rating) as Avg_Rating 
 from AppleStore
 group by App_Type
 
 -- checking if language availability is a need for the stakeholder to keep in mind--
 select case
 				when lang_num <10 then '<10 languages'	
                when lang_num BETWEEN 10 and 30 then '10-30 languages'
                else 'more than 30 languages'
                END AS language_bucket,
                avg(user_rating) as Avg_Rating
  from AppleStore
  group by language_bucket
  order by Avg_Rating desc 
  
  --check genre with low ratings---
  select prime_genre, avg(user_rating) as Avg_Rating 
  from AppleStore
  group by prime_genre
  order by Avg_Rating ASC
  limit 10
  
  --relation between app description and use rating---
  select case 
  							when length(b.app_desc) <500 then 'short'
                            when length(b.app_desc) between 500 and   1000 then 'medium'
                            else 'long'
                 end as  description_length_bucket,
                 avg(a.user_rating) as avg_rating
                            
                            
  from AppleStore as A
  join  appleStore_description_combined as b 
  on 
  A.id=b.id
  group by description_length_bucket
  order by avg_rating desc
  
  --check the top rated apps from each genre--
  select
  prime_genre,
  track_name,
  user_rating
  from (
    select 
    prime_genre,
    track_name,
    user_rating,
    RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM 
    AppleStore
    ) AS A
   WHERE 
   A.RANK=1
  
  	
  
  
  
  
  
  










select * 
from spotify 
---20,594; total records  
--------------EDA ------------------
-- how many artist are there?
Select  count( distinct artist)
from spotify    ----2074 total Artist 

-- how many albums?

Select count(distinct album )
from spotify --- 11,854 albums albums 

----- how many album types are there?
select  distinct album_type
from spotify

-- how many types are there? 
select count(distinct title)
from spotify  -- there are more titles than albums which shows titles are for songs and not the title of the record

-- min/ max durration min
Select max(duration_min)
from spotify;

select min(duration_min)
from spotify; ---- there is a duration of 0. should delete these with 0 duration 

select * 
from spotify  
where duration_min = 0; 


--- delete the two songs with 0 duration
Delete From spotify
where duration_min = 0 ; 


-- how many types of channels are there? 
Select distinct channel 
from spotify; ---6,773


-- values for most played on 
Select distinct most_played_on 
from spotify; -- 2 options 

select count(distinct track)
from spotify 

select count(distinct album) 
from spotify  -- less albrums than track which implies that tracks are songs on a albrum

------------------------------

--Data Analyssis Easy SQL

-------------------------------
/* 
Fetch the name of all the tracks that have more than 1 billion streams.

List all albums along with their respective artist

Get the total number of comments for track where licensed = True 

Find all the tracks that belong to the album type single 

Count the total numer of tracks by each artist

top ten songs and their artist by views 
*/
select * from 
spotify
	
-- Q1) Fetch the name of all the tracks that have more than 1 billion streams.
Select 
	track
From Spotify 
Where stream > 1000000000;  -- 385 Songs creater than 1 billion


--Q2)List all albums along with their respective artist
Select 
	distinct album, 
	artist 
from spotify;

-- Q3)Get the total number of comments for track where licensed = True 
Select 
	sum(comments) as total_comments
from spotify 
where licensed = True;

-- Q4) Find all the tracks that belong to the album type single 

Select
	track
from spotify 
where album_type = 'single'; --4,973 Single Album Type

--Q5)Count the total numer of tracks by each artist

Select artist, count(track) as total_tracts
from spotify 
group by artist
order by total_tracts  desc
	
--top ten songs and their artist by views 
Select 
	album,
	sum(views) as total_views
from spotify
group by 1
order by total_views desc; 

Select 
	track,
	sum(views) as total_views
from spotify
group by 1
order by total_views desc; 


/* 
--------------

-- Medium Level 

--------------
Calculate the avg danceability of the trach in each album 

Find the top 5 tracks with the highest energy value 

List all track along with their views and likes where offical_vidoe = true 

For each album, calculate the total veiws of all associated traks 

Retrieve the track names that have been streamed on Spotify more than youtube
*/

select * 
from spotify
--Q6)Calculate the avg danceability of the trach in each album 
Select 
	album,
	avg(danceability) as avg_danceability
from spotify
group by album 
order by avg_danceability desc

--Q7)Find the top 5 tracks with the highest energy value 
Select 
	track,
   max(energy) as energy_level
from spotify
group by track 
order by energy_level DESC
	limit 5;

--Q8)List all track along with their views and likes where offical_vidoe = true 

Select
	track, 
	sum(views ) as total_views, 
	sum(likes) as total_likes
from spotify
Where official_video = 'true'
group by track 
order by total_views desc;

--Q9)For each album, calculate the total veiws of all associated traks 
Select 
	album, 
	track, 
	sum(views) as total_views
from spotify
group by album, track 
order by total_views desc

--Q10)retrieve the track names that have been streamed on Spotify more than youtube

Select * from 
(select 
	track, 
	
	Coalesce(Sum(Case When most_played_on = 'Youtube' then stream end),0) as stream_on_youtube,
	Coalesce(Sum(Case When most_played_on = 'Spotify' then stream  end),0) as stream_on_spotify  

from spotify
group by track
) as t1
where stream_on_spotify > stream_on_youtube
and stream_on_youtube != 0

/* 
--------------

-- Advanced Problems

--------------
Find the top 3 most-viewed tracks for each artist using window functions

Write a query to find tracks where the livness score is above the avg

Use with clause to calculate the difference between highest and lowest engery values for tracks in each 

Find tracks where the energy-to-liveness ratio is greater than 1.2

Calculate the cumulative sum of likes for track order by thenumber of views, using window functions 
*/
--Q11)Find the top 3 most-viewed tracks for each artist using window functions
	-- Steps 
	--each artist and tolal view for each track 
	--track with highest view for each artist/ top 
	--dense rank 
	--cte and filter rank > total_views
With ranking_artist
as (
Select 
	artist, 
	track, 
	Sum(views) as total_views,
	Dense_Rank() Over(partition by artist order by sum(views) desc) as rank
from spotify
group by artist, track
order by artist,  total_views desc
) 
Select * from ranking_artist 
where rank <= 3;

--Q12)Write a query to find tracks where the livness score is above the avg
--use subquery 
Select 
	track, 
	artist, 
	liveness
from spotify
where liveness > (
Select 
	avg(liveness)
from spotify
)

--Q13)Use with clause to calculate the difference between highest and lowest engery values for tracks in each 

With question13CTE
as (
Select 
	album, 
	min(energy) as lowest_energy,
	max(energy) as hihgest_energy
from spotify
group by album
	)
Select album, 
hihgest_energy - lowest_energy as energy_diff
from question13CTE
order by energy_diff  desc


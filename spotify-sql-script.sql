-- Retrieve the names of all tracks that have more than 1 billion streams
select track  from spotify where stream>100000000

-- List all albums along with their respective artists
select * from spotify where album=artist

-- Get the total number of comments for tracks where licensed = TRUE.
select * from spotify where licensed=True

-- Find all tracks that belong to the album type single
select * from spotify where album_type='single'

-- Count the total number of tracks by each artist.
select count(*),artist from spotify group by artist

-- Calculate the average danceability of tracks in each album.
select * from spotify
select album,avg(danceability) as average_danceability from spotify group by album

-- Find the top 5 tracks with the highest energy values.
select track,max(energy) as highest_energy from spotify group by track
order by highest_energy limit 5

-- List all tracks along with their views and likes where official_video = TRUE.
select track,sum(views) as album_views,
sum(likes) as album_likes from spotify 
where official_video='true'
group by 1
order by 2 desc

-- For each album, calculate the total views of all associated tracks
select * from spotify
select album,track,sum(views) as album_total_views from spotify group by album,track
order by 3 desc

-- Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from 
(select track,
COALESCE(sum(case WHEN most_played_on='Spotify' then stream END),0) as streamed_on_spotify,
COALESCE(sum(case WHEN most_played_on='Youtube' then stream END),0) as streamed_on_youtube 
from spotify
group by 1 ) as t
where streamed_on_spotify>streamed_on_youtube and streamed_on_youtube!=0

-- Find the top 3 most-viewed tracks for each artist using window function

select * from (
select *,rank() over(partition by artist order by views desc) as rnk from spotify	)as  t
where rnk<=3

-- Write a query to find tracks where the liveness score is above the average
select track,liveness from spotify where liveness > (select avg(liveness) as avearge_liveness from spotify)

-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
select * from spotify
with min_max_energy_values as (
select album,max(energy) as maximum_energy_value,
min(energy) as minimum_energy_value
from spotify group by album
)
,difference as (
select album,maximum_energy_value-minimum_energy_value as diff from min_max_energy_values
)
select * from difference where diff!=0

-- Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
select *, sum(likes) over (order by views desc) as cummulative_sum from spotify
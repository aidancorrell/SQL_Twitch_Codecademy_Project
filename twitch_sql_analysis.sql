-- viewing data table stream
SELECT *
FROM stream
LIMIT 20;

-- viewing data table chat
SELECT *
FROM chat
LIMIT 20;

-- finding all unique games in stream table
SELECT DISTINCT game
FROM stream;

-- finding all unique channels in stream table
SELECT DISTINCT channel
FROM stream;

-- finding game with most views
SELECT game, COUNT(*) as views
FROM stream
GROUP BY game
ORDER BY COUNT(*) DESC;

-- identifying League of Legend views by country
SELECT country, COUNT(*) as 'LOL viewers'
FROM stream
WHERE game = 'League of Legends'
GROUP BY country
ORDER BY COUNT(*) DESC;

-- identifying stream player/device with the most views
SELECT player, COUNT(*)
FROM stream
GROUP BY player
ORDER BY COUNT(*) DESC;

-- example of applying genres to certain games
SELECT game,
 CASE
  WHEN game = 'Dota 2'
      THEN 'MOBA'
  WHEN game = 'League of Legends' 
      THEN 'MOBA'
  WHEN game = 'Heroes of the Storm'
      THEN 'MOBA'
    WHEN game = 'Counter-Strike: Global Offensive'
      THEN 'FPS'
    WHEN game = 'DayZ'
      THEN 'Survival'
    WHEN game = 'ARK: Survival Evolved'
      THEN 'Survival'
  ELSE 'Other'
  END AS 'genre',
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 3 DESC;

-- viewing time data from stream table
SELECT time
FROM stream
LIMIT 10;



-- best time to stream in the US
SELECT strftime('%H', time),
   COUNT(*)
FROM stream
WHERE country = 'US'
GROUP BY 1
order by 2 desc;

-- best local time to stream based on views globally

SELECT strftime('%H', time), channel, game, COUNT(*) as views
FROM stream
GROUP BY 1
ORDER BY COUNT(*) DESC
LIMIT 20;


-- combining chat and stream tables

WITH combined as
(
  SELECT *
FROM stream
JOIN chat
  ON stream.device_id = chat.device_id
)

SELECT *
from combined
limit 20;

-- utilizing window functions to gain insight on the number of views per player(device) by game and by channel(streamer)

SELECT 
    distinct channel,
    game,
    player,
    count(device_id) OVER (
      PARTITION BY player
      order by game
    ) as 'count_views'
FROM
    stream
    where subscriber = 'true'
  --  limit 20;


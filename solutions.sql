-- Question 1
SELECT cpu_number, id as host_id, total_mem
FROM host_info
ORDER BY cpu_number, total_mem DESC;

-- Question 2
-- User Round 5 on the percentage to show the differences
-- Using function given in https://stackoverflow.com/questions/6195439/postgres-how-do-you-round-a-timestamp-up-or-down-to-the-nearest-minute
CREATE FUNCTION round_minutes(TIMESTAMP WITHOUT TIME ZONE, integer) 
RETURNS TIMESTAMP WITHOUT TIME ZONE AS $$ 
  SELECT 
     date_trunc('hour', $1) 
     +  cast(($2::varchar||' min') as interval) 
     * round( 
     (date_part('minute',$1)::float + date_part('second',$1)/ 60.)::float 
     / $2::float
      )
$$ LANGUAGE SQL IMMUTABLE;

SELECT id as host_id, hostname, total_mem, ROUND(((total_mem - avg(memory_free)* 1000 ) / total_mem)*100, 2) as used_memory_percentage
FROM 
(SELECT round_minutes("timestamp", 5) FROM host_usage) AS round_times,
host_info 
INNER JOIN host_usage on host_info.id = host_usage.host_id
GROUP BY id, hostname, total_mem, round_times;

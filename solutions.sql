-- Question 1
SELECT cpu_number, id as host_id, total_mem
FROM host_info
ORDER BY cpu_number, total_mem DESC;

-- Question 2
-- User Round 5 on the percentage to show the differences
SELECT id as host_id, hostname, total_mem, ROUND(((total_mem - avg(memory_free) over w) / total_mem)*100, 5) as used_memory_percentage
FROM host_info
INNER JOIN host_usage on host_info.id = host_usage.host_id
window w as (partition by round_minutes(host_usage."timestamp", 5));

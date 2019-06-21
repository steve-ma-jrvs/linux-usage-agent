#!/bin/bash

specs=`lscpu`
lscpu_out=$(echo "$specs")

hostname=$(hostname -f)

cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs )

cpu_architecture=$(echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs )

cpu_model=$(echo "$lscpu_out" | egrep "^Model name" | awk -F':' '{print $2}' | xargs )

cpu_mhz=$(echo "$lscpu_out" | egrep "^CPU MHz" | awk '{print $3}' | xargs )

L2_cache=$(echo "$lscpu_out" | egrep "^L2 cache" | awk '{print $3}' | sed 's/K//' | xargs )

timestamp=$(date "+%Y-%m-%d %H:%M:%S")

total_mem=$(cat /proc/meminfo | awk '{print $2}' | head -1 | xargs)


insert_statement=$(cat <<EOF
INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, "timestamp", total_mem)
VALUES("$hostname","$cpu_number", "$cpu_architecture", "$cpu_model", "$cpu_mhz", "$L2_cache", "$timestamp", "$total_mem")
EOF
)

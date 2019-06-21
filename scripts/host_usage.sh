#!/bin/bash

timestamp=$(date "+%Y-%m-%d %H:%M:%S")

host_id

#in MB
memory_free=$(vmstat --unit M | tail -1 | awk '{print $4}' | xargs)

#in percentage
cpu_idel=$(vmstat --unit M | tail -1 | awk '{print $(NF-2)}' | xargs)
cpu_kernel=$(vmstat --unit M | tail -1 | awk '{print $(NF-3)}' | xargs)

disk_io=$(vmstat -d | tail -1 | awk '{print $(NF-1)}' | xargs)

disk_available


cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs )

cpu_architecture=$(echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs )

cpu_model=$(echo "$lscpu_out" | egrep "^Model name" | awk -F':' '{print $2}' | xargs )





















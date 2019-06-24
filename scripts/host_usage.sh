#!/bin/bash

#Setup arguments
psql_host=$1
port=$2
db_name=$3
user_name=$4
password=$5


#Step 1: parse data and setup variables
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo "timestamp=$timestamp"

host_id=$(cat ~/host_id | xargs )
echo "host_id=$host_id"

#in MB
memory_free=$(vmstat --unit M | tail -1 | awk '{print $4}' | xargs)
echo "memory_free=$memory_free"

#in percentage
cpu_idel=$(vmstat --unit M | tail -1 | awk '{print $(NF-2)}' | xargs)
echo "cpu_idel=$cpu_idel"

cpu_kernel=$(vmstat --unit M | tail -1 | awk '{print $(NF-3)}' | xargs)
echo "cpu_kernel=$cpu_kernel"

disk_io=$(vmstat -d | tail -1 | awk '{print $(NF-1)}' | xargs)
echo "disk_io=$disk_io"

disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed 's\M\\' | xargs)
echo "disk_available=$disk_available"


#Step 2: construct INSERT Statement
insert_statement=$(cat <<-END
INSERT INTO host_usage("timestamp", host_id, memory_free, cpu_idel, cpu_kernel, disk_io, disk_available) VALUES('${timestamp}', ${host_id}, ${memory_free}, ${cpu_idel}, ${cpu_kernel}, ${disk_io}, ${disk_available});
END
)

echo $insert_statement

#Step 3: Execute database setup and insert statement
export PGPASSWORD=$password
psql -h $psql_host -p $port -U $user_name -d $db_name -c "$insert_statement"
sleep 1


## Introduction

Cluster Monitor Agent is an internal tool that monitors the cluster resources such as CPU, memory and disk available of a Linux cluster. It helps the infrastructure team to record and analyze the CPU/Memory.

## Architecture and Design

* The cluster diagram with three linux hosts, a DB and agents

 ![project](https://github.com/steve-ma-jrvs/linux-usage-agent/blob/master/project.png)

* Create a database named host_agent in Postgres and save data into two tables:

  1. host_info

     table columns: id, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, timestamp

  2. host_usage

     table columns: timestamp, host_id, memory_free, cpu_idel, cpu_kernel, disk_io, disk_available

* Create two scripts to insert data into the created table
  1. `host_info.sh` collects the host hardware info and insert it into the database.
  2. `host_usage.sh` collects the current host usage (CPU and memory)

## Usage

* Use `init.sql` init database and tables. Run only once.

* `host_info.sh` run only once to insert the the hostinfo into the host_info table.

* `host_usage` be triggered by the `crontab` job every minute and insert data into host_usage table.

* `crontab` setup with every minute to run host_usage and save result into host_usage.log

```bash
* * * * * bash .../host_usage.sh (args)  > /tmp/host_usage.log
```

## Improvements

1. Handle hardware updates
2. Record the unusual CPU/Memory usage data
3. Create a backup database on other server as well

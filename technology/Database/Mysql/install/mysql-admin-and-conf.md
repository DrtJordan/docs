# mysql 管理和配置

## 一、管理命令

``` sh

-- 查看 Mysql 进程列表
  SHOW PROCESSLIST;

-- 杀死指定进程
  kill [id]

-- 查看变量配置
  show variables like "%lower_case_table_names%";

-- 查看 Mysql 最大连接数
  show variables like '%max_connections%';

  # 永久生效 my.cnf
  max_connections=300

  # 当前进程生效
  set global max_connections=300

-- 服务相应用户最大连接数
  show global status like 'Max_used_connections';

  #  max_max_connections 合理设置范围(Max_used_connections 连接比例值要占 max_connections 10% 以上, 如果没有则表示 max_connections 设置过高)
  Max_used_connections / max_connections * 100% , 结果要在 10% 以上


-
   service mysqld reload

```

## 二、配置模板

``` sh

-- my.conf


[mysqld]
datadir=/data/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql

# 不区分大小写
lower_case_table_names = 1

# innodb缓冲池大小  4294967296 字节 = 4 G
innodb_buffer_pool_size = 4294967296

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

max_connections = 150
max_connect_errors = 10
read_rnd_buffer_size = 4M
max_allowed_packet = 4M
table_cache = 1024
myisam_sort_buffer_size = 32M
thread_cache = 16
query_cache_size = 16M
tmp_table_size = 64M

log-bin=mysql-bin

innodb_file_per_table=1
wait_timeout = 1200
thread_concurrency = 8
innodb_data_file_path = ibdata1:10M:autoextend
innodb_additional_mem_pool_size = 32M
innodb_thread_concurrency = 16

# 慢查询
slow_query_log=/var/log/mysql/slow.log
long_query_time=1
log-queries-not-using-indexes
log-slow-admin-statements

```

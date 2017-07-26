# MySQL 数据导入导出

## 导入数据

``` sql

1) 导入 test.sql 数据到 test 数据库
  mysql -utest -ptest test -v -f < ./test.sql


2) LOAD DATA 文件导入表
参数:
  --local-infile     显示参数, 用来支持客户端导入数据到远程 Mysql
  LOAD DATA LOW_PRIORITY LOCAL INFILE;  从本地客户端读取数据, 导入到远程数据库

  CHARACTER SET UTF8 FIELDS TERMINATED BY '\t' ENCLOSED BY '"' LINES TERMINATED BY '\n' (`field_1`,`field_2`,`field_3`);  配置编码格式, 列分隔符，行分隔符

  LOW_PRIORITY : MySQL 等待无人读表时，才导入数据


方法1: 登录 mysql 执行
  mysql --local-infile -hhost -uuser_name -ppass_word

  mysql> LOAD DATA LOW_PRIORITY LOCAL INFILE '/path/test.txt' INTO TABLE db_name.tb_name CHARACTER SET UTF8 (`field_1`,`field_2`,`field_3`);
   OR
  mysql> LOAD DATA LOW_PRIORITY LOCAL INFILE '/path/test.txt' INTO TABLE db_name.tb_name CHARACTER SET UTF8 FIELDS TERMINATED BY '\t' ENCLOSED BY '"' LINES TERMINATED BY '\n';  


方法2: 通过 -e 参数执行
  mysql --local-infile -hhost -uuser_name -ppass_word -e "LOAD DATA LOW_PRIORITY LOCAL INFILE '/path/test.txt' INTO TABLE db_name.tb_name CHARACTER SET UTF8"

```


## 导出数据

### 1、导出数据

``` sql

1) 导出 test 数据库到 test.sql 文件
  mysqldump -uroot -p123 test -F > ./test.sql


2) 导出指定库库中的表
  mysqldump -h[host] -u[account] -p[password] [db_name] [table_name]] > ./table_name.sql

4) 导出 test 到文件
    mysql -h10.10.2.91 -uhadoop -pangejia888 -s -e "SELECT * FROM test.performance_mb limit 10" > ./tablename
```


### 2、把查询数据导出到文件

``` sql

SELECT
  p.TypeName,
  c.*
FROM
  ajk_communitys as c
LEFT JOIN
  ajk_commtype as p
ON
  c.CityId = p.CityId
WHERE
  p.CityId IN ('19','27')
AND
  p.parentid = '0'
INTO outfile '/tmp/communitys6.txt'
fields terminated by '\t'
optionally enclosed by '"'
escaped by '"'
lines terminated by '\n'
;



SELECT
  *
FROM
 test.performance_mb
LIMIT 10
INTO outfile '/tmp/performance_mb_2.txt'
fields terminated by '\t'
optionally enclosed by '"'
escaped by '"'
lines terminated by '\n'
;



```

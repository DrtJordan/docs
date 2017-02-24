./index.py \
--service extract \
--module extract_run \
--par '{"dbServer":"dw","sourceDb":"temp_db","sourceTb":"jason_test_1","targetDb":"db_sync","targetTb":"temp_db__jason_test_1","extractType":"1","extractTool":"2","mapReduceNum":"1"}'


/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818" --table "jason_test_1" --hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1


/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818"

--query 'SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1' \
--query "SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1 "

--hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1


SELECT concat('2017-02-24', ' ', '01', ':00', ':00') , from_unixtime(unix_timestamp('2017-02-24 01:00:00')-3600,'yyyy-MM-dd HH:mm:ss') , concat('2017-02-24', ' ', '01', ':00', ':00');



SELECT concat('2017-02-24', ' ', '01', ':00', ':00'), from_unixtime(unix_timestamp('2017-02-24 01:00:00')-3600,'%Y-%m-%d %h:%i:%s'), concat('2017-02-24', ' ', '01', ':00', ':00');


SELECT *
FROM dm_db.dm_product_inst_step_index
WHERE concat(p_dt, ' ', p_hours, ':00', ':00') BETWEEN from_unixtime(unix_timestamp('2017-02-24 01:00:00')-3600,'%Y-%m-%d %h:%i:%s') AND concat('2017-02-24', ' ', '01', ':00', ':00')
;


SELECT *
FROM dm_db.dm_product_inst_step_index
WHERE
;


SELECT unix_timestamp(concat('2017-02-24', ' ', '01', ':00', ':00'))
SELECT unix_timestamp(concat('2017-02-24', ' ', '01', ':00', ':00'), 'yyyy-MM-dd HH:mm:ss')

 SELECT
  p_dt,p_hours,count(*) as cn
FROM
  ods.ods_safe_click_step
WHERE unix_timestamp(concat(p_dt, ' ', p_hours, ':00', ':00')) >= unix_timestamp(concat('2017-02-24', ' ', '01', ':00', ':00'))-3600
  AND unix_timestamp(concat(p_dt, ' ', p_hours, ':00', ':00')) <= unix_timestamp(concat('2017-02-24', ' ', '01', ':00', ':00'))
GROUP BY p_dt,p_hours
;


select year('2017-02-24');


from_unixtime(unix_timestamp('2017-02-24 01:00:00') ,'yyyy-MM-dd HH:mm:ss')


create table temp_db.jason_test_date as
SELECT unix_timestamp('2017-02-24 01:00:00') AS unix_timestamp
  ,from_unixtime(unix_timestamp('2017-02-24 01:00:00')-3600, 'yyyy-MM-dd HH:mm:ss') AS from_unixtime
  ,year('2017-02-24 01:00:00') as year
  ,month('2017-02-24 01:00:00') as month
  ,day('2017-02-24 01:00:00') as day
  ,hour('2017-02-24 01:00:00') as hour
  ,minute('2017-02-24 01:00:00') as minute
;




ADD JAR /home/hadoop/app/jars/dw_hive_udf-1.0.jar;
CREATE   FUNCTION  date_format as 'com.angejia.dw.hive.udf.date.DateFormat';


SELECT date_format('2017-02-24 01:00:00',"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd HH:mm:ss", "+" , 3600);

SELECT
  p_dt,p_hours,count(*) as cn
FROM
  ods.ods_safe_click_step
WHERE (p_dt = date_format('2017-02-24 01:00:00',"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd") AND p_hours = '01')
  OR (p_dt = '2017-02-24' AND p_hours = '00')
GROUP BY p_dt,p_hours
;





SELECT
 p_dt,p_hours,count(*) as cn
FROM
  ods.ods_safe_click_step
WHERE concat(p_dt, ' ', p_hours) BETWEEN date_format('2017-02-24 15',"yyyy-MM-dd HH","yyyy-MM-dd HH", '-', 7200) AND '2017-02-24 15'
GROUP BY p_dt,p_hours
;




SELECT
  p_dt,p_hours,count(*) as cn
FROM
 ods.ods_safe_click_step
WHERE unix_timestamp(concat(p_dt, ' ', p_hours, ':00', ':00')) >= unix_timestamp('2017-02-24 15:00:00')

GROUP BY p_dt,p_hours
;





unix_timestamp(s_1.p_dt, 'yyyy-MM-dd') >= unix_timestamp('2015-06-08', 'yyyy-MM-dd')
  AND
unix_timestamp(s_1.p_dt, 'yyyy-MM-dd') <= unix_timestamp('2015-06-14', 'yyyy-MM-dd')

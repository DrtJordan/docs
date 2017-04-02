./index.py \
--service extract \
--module extract_run \
--par '{"dbServer":"dw","sourceDb":"temp_db","sourceTb":"jason_test_1","targetDb":"db_sync","targetTb":"temp_db__jason_test_1","extractType":"1","extractTool":"2","mapReduceNum":"1"}'


/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818" --table "jason_test_1" --hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1


/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818"

--query 'SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1' \
--query "SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1 "

--hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1






-------------------------------------------------------------------------
--                    日期范围 START
-------------------------------------------------------------------------

-- HIVE 自定义日期, 精确到秒 UDF
date_format('${dealDate} ${dealHours}',"yyyy-MM-dd HH","yyyy-MM-dd HH", '-', 3600)

-- HIVE 日期范围
p_dt BETWEEN date_sub('${dealDate}', 14) AND '${dealDate}'

-- MYSQL 指定日期范围
p_dt BETWEEN date_sub('${dealDate}', interval 14 day) AND '${dealDate}'

-- MYSQL 当日范围数据
p_dt BETWEEN date_sub(DATE_FORMAT(NOW(), '%Y-%m-%d'), interval 14 day) AND date_format(now(),'%Y-%m-%d')



-------------------------------------------------------------------------
--                    日期范围 END
-------------------------------------------------------------------------

SET hive.exec.parallel=false;
SET hive.exec.mode.local.auto=false;

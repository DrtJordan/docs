./index.py \
--service extract \
--module extract_run \
--par '{"dbServer":"dw","sourceDb":"temp_db","sourceTb":"jason_test_1","targetDb":"db_sync","targetTb":"temp_db__jason_test_1","extractType":"1","extractTool":"2","mapReduceNum":"1"}'


/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818" --table "jason_test_1" --hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1


/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818"

--query 'SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1' \
--query "SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1 "

--hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1

-- 启动方式
CONCAT("{",
  '"kj_01":"', COALESCE(get_json_object(base_log.count, "$.kj_01"), 0), '",',
  '"kj_02":"', COALESCE(get_json_object(base_log.count, "$.kj_02"), 0), '",',
  '"kj_03":"', COALESCE(get_json_object(base_log.count, "$.kj_03"), 0), '",',
  '"kj_04":"', COALESCE(get_json_object(base_log.count, "$.kj_04"), 0), '",',
  '"kj_05":"', COALESCE(get_json_object(base_log.count, "$.kj_05"), 0), '",',
  '"kj_06":"', COALESCE(get_json_object(base_log.count, "$.kj_06"), 0), '",',
  '"kj_07":"', COALESCE(get_json_object(base_log.count, "$.kj_07"), 0), '",',
  '"kj_09":"', COALESCE(get_json_object(base_log.count, "$.kj_09"), 0), '"'
"}") AS start_type,

-- 自定义日期 UDF
date_format('${dealDate} ${dealHours}',"yyyy-MM-dd HH","yyyy-MM-dd HH", '-', 3600)

-- 指定日期前
SELECT date_sub('2017-02-16', 14);
SELECT date_sub('2017-02-16', interval 14 day);


SET hive.exec.mode.local.auto=false;
DROP TABLE IF EXISTS temp_db.dm_product_mac__ie_pinyin;
CREATE TABLE IF NOT EXISTS temp_db.dm_product_mac__ie_pinyin AS
SELECT
  ie.mac
FROM temp_db.dm_product_mac__ie AS ie
INNER JOIN temp_db.dm_product_mac__pinyin AS pinyin
  ON ie.mac = pinyin.mac
;


SELECT * FROM ods.ods_inst_click WHERE p_dt='2017-02-09' AND p_hours='00' LIMIT 10;

SELECT get_json_object(common,'$.a0356')  FROM ods.ods_safe_click WHERE p_dt='2017-02-06' AND p_hours = '00' LIMIT 1
FROM (
 SELECT `common` FROM ods.ods_safe_click WHERE p_dt='2017-02-06' AND p_hours = '00' LIMIT 1
) AS a



select `common`,'(1)',`count`,'(2)',`integer`,'(3)',`string`,'(4)',`ip` from ods.ods_safe_click where common is not null limit 10;




-- 非压缩
ALTER TABLE ods.ods_browser_click ADD IF NOT EXISTS PARTITION  (p_dt = '2017-02-06', p_hours = '01') LOCATION '/ods/browser_click/20170206/01';

-- 已压缩, 6 个文件
ALTER TABLE ods.ods_browser_click ADD IF NOT EXISTS PARTITION  (p_dt = '2017-02-06', p_hours = '02') LOCATION '/ods/browser_click/20170206/02';

-- 已压缩 ,1 个文件
ALTER TABLE ods.ods_browser_click ADD IF NOT EXISTS PARTITION  (p_dt = '2017-02-06', p_hours = '03') LOCATION '/ods/browser_click/20170206/03';



-- 开启本地mr(本地模式的参数, 是 and 关系, 都满足才会生效)
set hive.exec.mode.local.auto=true;
-- 设置local mr的最大输入数据量,当输入数据量小于这个值的时候会采用local  mr的方式(字节) 1024000000
set hive.exec.mode.local.auto.inputbytes.max=1024000000;
-- 设置local mr的最大task 数量,小于这个数量使用本地模式
set hive.exec.mode.local.auto.tasks.max=100;
-- 设置local mr的最大输入文件个数,当输入文件个数小于这个值的时候会采用local mr的方式
set hive.exec.mode.local.auto.input.files.max=100;


-- 一个 Map 最多同时处理的文件总数大小
set mapreduce.input.fileinputformat.split.maxsize=1024000000;
set mapreduce.input.fileinputformat.split.minsize.per.node=1024000000;
set mapreduce.input.fileinputformat.split.minsize.per.rack=1024000000;


-- 一个 Reduce 最多同时处理的文件总数大小
set hive.exec.reducers.bytes.per.reducer=1024000000;


SELECT COUNT(*) FROM ods.ods_browser_click WHERE p_dt='2017-02-06' AND p_hours = '01';

SELECT COUNT(*) FROM ods.ods_browser_click WHERE p_dt='2017-02-06' AND p_hours = '02';

SELECT COUNT(*) FROM ods.ods_browser_click WHERE p_dt='2017-02-06' AND p_hours = '03';


SELECT p_dt,
        p_hours,
        count(*) AS cn
FROM ods.ods_browser_click
GROUP BY p_dt,p_hours



./index.py \
--service extract \
--module extract_run \
--par '{"dbServer":"dw","sourceDb":"temp_db","sourceTb":"jason_test_1","targetDb":"db_sync","targetTb":"temp_db__jason_test_1","extractType":"1","extractTool":"2","mapReduceNum":"1"}'



/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818" --table "jason_test_1" --hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1


/usr/lib/sqoop/bin/sqoop import --connect "jdbc:mysql://172.16.19.51:3306/temp_db?useUnicode=true&tinyInt1isBit=false&characterEncoding=utf-8" --username "dw_service" --password "dw_service_818"

--query 'SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1' \
--query "SELECT * FROM temp_db.jason_test_1 WHERE $CONDITIONS LIMIT 1 "

--hive-table "db_sync.temp_db__jason_test_1" --hive-import --map-column-hive "channel=String,client_ip=String,mac=String,install_day=String,use_day=String,version=String,server_time=String,system_start_time=String,system_install_time=String,pc_name=String,pc_hardware=String,big_version=String,kuid=String,tag=String,type=String,p_dt=String" --fields-terminated-by '\001' --hive-delims-replacement '%n&' --lines-terminated-by '\n' --input-null-string '\\N' --input-null-non-string '\\N' --null-string '\\N' --null-non-string '\\N' --outdir "/home/hadoop/app/dw_etl/tmp/sqoop_outdir" --target-dir "/tmp/sqoop/db_sync.temp_db__jason_test_1" --delete-target-dir --m 1

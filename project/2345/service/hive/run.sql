CREATE EXTERNAL TABLE IF NOT EXISTS ods.ods_browser_use (
  `channel` string,
  `client_ip` string,
  `mac` string,
  `install_day` string,
  `use_day` string,
  `version` string,
  `server_time` string,
  `system_start_time` string,
  `system_install_time` string,
  `pc_name` string,
  `pc_hardware` string,
  `big_version` String,
  `kuid` string,
  `tag` string
) PARTITIONED BY (type String, p_dt String)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
  COLLECTION ITEMS TERMINATED BY '\n'
STORED AS TEXTFILE
;

-- 分区加载外部数据
ALTER TABLE ods.ods_browser_use ADD IF NOT EXISTS PARTITION  (type = '0',p_dt = ${dealDate}) LOCATION '/ods/browser_use/0/${baseDealDate}';
ALTER TABLE ods.ods_browser_use ADD IF NOT EXISTS PARTITION  (type = '1',p_dt = ${dealDate}) LOCATION '/ods/browser_use/1/${baseDealDate}';
ALTER TABLE ods.ods_browser_use ADD IF NOT EXISTS PARTITION  (type = '2',p_dt = ${dealDate}) LOCATION '/ods/browser_use/2/${baseDealDate}';


ADD JAR /etc/hive/auxlib/json-serde-1.3.7-jar-with-dependencies.jar;


CREATE EXTERNAL TABLE IF NOT EXISTS temp_db.test_safe_click (
  `common` string,
  `count` string,
  `integer` string,
  `string` string,
  `ip` string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  "ignore.malformed.json"="true"
)
STORED AS TEXTFILE
;

hdfs dfs -ls /user/hive/warehouse/temp_db.db/test_safe_click


load data local inpath '/data1/log/tmp/2017-01-21-09-1.txt.gz' OVERWRITE into TABLE temp_db.test_safe_click;




load data local inpath '/data1/log/tmp/2017-01-21-09-3.snappy' OVERWRITE into TABLE temp_db.test_safe_click;


CREATE TABLE temp_db.test_safe_click_1 STORED AS TEXTFILE AS SELECT * FROM temp_db.test_safe_click;

SELECT * FROM temp_db.test_safe_click limit 1;








SELECT * FROM ods.ods_safe_click WHERE p_dt='2017-02-06' AND p_hours = '00' LIMIT 1;


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

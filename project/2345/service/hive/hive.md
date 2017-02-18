# 服务端

``` sh
beeline -u jdbc:hive2://dw2:10000/default -nhadoop -phadoop

hive --hiveconf  hive.root.logger=DEBUG,console
```



``` sql

CREATE EXTERNAL TABLE IF NOT EXISTS temp_db.test_array (
  `array_a` ARRAY<string>
)
STORED AS TEXTFILE
;

set hive.exec.compress.output=false;
set mapreduce.map.output.compress=false;
set mapreduce.output.fileoutputformat.compress=false;

INSERT OVERWRITE TABLE temp_db.test_array
SELECT split(process_list,",") AS a
FROM dw_db.dw_channel_inst_log
WHERE p_dt='2017-02-16' AND p_hours="00"
LIMIT 2;

```

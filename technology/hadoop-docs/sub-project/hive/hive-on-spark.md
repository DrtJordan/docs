# Hive On Spark

- 由于 Hive 在 1.1 版本把 Spark 包也放入到了 Hive 中, 但是 Hive On Spark 中的 Spark 版本没有 Spark 社区迭代活跃, 所以使用 Spark 社区的 Spark-Sql 反向支持 Hive , 不会受到 Hive 版本的影响


## 随手 demo (没有通过)


``` sql
set spark.home=/usr/local/spark;

set hive.execution.engine=spark;
set hive.enable.spark.execution.engine=true;

set spark.master=yarn;
set spark.submit.deployMode=client;
set spark.eventLog.enabled=false;

set spark.driver.cores=2;
set spark.driver.memory=5g;

set spark.executor.cores=2;
set spark.executor.memory=2g;

set spark.eventLog.dir=hdfs://dw2:8020/tmp/spark;

set spark.serializer=org.apache.spark.serializer.KryoSerializer;
```

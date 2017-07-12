# Spark Sql ON Hive

## 一、配置文件

### 1. spark-defaults.conf

- 详见配置文件

### 2. hive 集成配置

hive-site.xml
>ln -s $HIVE_HOME/conf/hive-site.xml $SPARK_HOME/conf/hive-site.xml


core-site.xml
>ln -s $HIVE_HOME/conf/core-site.xml $SPARK_HOME/conf/core-site.xml


yarn-site.xml
>ln -s $HIVE_HOME/conf/yarn-site.xml $SPARK_HOME/conf/yarn-site.xml


``` xml
<!-- 设置 metastore thrift 地址 -->
<property>
  <name>hive.metastore.uris</name>
  <value>thrift://hostname1:9083,thrift://hostname2:9083</value>
</property>
```



## 二、SparkSQL 客户端模式

``` sh
-- 普通加载模式
spark-sql \
--master yarn \
--deploy-mode client \
--name spark-sql-service_1 \
--driver-cores 2 \
--driver-memory 4096M \
--executor-cores 1 \
--executor-memory 2048M \
--num-executors 3 \
--jars file:///etc/hive/auxlib/dw_hive_udf-1.0.jar,file:///etc/hive/auxlib/json-serde-1.3.7-jar-with-dependencies.jar


-- 配置参数加载模式
spark-sql \
--master yarn \
--deploy-mode client \
--name spark-sql-service \
--driver-cores 2 \
--driver-memory 4096M \
--executor-cores 1 \
--executor-memory 2048M \
--num-executors 3 \
--conf spark.driver.extraJavaOptions="-DJAVA_LIBRARY_PATH=/opt/cloudera/parcels/CDH/lib/hadoop/lib/native:$LD_LIBRARY_PATH" \
--jars file:///etc/hive/auxlib/dw_hive_udf-1.0.jar,file:///etc/hive/auxlib/json-serde-1.3.7-jar-with-dependencies.jar

```


## 三、SparkSQL thrift-server 服务

- 开启 thrift-server 服务
- [spark thrift-jdbcodbc-serve 文档](http://spark.apache.org/docs/latest/sql-programming-guide.html#running-the-thrift-jdbcodbc-server)

### 1. 启动 Thriftserver 进程

``` sh

1. Yarn 模式
  (1) yarn-client 模式 , 让 Yarn 管理进程 , Driver 运行在客户端 ,Work 运行在 NodeManager 上
    $SPARK_HOME/sbin/start-thriftserver.sh \
    --master yarn \
    --deploy-mode client \
    --name spark-sql-service \
    --driver-cores 2 \
    --driver-memory 4096M \
    --executor-cores 1 \
    --executor-memory 2048M \
    --num-executors 3 \
    --jars file://path/xxx.jar,file://path/xxx.jar \
    --hiveconf hive.server2.thrift.port=10002

  (2) yarn-cluster模式, 集群模式目前不支持
    ./sbin/start-thriftserver.sh \
    --master yarn \
    --deploy-mode client \
    --name spark-sql-service \
    --driver-cores 2 \
    --driver-memory 4096M \
    --executor-cores 1 \
    --executor-memory 2048M \
    --num-executors 3 \
    --hiveconf hive.server2.thrift.port=10002

2. standalone 模式
  $SPARK_HOME/sbin/start-thriftserver.sh \
  --master spark://uhadoop-ociicy-task3:7077 \
  --deploy-mode client \
  --name spark-sql \
  --driver-cores 2 \
  --driver-memory 500M \
  --hiveconf hive.server2.thrift.port=10002


3. JDBC 操作 hive
  $SPARK_HOME/bin/beeline !connect jdbc:hive2://hostname:10002

```


### 2. Thriftserver 实际案例

``` sh
启动服务

$SPARK_HOME/sbin/start-thriftserver.sh \
  --master yarn \
  --deploy-mode client \
  --name spark-sql-service \
  --driver-cores 1 \
  --driver-memory 2048M \
  --executor-cores 2 \
  --executor-memory 4096M \
  --num-executors 3 \
  --hiveconf hive.server2.thrift.port=10002 \
  --jars file:///etc/hive/auxlib/dw_hive_udf-1.0.jar,file:///etc/hive/auxlib/json-serde-1.3.7-jar-with-dependencies.jar

连接
  $SPARK_HOME/bin/beeline -u jdbc:hive2://hostname:10002/default -nhadoop -phadoop

```


## 三、Spark Sql Udf

- Hive UDF 与 Spark UDF 通用
- [UDF](technology/hadoop-docs/sub-project/hive/hive-udf.md)

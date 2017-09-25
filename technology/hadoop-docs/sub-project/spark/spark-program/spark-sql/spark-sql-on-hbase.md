# SparkSQL 与 Hbase 整合

## 一、环境

``` sh
1) 创建 hive on hbase 数据表, 具体参见 hive-on-hbase 文档

1) 把 hbase 所有的主机名配置到 /etc/hosts 中,保证每个 host 都能访问到 hbase 集群的服务器
    vim /etc/hosts
    例如 :
    10.10.33.175    uhadoop-ociicy-core1
    10.10.7.68      uhadoop-ociicy-core2
    10.10.43.97     uhadoop-ociicy-core3
    10.10.240.22    uhadoop-ociicy-core4
    10.10.236.241   uhadoop-ociicy-core5
    10.10.222.21    uhadoop-ociicy-core6
    10.10.229.183   uhadoop-ociicy-task3
    10.10.234.131   uhadoop-ociicy-task4

2) 配置相关的依赖 jar 包(具体跟随集群环境走)
    $HBASE_HOME/lib/hbase-annotations-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/hbase-spark-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/hbase-common-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/hbase-client-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/hbase-server-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/hbase-protocol-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/guava-12.0.1.jar
    $HBASE_HOME/lib/htrace-core-3.2.0-incubating.jar
    $HBASE_HOME/lib/zookeeper.jar
    $HBASE_HOME/lib/protobuf-java-2.5.0.jar
    $HBASE_HOME/lib/hbase-hadoop2-compat-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/hbase-hadoop-compat-1.2.0-cdh5.9.2.jar
    $HBASE_HOME/lib/metrics-core-2.2.0.jar
    $HIVE_HOME/lib/hive-hbase-handler-1.1.0-cdh5.9.0.jar

```

## 二、命令

``` sh

1. 注意事项

配置好 hbase-site.xml, 配置好 --jars
spark-sql \
--master yarn \
--deploy-mode client \
--name spark-hbase-demo \
--driver-cores 1 \
--driver-memory 1024M \
--executor-cores 1 \
--executor-memory 1024M \
--num-executors 1 \
--files $HBASE_HOME/conf/hbase-site.xml \
--jars file://$HBASE_HOME/lib/hbase-annotations-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/hbase-spark-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/hbase-common-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/hbase-client-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/hbase-server-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/hbase-protocol-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/guava-12.0.1.jar,file://$HBASE_HOME/lib/htrace-core-3.2.0-incubating.jar,file://$HBASE_HOME/lib/zookeeper.jar,file://$HBASE_HOME/lib/protobuf-java-2.5.0.jar,file://$HBASE_HOME/lib/hbase-hadoop2-compat-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/hbase-hadoop-compat-1.2.0-cdh5.9.2.jar,file://$HBASE_HOME/lib/metrics-core-2.2.0.jar,file://$HIVE_HOME/lib/hive-hbase-handler-1.1.0-cdh5.9.0.jar
```

# Spark 优化

## 一、Spark 优化

``` sql
--- Shuffle 行为（Behavior） Start ---
-- 每个输出都要创建一个缓冲区，这代表要为每一个 Reduce 任务分配一个固定大小的内存, 除非内存很大否则设置小点
SET spark.reducer.maxSizeInFlight=48m;

-- 是否要对 map 输出的文件进行压缩
SET spark.shuffle.compress=true;

-- shuffle 过程中对溢出的文件是否压缩
SET spark.shuffle.spill.compress=true;

--- Shuffle 行为（Behavior） End ---



--- 压缩和序列化（Compression and Serialization） Start ---

-- 是否在发送广播变量前压缩
SET spark.broadcast.compress=true;
-- 内部数据压缩编码, RDD、广播变量和混洗输出
SET spark.io.compression.codec=org.apache.spark.io.SnappyCompressionCodec;
-- 在采用 Snappy 压缩编解码器的情况下，Snappy 压缩使用的块大小。减少块大小还将降低采用 Snappy 时的混洗内存使用。
SET spark.io.compression.snappy.blockSize=32k;


-- Kryo 序列化缓冲区的最大允许大小。
SET spark.kryoserializer.buffer.max=64m;
-- Kryo 序列化缓冲区的初始大小
SET spark.kryoserializer.buffer=64k;
-- 是否压缩序列化的 RDD 分区, 能节省大量空间，但多消耗一些 CPU 时间。
SET spark.rdd.compress=true;
-- 通过网络发送或需要以序列化形式缓存的对象的类, Java 默认序列化很慢
SET spark.serializer=org.apache.spark.serializer.KryoSerializer;
-- 序列化器 每过 100 个对象被重置一次. 使用 org.apache.spark.serializer.KryoSerializer 序列化的时候,  序列化器缓存对象虽然可以防止写入冗余数据，但是却停止这些缓存对象的垃圾回收.
SET spark.serializer.objectStreamReset=100;

--- 压缩和序列化（Compression and Serialization) End ---




--- 动态分配 Start ---

-- 是否使用动态资源分配，它根据工作负载调整为此应用程序注册的执行程序数量。
SET spark.dynamicAllocation.enabled=true;
-- 使用外部 shuffle, 保存了由 executor 写出的 shuffle 文件所以 executor 可以被安全移除, spark.dynamicAllocation.enabled 为 true, 这个选项才可以为 true
SET spark.shuffle.service.enabled=true;
-- 如果启用动态分配，并且执行程序已空闲超过此持续时间，则将删除执行程序。
SET spark.dynamicAllocation.executorIdleTimeout=60s;

--- 动态分配 End ---


--- 执行器优化 Start ---

-- 并行度级别, 建议为每一个 CPU 核（ core ）分配 2-3 个任务
SET spark.PairRDDFunctions=16;

--- 执行器优化 End ---

```



## 二、Spark Sql 优化

``` sql

--- Spark Sql 调优 Start ---

-- 读取文件时单个分区可容纳的最大字节数(128M)。
SET spark.sql.files.maxPartitionBytes=134217728;

-- 调节每个 partition 大小
SET spark.sql.files.openCostInBytes=134217728;

-- 一个表在执行 join 操作时能够广播给所有 worker 节点的最大字节大小
SET spark.sql.autoBroadcastJoinThreshold=134217728;

-- 配置为连接或聚合操作混洗（shuffle）数据时使用的分区数
SET spark.sql.shuffle.partitions=200;

-- true: 单会话模式. false(默认): 多会话模式, JDBC / ODBC 连接拥有一份自己的 SQL 配置和临时注册表
SET spark.sql.hive.thriftServer.singleSession=false;

-- Spark SQL 将会基于数据的统计信息自动地为每一列选择单独的压缩编码方式
SET spark.sql.inMemoryColumnarStorage.compressed=true;

-- 控制列式缓存批量的大小。当缓存数据时，增大批量大小可以提高内存利用率和压缩率，但同时也会带来 OOM（Out Of Memory）的风险。
SET spark.sql.inMemoryColumnarStorage.batchSize=10000;
```



## 三、Spark Streaming 优化

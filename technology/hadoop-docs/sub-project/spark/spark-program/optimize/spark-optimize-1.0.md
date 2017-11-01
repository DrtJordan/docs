# Spark 优化

## 一、Spark 优化

``` sql

--- 应用属性 Start ---

-- SparkContext 启动时是否把生效的 SparkConf 属性以 INFO 日志打印到日志里
SET spark.logConf=false;


--- 应用属性 End ---



--- 执行器行为（Execution Behavior）Start ---

-- 设置每个 stage 的默认 task 数量, 不设置可能会直接影响你的 Spark 作业性能。公式 (num-executors * executor-cores)*3
SET spark.default.parallelism=18;

--- 执行器行为（Execution Behavior）End ---



--- 内存管理（Memory Management） Start ---

----- 一个 Executor 对应一个JVM进程，Executor 占用的内存分为两大部分：ExecutorMemory 和 MemoryOverhead -----

-- ExecutorMemory 即 --executor-memory
spark.executor.memory

-- memoryStore 用于缓存 Executor 中的 RDD 数据
-- 默认 (ExecutorMemory - MEMORY_USED_BY_RUNTIME) * spark.storage.memoryFraction * spark.storage.safetyFraction, 不建议自己配置
spark.storage.memoryFraction, spark.storage.safetyFraction

-- MemoryOverhead 在 JVM 进程中除 Java 堆以外占用的空间大小，包括方法区（永久代）、Java虚拟机栈、本地方法栈、JVM进程本身所用的内存、直接内存（Direct Memory）等,  单位 MB
-- 默认（math.max((MEMORY_OVERHEAD_FACTOR * executorMemory).toInt,MEMORY_OVERHEAD_MIN）, 例如 1024 MB * 0.07 = 72 MB
-- MEMORY_OVERHEAD_FACTOR = 0.07,  MEMORY_OVERHEAD_MIN = 384
spark.yarn.executor.memoryOverhead =


--- 内存管理（Memory Management） End ---



--- Shuffle 行为（Behavior） Start ---

-- 每个输出都要创建一个缓冲区，这代表要为每一个 Reduce 任务分配一个固定大小的内存, 除非内存很大否则设置小点, 默认 48m
SET spark.reducer.maxSizeInFlight=256m;

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
SET spark.kryoserializer.buffer.max=256m;
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

-- 注意事项：根据任务动态向 yarn 申请资源, 会导致申请资源浪费大量时间。

-- 是否使用动态资源分配，它根据工作负载调整为此应用程序注册的执行程序数量。
SET spark.dynamicAllocation.enabled=false;
-- 每个Application最小分配的executor数
SET spark.dynamicAllocation.minExecutors=1;
-- 每个 Application 最大并发分配的 executor 数。  ThriftServer 模式是整个 ThriftServer 同时并发的最大资源数，如果多个用户同时连接，则会被多个用户共享竞争
SET spark.dynamicAllocation.maxExecutors=30;
SET spark.dynamicAllocation.schedulerBacklogTimeout=1s;
SET spark.dynamicAllocation.sustainedSchedulerBacklogTimeout=5s;
-- 使用外部 shuffle, 保存了由 executor 写出的 shuffle 文件所以 executor 可以被安全移除, spark.dynamicAllocation.enabled 为 true, 这个选项才可以为 true
SET spark.shuffle.service.enabled=false;
-- 如果启用动态分配，并且执行程序已空闲超过此持续时间，则将删除执行程序。
SET spark.dynamicAllocation.executorIdleTimeout=60s;

--- 动态分配 End ---




--- 调度器优化 Start ---

-- FAIR 公平调度器, FIFO 先进先出调度器
SET spark.scheduler.mode=FAIR;

-- 任务推测
SET spark.speculation=true;

-- 每个任务分配的 CPU 核数
SET spark.task.cpus=1;

--- 调度器优化 End ---



--- Spark UI Start ---

-- 在垃圾回收前，Spark UI 和 API 有多少 Job 可以留存
SET spark.ui.retainedJobs=300;

-- 在垃圾回收前，Spark UI 和 API 有多少 Stage 可以留存。
SET spark.ui.retainedStages=300;

-- 在垃圾回收前，Spark UI 和 API 有多少 Task 可以留存。
SET spark.ui.retainedTasks=500;

-- 在垃圾回收前，Spark UI 和 API 有多少 executor 已经完成。
SET spark.worker.ui.retainedExecutors=300;

-- 在垃圾回收前，Spark UI 和 API 有多少 driver 已经完成。
SET spark.worker.ui.retainedDrivers=300;

-- 在垃圾回收前，Spark UI 和 API 有多少 execution 已经完成。
SET spark.sql.ui.retainedExecutions=300;

-- 在垃圾回收前，Spark UI 和 API 有多少 batch 已经完成。
SET spark.streaming.ui.retainedBatches=300;

-- 在垃圾回收前，Spark UI 和 API 有多少 dead executors。
SET spark.streaming.ui.retainedBatches=300;

--- Spark UI End ---

```



## 二、Spark Sql 优化

``` sql

--- Spark Sql 调优 Start ---

-- 读取文件时单个分区可容纳的最大字节数(128M)。
SET spark.sql.files.maxPartitionBytes=268435456;

-- 调节每个 partition 大小(128M), 小文件合并
SET spark.sql.files.openCostInBytes=134217728;

-- 一个表在执行 join 操作时能够广播给所有 worker 节点的最大字节大小
SET spark.sql.autoBroadcastJoinThreshold=134217728;

-- 连接或聚合操作混洗（shuffle）数据时使用的分区数, shuffle 的并发度，默认为 200。可用来控制输出的文件数量
SET spark.sql.shuffle.partitions=30;

-- true: 单会话模式. false(默认): 多会话模式, JDBC / ODBC 连接拥有一份自己的 SQL 配置和临时注册表
SET spark.sql.hive.thriftServer.singleSession=false;

-- Spark SQL 将会基于数据的统计信息自动地为每一列选择单独的压缩编码方式
SET spark.sql.inMemoryColumnarStorage.compressed=true;

-- 控制列式缓存批量的大小。当缓存数据时，增大批量大小可以提高内存利用率和压缩率，但同时也会带来 OOM（Out Of Memory）的风险。
SET spark.sql.inMemoryColumnarStorage.batchSize=10000;

-- spark 格式待测试
SET spark.sql.default.fileformat=orc;

--- Spark Sql 调优 END ---
```



## 三、Spark Streaming 优化

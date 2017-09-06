# Yarn 配置

- [官方文档](http://hadoop.apache.org/docs/stable2/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)


yarn.scheduler.minimum-allocation-mb
yarn.scheduler.maximum-allocation-mb

yarn.scheduler.minimum-allocation-vcores
yarn.scheduler.maximum-allocation-vcores

yarn-site.xml	yarn.nodemanager.resource.memory-mb	= Containers个数* 每个Container内存
yarn-site.xml	yarn.scheduler.minimum-allocation-mb	= 每个Container内存
yarn-site.xml	yarn.scheduler.maximum-allocation-mb	= Containers个数* 每个Container内存
mapred-site.xml	mapreduce.map.memory.mb	= 每个Container内存
mapred-site.xml	mapreduce.reduce.memory.mb	= 2 * 每个Container内存
mapred-site.xml	mapreduce.map.java.opts	= 0.8 * 每个Container内存
mapred-site.xml	mapreduce.reduce.java.opts	= 0.8 * 2 * 每个Container内存
yarn-site.xml (check)	yarn.app.mapreduce.am.resource.mb	= 2 * 每个Container内存
yarn-site.xml (check)	yarn.app.mapreduce.am.command-opts	= 0.8 * 2 * 每个Container内存


# Fair Scheduler

``` sql

-- 使用默认队列时的 Fair Scheduler 用户。 当设置为 true 时，如果未指定池名称，Fair Scheduler 将会使用用户名作为默认的池名称。当设置为 false 时，所有应用程序都在一个名为 default 的共享池中运行。
yarn.scheduler.fair.user-as-default-queue=true;

-- Fair Scheduler 优先权。是否抢占资源
yarn.scheduler.fair.preemption=false;

-- Fair Scheduler 优先权利用率阈值。抢占之前的利用率阈值。利用率计算为所有资源中使用量与容量之间的最大比例。默认为0.8
yarn.scheduler.fair.preemption.cluster-utilization-threshold


```

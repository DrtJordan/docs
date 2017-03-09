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

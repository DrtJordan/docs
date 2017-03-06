# HiveServer 2 And Clients

## 简介

- HiveServer2(HS2) 是一个服务器接口,使远程客户端对 hive 执行查询和检索结果。基于节俭RPC,当前的实现是一种改进的版本 HiveServer 和支持多客户端并发性和身份验证

## 一、Setting Up HiveServer2

启动 HiveServer2

- https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2

### 1、 Authentication/Security Configuration  认证/安全配置

- HiveServer2支持匿名(没有验证)和没有SASL,Kerberos(GSSAPI),通过LDAP,可插入自定义的身份验证和可插入身份验证模块(PAM,支持蜂巢0.13开始)。



## 二、HiveServer2 Clients

通过 beeline 客户端连接 HiveServer2

- https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients

### beeline 连接 HiveServer2

``` sh
beeline
beeline> !connect jdbc:hive2://hostname:10000 hadoop org.apache.hive.jdbc.HiveDriver

  show databases;

或

beeline -u jdbc:hive2://hostname:10002/default -nhadoop -phadoop
```


## 三、命令

``` sh
1、重启 hive-server2
sudo service hive-server2 restart

脚本启动
ps -aux | grep hiveserver2
kill -15 删除进程号
sudo nohup nice -n 0 /opt/cloudera/parcels/CDH/bin/hive --service hiveserver2 10000 >> /tmp/hiver-server2.log 2>&1 &

2、重启元数据
sudo service hive-metastore restart


3、hive debug 模式
hive --hiveconf  hive.root.logger=DEBUG,console

```

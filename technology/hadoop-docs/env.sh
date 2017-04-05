# JAVA
JAVA_HOME=/path/java

# Hadoop
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/conf
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_HOME_WARN_SUPPRESS=true
export HADOOP_PREFIX=$HADOOP_HOME
export HADOOP_MAPRED=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_YARN=$HADOOP_HOME
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH


# Yarn
export YARN_HOME=$HADOOP_HOME
export YARN_CONF_DIR=$HADOOP_HOME/conf


# HIVE
export HIVE_HOME=/usr/local/hive
export HIVE_CONF_DIR=$HIVE_HOME/conf


# Spark
export SPARK_HOME=/usr/local/spark
export SPARK_CONF_DIR=$SPARK_HOME/conf
export SPARK_LIBRARY_PATH=$SPARK_LIBRARY_PATH:$HADOOP_HOME/lib/native
export SPARK_CLASSPATH=$SPARK_CLASSPATH:$HADOOP_HOME/lib/snappy-java-1.0.4.1.jar


# HBASE
export HBASE_HOME=/usr/lib/hbase
export HBASE_CONF_DIR=$HBASE_HOME/conf


# SQOOP_HOME
export SQOOP_HOME=/usr/local/spark
export SPARK_CONF_DIR=$SQOOP_HOME/conf


# LIBRARY
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:/usr/lib64:/usr/local/cuda/lib64:/usr/local/cuda/lib:$LD_LIBRARY_PATH
export JAVA_LIBRARY_PATH=$JAVA_LIBRARY_PATH:$HADOOP_HOME/lib/native


export PATH=/usr/local/cuda/bin:$PATH

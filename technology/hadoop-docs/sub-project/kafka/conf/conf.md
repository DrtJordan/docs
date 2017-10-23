
``` sql
auto.create.topics.enable=false

auto.leader.rebalance.enable=true

default.replication.factor=3

delete.topic.enable=true

# 1 - 2147483646
log.cleaner.delete.retention.ms=86400000

log.cleaner.enable=false


log.cleanup.policy=delete

# 1 - 10000
log.retention.hours=168

# 1 - 2147483646
log.segment.bytes=1048576

# 1 - 2147483646
message.max.bytes=1000000

# 1 - 32
num.io.threads=8

# 1 - 32
num.network.threads=3

# 1 - 1000
num.partitions=3

# 1 - 2147483646
replica.fetch.max.bytes=1048576

# 1 - 2147483646
zookeeper.connection.timeout.ms=6000

# 1 - 2147483646
zookeeper.session.timeout.ms=30000

# 1 - 2147483646
zookeeper.sync.time.ms=2000
```

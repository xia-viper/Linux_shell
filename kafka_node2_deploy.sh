#!/bin/bash
# Kafka集群自动化部署脚本 node2
# 权限校验
if [ "$(id -u)" -ne 0 ];then
	    echo "❌ 错误：必须使用root用户执行此脚本！"
	        exit 1
fi

mkdir -p /export/server
cd /export/server

# 软链接
ln -s /export/server/kafka_2.13-3.6.2 /export/server/kafka
mkdir -p /export/server/kafka/data

cd /export/server/kafka/config
cp -f server.properties server.properties.bak

cat > server.properties <<EOF
broker.id=2
listeners=PLAINTEXT://192.168.56.120:9092
advertised.listeners=PLAINTEXT://192.168.56.120:9092
log.dirs=/export/server/kafka/data
zookeeper.connect=192.168.56.110:2181,192.168.56.120:2181,192.168.56.130:2181
num.partitions=3
default.replication.factor=3
offsets.topic.replication.factor=3
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2
min.insync.replicas=2
EOF

echo "✅ node2 Kafka部署完成"

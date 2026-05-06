#!/bin/bash
# Kafka集群自动化部署脚本 node1
# 权限校验：非root直接退出
if [ "$(id -u)" -ne 0 ];then
	    echo "❌ 错误：必须使用root用户执行此脚本！"
	        exit 1
fi

# 基础环境
mkdir -p /export/server
cd /export/server

# 解压离线安装包（提前上传到/export/server）
tar -zxvf kafka_2.13-3.6.2.tgz
ln -s /export/server/kafka_2.13-3.6.2 /export/server/kafka

# 数据目录
mkdir -p /export/server/kafka/data

# 备份原有配置
cd /export/server/kafka/config
cp -f server.properties server.properties.bak

# 写入集群配置
cat > server.properties <<EOF
broker.id=1
listeners=PLAINTEXT://192.168.56.110:9092
advertised.listeners=PLAINTEXT://192.168.56.110:9092
log.dirs=/export/server/kafka/data
zookeeper.connect=192.168.56.110:2181,192.168.56.120:2181,192.168.56.130:2181
num.partitions=3
default.replication.factor=3
offsets.topic.replication.factor=3
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2
min.insync.replicas=2
EOF

# 分发安装包到另外两台节点
scp -r /export/server/kafka_2.13-3.6.2 root@192.168.56.120:/export/server/
scp -r /export/server/kafka_2.13-3.6.2 root@192.168.56.130:/export/server/

echo "✅ node1 Kafka部署完成"

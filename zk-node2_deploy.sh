#!/bin/bash
# Zookeeper 3.8.4 集群自动部署 - node2
mkdir -p /export/server
cd /export/server

# 软链接
ln -s /export/server/apache-zookeeper-3.8.4-bin /export/server/zookeeper

# 创建数据目录
mkdir -p /export/server/zookeeper/data /export/server/zookeeper/logs

# myid = 2
echo 2 > /export/server/zookeeper/data/myid

echo "===== node2 部署完成 ====="

#启动Zookeeper
# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld
setenforce 0

# 启动 ZK
cd /export/server/zookeeper/bin
./zkServer.sh start

# 查看状态
./zkServer.sh status

# 验证进程
jps

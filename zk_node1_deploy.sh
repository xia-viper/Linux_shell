#!/bin/bash
# Zookeeper 3.8.4 集群自动部署 - node1
mkdir -p /export/server
cd /export/server

# 下载
wget https://archive.apache.org/dist/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz

# 解压
tar -zxvf apache-zookeeper-3.8.4-bin.tar.gz -C /export/server/

# 软链接
ln -s /export/server/apache-zookeeper-3.8.4-bin /export/server/zookeeper

# 配置文件
cd /export/server/zookeeper/conf
cp zoo_sample.cfg zoo.cfg

# 写入集群配置
cat > zoo.cfg << EOF
tickTime=2000
initLimit=5
syncLimit=2
dataDir=/export/server/zookeeper/data
dataLogDir=/export/server/zookeeper/logs
clientPort=2181
server.1=192.168.56.110:2888:3888
server.2=192.168.56.120:2888:3888
server.3=192.168.56.130:2888:3888
EOF

# 创建数据目录 + myid
mkdir -p /export/server/zookeeper/data /export/server/zookeeper/logs
echo 1 > /export/server/zookeeper/data/myid

# 分发到 node2、node3
scp -r /export/server/apache-zookeeper-3.8.4-bin root@node2:/export/server/
scp -r /export/server/apache-zookeeper-3.8.4-bin root@node3:/export/server/

echo "===== node1 部署完成，已分发到 node2/node3 ====="

#启动Zookeeper服务
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

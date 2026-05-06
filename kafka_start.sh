#!/bin/bash
# Kafka后台启动脚本 三台通用
if [ "$(id -u)" -ne 0 ];then
	    echo "❌ 错误：必须使用root用户执行此脚本！"
	        exit 1
fi

# 自动创建日志文件
touch /export/server/kafka/kafka-server.log

# 标准正确nohup后台启动 日志写入指定文件
nohup /export/server/kafka/bin/kafka-server-start.sh \
	/export/server/kafka/config/server.properties \
	>> /export/server/kafka/kafka-server.log 2>&1 &

sleep 3
echo "✅ Kafka已后台启动"
echo "----------进程检查----------"
jps | grep Kafka
echo "----------端口检查----------"
ss -ntlp | grep 9092

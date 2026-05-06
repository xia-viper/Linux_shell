#!/bin/bash
# CentOS Stream 9 一键部署Redis脚本
# 执行权限：chmod +x install_redis.sh && ./install_redis.sh

set -e

# 检查是否为root用户
if [ "$(id -u)" -ne 0 ]; then
	    echo "错误：请使用root用户执行此脚本！"
	        exit 1
fi

echo "==================== 开始部署Redis ===================="

# 1. 配置EPEL仓库
echo "1. 安装EPEL仓库..."
yum install -y epel-release

# 2. 安装Redis
echo "2. 安装Redis..."
yum install -y redis

# 3. 启动并设置开机自启
echo "3. 启动Redis服务..."
systemctl start redis
systemctl enable redis
systemctl status redis --no-pager

# 4. 放行6379端口（推荐）
echo "4. 放行防火墙6379端口..."
if systemctl is-active --quiet firewalld; then
	    firewall-cmd --add-port=6379/tcp --permanent
	        firewall-cmd --reload
	else
		    echo "防火墙未运行，跳过端口放行"
fi

# 5. 验证端口监听
echo "5. 检查Redis端口监听..."
netstat -anp | grep redis-server

# 6. 功能测试
echo "6. Redis功能测试..."
redis-cli set test_key "deploy_success"
result=$(redis-cli get test_key)
echo "测试结果：test_key = $result"

echo "==================== Redis部署完成 ===================="
echo "连接命令：redis-cli"
echo "服务管理：systemctl start|stop|restart|status redis"

#!/bin/bash
# 适用于 CentOS Stream 9 离线部署 RabbitMQ 3.13.2
# 必须先把 rabbitmq-server-generic-unix-3.13.2.tar.xz 上传到 /opt 目录

set -e

cd /opt

# 1. 解压安装包
echo "===== 开始解压 ====="
tar -xvf rabbitmq-server-generic-unix-3.13.2.tar.xz

# 2. 配置永久环境变量（修复：脚本内外直接生效）
echo "===== 配置永久环境变量 ====="
echo 'export PATH=$PATH:/opt/rabbitmq_server-3.13.2/sbin' >> /etc/profile
source /etc/profile

# 3. 后台启动 RabbitMQ
echo "===== 启动 RabbitMQ ====="
/opt/rabbitmq_server-3.13.2/sbin/rabbitmq-server -detached

# 4. 等待服务完全启动（关键修复）
sleep 8

# 5. 启动检测
echo "===== 检测运行状态 ====="
/opt/rabbitmq_server-3.13.2/sbin/rabbitmq-diagnostics ping

# 6. 开启 Web 管理插件
echo "===== 开启管理控制台 ====="
/opt/rabbitmq_server-3.13.2/sbin/rabbitmq-plugins enable rabbitmq_management

# 7. 防火墙放端口（修复：不直接关闭防火墙）
echo "===== 放行防火墙端口 ====="
firewall-cmd --permanent --add-port=5672/tcp
firewall-cmd --permanent --add-port=15672/tcp
firewall-cmd --reload

# 8. 创建管理员账号
echo "===== 创建管理员账号 ====="
/opt/rabbitmq_server-3.13.2/sbin/rabbitmqctl add_user Admin Admin2026*
/opt/rabbitmq_server-3.13.2/sbin/rabbitmqctl set_permissions -p / Admin ".*" ".*" ".*"
/opt/rabbitmq_server-3.13.2/sbin/rabbitmqctl set_user_tags Admin administrator

# 9. 删除默认 guest 用户
/opt/rabbitmq_server-3.13.2/sbin/rabbitmqctl delete_user guest

# 10. 配置开机自启（重要补充）
echo "===== 配置开机自启 ====="
cat > /etc/systemd/system/rabbitmq.service <<EOF
[Unit]
Description=RabbitMQ
After=network.target

[Service]
Type=forking
ExecStart=/opt/rabbitmq_server-3.13.2/sbin/rabbitmq-server -detached
ExecStop=/opt/rabbitmq_server-3.13.2/sbin/rabbitmqctl stop
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable rabbitmq

# 完成
echo "====================================================="
echo "✅ RabbitMQ 部署完成！"
echo "访问地址：http://本机IP:15672"
echo "账号：Admin"
echo "密码：Admin2026*"
echo "====================================================="





#!/bin/bash
set -e

echo "==================== 开始安装 Docker ===================="

# 1. 安装依赖工具
dnf install -y yum-utils

# 2. 添加阿里云 Docker 官方源
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 3. 安装 Docker 最新版
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. 启动并开机自启
systemctl enable --now docker

# 5. 配置镜像加速（严格按你文档里的3个稳定源）
mkdir -p /etc/docker
tee /etc/docker/daemon.json >/dev/null <<-'EOF'
{
	  "registry-mirrors": [
	      "https://docker.1panel.live",
	          "https://docker.mirrors.ustc.edu.cn",
		      "https://hub-mirror.c.163.com"
		        ]
		}
	EOF

	# 6. 重载配置并重启 Docker
	systemctl daemon-reload
	systemctl restart docker

	echo "==================== Docker 安装完成 ===================="
docker -v
echo "=========================================================="
echo " 正在测试拉取 nginx 镜像..."
docker pull nginx
echo "=========================================================="
echo " ✅ 全部成功！Docker 已安装并配置加速完成！"

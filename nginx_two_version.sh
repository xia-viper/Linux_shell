#!/bin/bash

# 自动拉取两个版本 Nginx
echo "===== 拉取 Nginx latest 和 1.20 镜像 ====="
docker pull nginx:latest
docker pull nginx:1.20

# 启动 latest 版本（80端口）
echo "===== 启动 Nginx latest（端口80） ====="
docker run -d \
	  --name nginx-new \
	    -p 80:80 \
	      nginx:latest

# 启动 1.20 版本（8088端口）
echo "===== 启动 Nginx 1.20（端口8088） ====="
docker run -d \
	  --name nginx-old \
	    -p 8088:80 \
	      nginx:1.20

# 修改 nginx-new 首页
echo "===== 修改 nginx-new 首页 ====="
docker exec nginx-new sh -c 'echo "<h1>Hello Nginx-latest</h1>" > /usr/share/nginx/html/index.html'

# 修改 nginx-old 首页
echo "===== 修改 nginx-old 首页 ====="
docker exec nginx-old sh -c 'echo "<h1>Hello Nginx-1.20</h1>" > /usr/share/nginx/html/index.html'

# 查看容器状态
echo -e "\n===== 当前运行容器 ====="
docker ps

echo -e "\n✅ 双版本 Nginx 部署完成！"
echo "访问："
echo "   Nginx latest  => http://本机IP:80"
echo "   Nginx 1.20    => http://本机IP:8088"

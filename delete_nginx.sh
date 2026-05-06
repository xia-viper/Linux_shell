#!/bin/bash
echo "===== 停止并删除容器 ====="
docker stop nginx-new nginx-old
docker rm nginx-new nginx-old

echo "===== 删除镜像 ====="
docker rmi nginx:latest nginx:1.20

echo "✅ 清理完成！"

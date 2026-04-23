#!/bin/bash

#检查是否以root用户执行
set -e

echo -e "\n=======================开始自动部署Nginx=====================\n"

#1.安装依赖yum-utils
echo "安装yum依赖工具"
yum install -y yum-utils

#2.备份原有仓库
mkdir -p ~/repo-bak
mv /etc/yum.repos.d/* ~/repo-bak/ 2>/dev/null || true

#3.写入CentOS Stream 9阿里云资源
echo "配置系统官方阿里云源。。。"
cat > /etc/yum.repos.d/centos-stream9.repo <<EOF
[baseos]
name=CentOS Stream 9 BaseOS
baseurl=https://mirrors.aliyun.com/centos-stream/9-stream/BaseOS/x86_64/os/
enabled=1
gpgcheck=0

[appstream]
name=CentOS Stream 9 AppStream
baseurl=https://mirrors.aliyun.com/centos-stream/9-stream/AppStream/x86_64/os/
enabled=1
gpgcheck=0

[crb]
name=CentOS Stream 9 CRB
baseurl=https://mirrors.aliyun.com/centos-stream/9-stream/CRB/x86_64/os/
enabled=1
gpgcheck=0
EOF

#4.配置EPEL阿里云源
echo "4.配置EPEL扩展源。。。"
cat > /etc/yum.repos.d/epel-9.repo <<EOF
[epel]
name=EPEL 9 阿里云镜像
baseurl=https://mirrors.aliyun.com/epel/9/Everything/x86_64/
enabled=1
gpgcheck=0
EOF

#5.刷新缓存
echo "5.刷新缓存..."
dnf clean all
dnf makecache

#6.安装Nginx
echo "6.开始安装Nginx..."
yum install -y nginx

#7.查看版本
echo -e "\n7.Nginx版本信息:"
nginx -version

#8.启动并设置为开机自启动
echo -e "\n8.启动并设置为开机自启动..."
systemctl start nginx
systemctl enable nginx
#--no-pager:一次性把防火墙的全部状态打印出来，不会出现--more--需要手动翻页
systemctl status nginx --no-pager

#9.关闭防火墙
echo -e "\n9.关闭防火墙..."
systemctl stop firewalld
systemctl disable firewalld
systemctl status firewalld --no-pager

#10.获取本机IP
IP=$(hostname -I | awk '{print $1}')
echo -e "\n========================部署完成===================="
echo -e "访问地址：\033[32m http://$IP \033[0m"
echo "Nginx状态：systemctl status nginx"
echo "重启命令：systemctl restart nginx"







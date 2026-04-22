#!/bin/bash
#用于自动化安装MySQL8.0,适用于CentOS7/8
#功能：一键安装、初始化数据库、修改密码、开启远程访问

#检查是否为root
if [ UID -ne 0 ]; then;
	echo "Error:必须使用root用户执行!"
	exit 1
fi

#关闭防火墙，关闭SELinux,避免权限拦截
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

#卸载自带的mariadb，并删除残留数据与配置
yum remove -y mariadb-server mariadb
rm -f /var/lib/mysql/*
rm -f /etc/my/cnf

#安装依赖（wget下载工具/网络访问工具/数据库依赖
yum install -y wget net-tools libaio-devel

#下载MySQL8.0
wget https://dev.mysql.com/get/mysql80-community-release-el8-3.noarch.rpm
rpm -ivh mysql80-community-release-el8-3.noarch.rpm

#安装MySQL
yum install -y mysql-community-server --nogpgcheck

#启动&&开机自启mysql
systemctl start mysqld
systemctl enable mysqld

#获取初始密码
pwd=$(grep "temporary password" /var/log/mysqld.log | awk '{printf $NF}')

#无交互修改密码
mysql -uroot -p$pwd --connect-expired-password<<EOF
ALTER USER "root"@"localhost" IDENTIFIED BY "Root2026*";
create user "root"@"%" identified by "Root2026*";
grant all privileges on *.* to "root"@"%" with grant option;
flush privileges;
EOF

firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload

ip=$(hostname -I | awk "{print $1}")
echo "======================================="
echo "MySQL 8.0 自动部署完成"
echo "主机IP:$IP"
echo "用户名：root"
echo "密码：Root2026*"
echo "======================================="














#!/bin/bash
#配置yum仓库，导入密钥
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
#配置MySQL的yum仓库
rpm -Uvh http://repo.mysql.com//mysql57-community-release-el7-7.noarch.rpm
#配置依赖
#1.先安装EPEL扩展源
dnf install -y epel-release
#2.安装兼容库，补齐缺少的so.5文件
dnf install -y ncurses-compat-libs
#3.临时跳过GPG校验，重新安装
dnf install -y mysql-community-server –nogpgcheck

#安装完成后，查看mysql的版本
mysql --version

#查看mysql的状态
systemctl status mysqld
#启动mysql,并设置为开机自启动
systemctl start mysqld
systemctl enable mysqld

#查看root的临时密码
cat /var/log/mysqld.log | grep "temporary password"
echo "最后几位是临时密码"

#登录root用户
mysql -uroot -p

echo "将刚刚复制的密码粘贴即可"

#!/bin/bash
#本程序用于在CentOS Stream 9操作系统上部署MySQL-8.x

#配置yum仓库，先导入密钥
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
#配置MySQL的yum仓库
dnf install -y https://dev.mysql.com/get/mysql80-community-release-el9-3.noarch.rpm

#使用dnf安装MySQL
dnf install -y mysql-community-server

#安装完成之后，查看版本号，并查看状态，设置为开机自启动
mysql --version
echo "当出现8.x,说明版本安装正确"

systemctl status mysqld
systemctl start mysqld
systemctl enable mysqld

#查看临时密码
cat /var/log/mysqld.log | grep "temporary password"

#看到临时密码之后复制一下，登录root账户
mysql -u root -p

#登录进去之后可以进行密码修改

#查看mysql绑定的端口号,mysql默认绑定端口为3306
netstat -anp | grep 3306


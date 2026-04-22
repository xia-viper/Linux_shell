#!/bin/bash
#本程序用于删除安装的mysql-5.7
#先停止mysql
systemctl stop mysqld
# 卸载所有 MySQL 包
rpm -qa | grep mysql | xargs rpm -e --nodeps
#删除残余配置文件
rm -rf /etc/my.cnf
rm -rf /etc/my.cnf.d/
rm -rf /var/lib/mysql
rm -rf /var/log/mysqld.log

#删除旧的el7源
rpm -e mysql57-community-release-el7-7

#查看是否清除完成
# 列出本机所有mysql相关安装包
rpm -qa | grep -i mysql
# 如果还有残存的数据包，强制执行全部卸载
rpm -qa | grep -i mysql | xargs rpm -e --nodeps

echo "若完成以上操作，请继续安装其他版本mysql"

#!/bin/bash

#定义源目录和目的目录
source_dir="/home/xcx/data"
backup_dir="/home/xcx/backup"

#备份目录不存在就自动创建，我已提前创建好
mkdir -p "$backup_dir"

#生成带日期的备份文件名（格式：年月日_时分_备份.tar.gz）
data_str=$(date +%Y%m%d_%H%M)
backup_name="${date_str}_备份.tar.gz"
backup_path="${backup_dir}/${backup_name}"

#打包压缩源目录
tar -zcf "$backup_path" "$source_dir"

#判断备份结果、打印提示
if [ $? -eq 0 ]; then
	echo "备份成功"
	echo "备份文件完整路径：$backup_path"

else
	echo "备份失败，请检查目录权限"
fi

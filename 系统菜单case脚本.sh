#!/bin/bash
while true
do
	echo "========系统工具栏========"
	echo "1.查看系统时间"
	echo "2'查看磁盘占用"
	echo "3.查看内存占用"
	echo "4.查看当前所在目录"
	echo "q.退出"
	read -p "请输入选择: " opt

	case $opt in
		1)date;;
		2)df -h;;
		3)free -h;;
		4)pwd;;
		q|Q)echo "退出程序";exit 0;;
		*)echo "输入错误，请重新输入!"
	esac
done

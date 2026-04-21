#!/bin/bash

read -p "请输入你的分数： " score

if [[ ! $score =~ ^[0-9]+$ ]]; then
	echo "输入错误：请输入数字!"
fi

case $score in
	9[0-9]|100)
		echo "优秀"
		;;
	8[0-9])
		echo "良好"
		;;
	6[0-9]|7[0-9])
		echo "及格"
		;;
	[0-5][0-5])
		echo "不及格"
		;;
	*)
		echo "输入错误，请输入一个正确的分数！"
		;;
esac

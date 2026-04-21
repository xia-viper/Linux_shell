#!/bin/bash
while true
do
	read -p "请输入一个整数：" num
#过滤不合法输入
	if ! [[ "$num" =~ ^-?[0-9]+$ ]]; then
		echo "输入不合法,请输入纯整数！"
		continue
	fi
	if [ "$num" -eq 0 ]; then
		echo "程序退出"
		break
	fi
	if [ $((num % 2)) -eq 0 ]; then
		echo "$num 是偶数"
	else
		echo "$num 是奇数"
	fi
done


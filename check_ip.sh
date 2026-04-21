#!/bin/bash

echo "=======批量检测主机存活状态==========="

for i in {1..20}
do
	ip="192.168.1.$i"

	ping -c 1 -W 1 "$ip" > /dev/null 2>&1

	if [ $? -eq 0 ]; then
		echo "【在线】$ip"
	else
		echo "【不在线】$ip"
	fi
done
echo "全部检测完毕"

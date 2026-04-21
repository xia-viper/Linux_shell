#!/bin/bash
echo "================打印1-100所有数字============="
for i in {1..100}
do
	echo "$i"
done

echo -e "\n===========1-100奇数========="
for i in {1..100}
do 
	if [ $((i%2)) -eq 1 ]; then
		echo "$i"
	fi
done

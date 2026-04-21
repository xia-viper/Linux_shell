#!/bin/bash
dir="/home/xcx/test"
mkdir -p $dir

for i in {1..10}
do
	touch "$dir/test$i.txt"
done

echo "成功在$dir目录下创建10个文本文件"

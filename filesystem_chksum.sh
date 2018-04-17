#!/bin/bash

s_dir="/home/source_dir"
t_dir="/mnt/testvol"

while :
do
	filename="test-"`date +"%H-%M-%S"`

	dd if=/dev/urandom of=$s_dir/$filename bs=1024k count=128 oflag=direct
	sync
	dd if=$s_dir/$filename of=$t_dir/$filename bs=1024k oflag=direct
	cp $s_dir/$filename $t_dir
	sync

	s_hash=`md5sum $s_dir/$filename`
	s_hash=${s_hash%$s_dir/$filename}
	t_hash=`md5sum $t_dir/$filename`
	t_hash=${t_hash%$t_dir/$filename}

	if [ "$t_hash" = "$s_hash" ]; then
		echo "hash ok"
	else
		echo "hash not ok"
	fi

	sync
	sleep 5

done

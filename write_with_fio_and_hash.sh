#!/bin/bash

block="/dev/sdb1"
mnt="/mnt/test"
fs="ext4"
numjobs=32

while :
do
	mount -t $fs $block $mnt

	filename="test-"`date +"%H-%M-%S"`

	if [ $(($RANDOM%2)) -eq 0 ]; then
		io="write"
	else
		io="randwrite"
	fi

	file_size=$((${RANDOM} + 128))

	if [ $(($RANDOM%2)) -eq 0 ]; then
		file_byte="kb"
	else
		file_byte="mb"
	fi

	block_size=$((${RANDOM} %1020 + 4))"kb"

	fio --name=$filename --filename=$mnt/$filename --rw=$io --size=$file_size$file_byte --bs=$block_size --numjobs=$numjobs --group_reporting
	sync

	old_hash=`md5sum $mnt/$filename`
	umount $mnt

	mount -t $fs $block $mnt
	new_hash=`md5sum $mnt/$filename`
	umount $mnt

	if [ "$old_hash" = "$new_hash" ]; then
		echo "hash ok"
		echo "hash ok - "$filename >> hash_result
	else
		echo "hash not ok"
		echo "hash not ok - "$filename >> hash_result
	fi

	sync
	sleep 10
	umount $mnt

done

#!/bin/bash
#
# File Name : chp_dd_write.sh
# Description : dd write script
#

test_dir="/mnt/test"
bs="1024k"
count=100

while :
do
  filename="node1-"`date +"%T"`
  dd if=/dev/zero of="$test_dir"/"$filename" bs=$bs count=$count
	sleep 1
  RETVAL=$?
    if [ $RETVAL != 0 ]; then
      echo "======================="
      echo "dd failed"
      echo "======================="
    else
      echo "======================="
      echo "dd success"
      echo "======================="
    fi
	sleep 5
	sync
done

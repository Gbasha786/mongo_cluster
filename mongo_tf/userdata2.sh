#!/bin/bash
function test
{
    value=$(df -h |grep /dev/xvdb)
    echo $?
}
result="1"

while [ $result -eq 1 ]
do
DEVICE=/dev/xvdb
MOUNT_POINT=/data
echo "Creating file system on $DEVICE"
mkfs -t ext4 $DEVICE
mkdir $MOUNT_POINT
mount $DEVICE $MOUNT_POINT
result=$(test)
echo $result
sleep 15
done

hostname mongo-1b
echo '127.0.0.1 mongo-1b' | sudo tee -a /etc/hosts
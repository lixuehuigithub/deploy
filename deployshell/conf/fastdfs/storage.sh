#!/bin/sh
sed -i "s/Master1_IP/$Master1_IP/gi" /etc/fdfs/storage.conf
sed -i "s/Master2_IP/$Master2_IP/gi" /etc/fdfs/storage.conf




cd /etc/fdfs
touch mime.types

/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
tail -f /data/fastdfs/storage/logs/storaged.log 

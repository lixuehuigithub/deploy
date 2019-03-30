#!/bin/sh
/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
sleep 2
tail -f /data/fastdfs/tracker/logs/trackerd.log



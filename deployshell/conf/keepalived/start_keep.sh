#!/bin/bash
while true
do
	nzt=$(ps -ef |grep nginx|grep -v grep|wc -l)
	rzt=$(ps -ef |grep redis-server|grep -v grep|wc -l)
	if [ "$nzt" -ge 1  -a "$rzt" -ge 1 ];then
		echo `date +'%Y-%m-%d %H:%M:%S'`":####### start keepalived ###########" >>/var/log/start_keep.log
       		systemctl start  keepalived
        	sleep 3
        	kzt=$(ps -ef |grep keepalived|grep -v grep|wc -l)
		if [ $kzt -ge 1 ];then
			echo `date +'%Y-%m-%d %H:%M:%S'`":####### keepalived stared ########" >>/var/log/start_keep.log
			exit 0
		fi
	fi
	sleep 10

done
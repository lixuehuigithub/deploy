#!/bin/bash
nzt=$(ps -ef |grep nginx|grep -v grep|wc -l)
rzt=$(ps -ef |grep redis-server|grep -v grep|wc -l)
if [ "$nzt" -lt 1  -o "$rzt" -lt 1 ];then
	systemctl stop  keepalived
	sleep 3
	kzt=$(ps -ef |grep keepalived|grep -v grep|wc -l)
	if [ "${kzt}" -ge 1  ];then
		ps -ef |grep keepalived |grep -v grep|awk '{print $2}'|xargs kill -9
	fi
fi

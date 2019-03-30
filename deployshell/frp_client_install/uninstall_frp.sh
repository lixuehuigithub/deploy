#!/bin/bash
frp_dir=/usr/local/frp_client
# kill  frp 
frp_pids=`ps -ef|grep frpc|awk 'NR==1{print $2}'`
for  frp_pid  in $frp_pids
do 
    kill -9 $frp_pid 
done
echo " frpc was killed "
# remove frp client directory
if [ -d $frp_dir ];then
    rm  -rf $frp_dir
fi
echo "frpc dir  was removed"
# remove frpc.server
systemctl disable frpc.service
rm  -rf /etc/systemd/system/frpc.service
echo "exec: systemctl disable frpc.service"
echo "remove /etc/systemd/system/frpc.service"

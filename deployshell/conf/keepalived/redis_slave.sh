#!/bin/bash
#


basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=/home/deploy-shell
DATA_PATH=$(cat $parentBasePath/docker.conf | grep "DATA_PATH" | awk -F '=' '{print $2}')
REDIS_PASSWORD=$(cat $parentBasePath/docker.conf | grep "BB_REDIS_PASSWORD" | awk -F '=' '{print $2}')
installPath=/usr/local

IPS=$(cat $parentBasePath/double.conf| grep "Master=" | awk -F '=' '{print $2}')
IPARR=(${IPS//,/ })
ipAddr=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
Master_1=$(cat $parentBasePath/double.conf | grep "Master1_ip=" | awk -F '=' '{print $2}')
Master_2=$(cat $parentBasePath/double.conf | grep "Master2_ip=" | awk -F '=' '{print $2}')
DOUBLE_CONF=${parentBasePath}/double.conf
redis_pass=$(cat $parentBasePath/docker.conf |grep "BB_REDIS_PASSWORD"|awk -F "=" '{print $2}')
redis_port=6379



stop_slave(){
for ip in ${IPARR[@]}
do
result=$(echo $ipAddr | grep "${ip}")
if [ -n  "${result}" ];then
	echo `date +'%Y-%m-%d %H:%M:%S'`": stop master slave "
	docker exec -i bbox_redis bash -c "redis-cli -p ${redis_port} -a ${redis_pass} slaveof no one"
else
	sleep 3	

fi
done
}
#
sed_master(){
for ip in ${IPARR[@]}
do
result=$(echo $ipAddr | grep "${ip}")
if [ -n  "${result}" ];then
        sed -i -r "/REDIS_MASTER_IP/s/=.*/=${ip}/g" ${DOUBLE_CONF}
        
else    
	sleep 3
fi
done
}
#
create_master(){
for ip in ${IPARR[@]}
do
result=$(echo $ipAddr | grep "${ip}")
if [ -n  "${result}" ];then
	sleep 3
else    
    echo `date +'%Y-%m-%d %H:%M:%S'`": create new master slave "
    master_ip=$(cat ${DOUBLE_CONF}|grep "REDIS_MASTER_IP="|awk -F '=' '{print $2}')
    sleep 3
    ssh root@${ip} "docker exec -i bbox_redis bash -c 'redis-cli -p ${redis_port} -a ${redis_pass} slaveof no one"
    ssh root@${ip} "docker exec -i bbox_redis bash -c 'redis-cli -p ${redis_port} -a ${redis_pass} slaveof ${master_ip} ${redis_port}'"
fi
done
}
#
stop_slave
sleep 3
sed_master
sleep 3
create_master

#!/bin/sh
basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=$( cd $basePath/.. && pwd )
DATA_PATH=$(cat $parentBasePath/docker.conf | grep "DATA_PATH" | awk -F '=' '{print $2}')
REDIS_PASSWORD=$(cat $parentBasePath/docker.conf | grep "LEE_REDIS_PASSWORD" | awk -F '=' '{print $2}')
installPath=/usr/local

loadImageMirro(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start import redis docker images..."
    docker load -i $parentBasePath/images/bbox_redis_prod.tar 
    echo `date +'%Y-%m-%d %H:%M:%S'`": Endded import redis docker images..."
}

createContainer(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start create redis container of docker .."
   # --env-file 加载环境变量 第一个 -v 挂载jar 第二个-v挂载日志
   docker create --name bbox_redis --restart=always --cpus=1 --memory=1G --net host -v /etc/localtime:/etc/localtime:ro -v ${DATA_PATH}:/data bbox_redis:prod redis-server --appendonly yes   --requirepass "$REDIS_PASSWORD"
   sleep 2
   
   docker start bbox_redis
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endded create redis container of docker .."
}

#Main function
loadImageMirro
sleep  5
createContainer

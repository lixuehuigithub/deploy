#!/bin/sh
basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=$( cd $basePath/.. && pwd )
BB_RABBITMQ_USERNAME=$(cat $parentBasePath/docker.conf | grep "LEE_RABBITMQ_USERNAME" | awk -F '=' '{print $2}')
BB_RABBITMQ_PASSWORD=$(cat $parentBasePath/docker.conf | grep "LEE_RABBITMQ_PASSWORD" | awk -F '=' '{print $2}')
installPath=/usr/local


loadImageMirro(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start import bbox_rabbitmq docker images..."
    docker load -i $parentBasePath/images/bbox_rabbitmq_prod.tar 
    echo `date +'%Y-%m-%d %H:%M:%S'`": Endded import bbox_rabbitmq docker images..."
}

createContainer(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start create bbox_rabbitmq container of docker .."
   # --env-file 加载环境变量 第一个 -v 挂载jar 第二个-v挂载日志
   docker create --name bbox_rabbitmq --restart=always --net host --env-file $parentBasePath/docker.conf -v /etc/localtime:/etc/localtime:ro -e RABBITMQ_DEFAULT_USER=$LEE_RABBITMQ_USERNAME -e RABBITMQ_DEFAULT_PASS=$LEE_RABBITMQ_PASSWORD bbox_rabbitmq:prod
   sleep 5
   
   docker start bbox_rabbitmq
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endded create bbox_rabbitmq container of docker .."
}

InitRabbitmq(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start create opnext-server rabbitmq of docker .."
	docker cp  $parentBasePath/sql/InitRabbitmq.sh  bbox_rabbitmq:/home
	sleep 5
	docker exec bbox_rabbitmq sh /home/InitRabbitmq.sh
	echo `date +'%Y-%m-%d %H:%M:%S'`": Start create opnext-server rabbitmq of docker .."
}
#Main function
loadImageMirro
sleep 10
createContainer
sleep 10
InitRabbitmq

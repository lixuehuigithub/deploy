#!/bin/sh
basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=$( cd $basePath/.. && pwd )
DATA_PATH=$(cat $parentBasePath/docker.conf | grep "DATA_PATH" | awk -F '=' '{print $2}')
installPath=/usr/local


loadImageMirro(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start import mongo docker images..."
    docker load -i $parentBasePath/images/bbox_mongo_prod.tar 
    echo `date +'%Y-%m-%d %H:%M:%S'`": Endded import mongo docker images..."
}

createContainer(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start create mongo container of docker .."
   # --env-file 加载环境变量 第一个 -v 挂载jar 第二个-v挂载日志
   docker create --name bbox_mongo --restart=always --net host --cpus=5 --memory=5G --env-file $parentBasePath/docker.conf -v /etc/localtime:/etc/localtime:ro -v ${DATA_PATH}/mongo:/data -v ${DATA_PATH}/mongo/db:/data/db  bbox_mongo:prod
   sleep 2
   docker start bbox_mongo
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endded create mongo container of docker .."
}
initDatabase(){
    echo  `date +'%Y-%m-%d %H:%M:%S'`": Start Init Mongo  database and  username/password of docker .."
	docker cp  $parentBasePath/sql/mongdatabase.sh  bbox_mongo:/home
	docker exec bbox_mongo sh /home/mongdatabase.sh
	echo  `date +'%Y-%m-%d %H:%M:%S'`": Ended Init Mongo  database and  username/password of docker .."
}

#Main function
loadImageMirro
sleep  5
createContainer
sleep 5
initDatabase


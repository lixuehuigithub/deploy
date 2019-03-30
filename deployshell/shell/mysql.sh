#!/bin/sh
basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=$( cd $basePath/.. && pwd )
DATA_PATH=$(cat $parentBasePath/docker.conf | grep "DATA_PATH" | awk -F '=' '{print $2}')
LOG_PATH=$(cat $parentBasePath/docker.conf | grep "LOG_PATH" | awk -F '=' '{print $2}')
MYSQL_ROOT_PASSWORD=$(cat $parentBasePath/docker.conf | grep "LEE_MYSQL_PASSWORD" | awk -F '=' '{print $2}')

loadImageMirro(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start import bbox_mysql docker images..."
    docker load -i $parentBasePath/images/bbox_mysql_prod.tar 
    echo `date +'%Y-%m-%d %H:%M:%S'`": Endded import bbox_mysql docker images..."
}

settingsMysqlConfig(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start configure MYSQL  conf..."
	if [ ! -d /etc/conf ];then
	    mkdir -p /etc/conf
	fi
	cp -r $parentBasePath/conf/mysql/my.cnf /etc/conf/
	chmod -R 755  /etc/conf
	echo `date +'%Y-%m-%d %H:%M:%S'`": Ended configure MYSQL  conf..."
}
createContainer(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start create bbox_mysql container of docker .."
   docker create --name bbox_mysql --restart=always --net host --env-file $parentBasePath/docker.conf -v /etc/localtime:/etc/localtime:ro -v /etc/conf:/etc/mysql/conf.d -v $LOG_PATH/mysql:/var/log/mysql -v ${DATA_PATH}/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD='123456' bbox_mysql:prod
   sleep 10
   
   docker start bbox_mysql
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endded create bbox_mysql container of docker .."
}

executeSql(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start excute mysql database sql shell"
    docker cp $basePath/InitDataBases.sh bbox_mysql:/home
   # docker cp  $parentBasePath/package/sql  bbox_mysql:/home


	sleep 60
	docker exec bbox_mysql sh /home/InitDataBases.sh
	echo `date +'%Y-%m-%d %H:%M:%S'`": Ended excute mysql database sql shell"

}
#Main function
loadImageMirro
sleep  10
settingsMysqlConfig
sleep 10
createContainer
sleep 10
executeSql


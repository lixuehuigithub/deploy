#!/bin/sh
basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=$( cd $basePath/.. && pwd )
installPath=/usr/local

installLocalService(){
   
	echo `date +'%Y-%m-%d %H:%M:%S'`": Start cp algorithm-service file .."
	if [ ! -d $installPath/consul ];then
	    cp -r $parentBasePath/software/consul  $installPath/
		chmod 755  $installPath/consul
                 chmod 755  $installPath/consul/*
	fi
	echo `date +'%Y-%m-%d %H:%M:%S'`": Ended cp algorithm-service file .."
}

 
createContainer(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start install docker environment.."/
   docker create --name consul --restart=always --env-file $parentBasePath/docker.conf --net host -v /etc/localtime:/etc/localtime:ro -v $installPath/consul:/usr/local/consul java8:v1 sh /usr/local/consul/start.sh
   sleep 2
   
   docker start consul
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endding install docker environment.."
}

#Main function
installLocalService
createContainer

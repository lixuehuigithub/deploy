#!/bin/sh
basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=$( cd $basePath/.. && pwd )
LOG_PATH=$(cat $parentBasePath/docker.conf | grep "LOG1_PATH_NGINX" | awk -F '=' '{print $2}')
installPath=/usr/local

loadImageMirro(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start import nginx docker images..."
    docker load -i $parentBasePath/images/openresty_prod.tar 
    echo `date +'%Y-%m-%d %H:%M:%S'`": Endded import nginx docker images..."
}

loadWebPage(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start unzip file ..."
    if [ ! -d $installPath/oms-web ];then
	    mkdir -p $installPath/oms-web
	fi
	if [ ! -d $installPath/opnext-web ];then
	    mkdir -p $installPath/opnext-web
	fi

#	if [ ! -d $installPath/bbox-visitor-web ];then
#	    mkdir -p $installPath/bbox-visitor-web 
#	fi
	
	if [ ! -d $installPath/saas-user-center ];then
	    
		mkdir -p $installPath/saas-user-center
	fi

#	if [ ! -d $installPath/bbox-VSM ];then
#
#                mkdir -p $installPath/bbox-VSM
#        fi


#       if [ ! -d $installPath/bbox-wechat-web ];then
#            mkdir -p $installPath/bbox-wechat-web
#        fi
#	cp -r $parentBasePath/package/opnext-web.zip $installPath/opnext-web
#	cp -r $parentBasePath/package/oms-web.zip $installPath/oms-web
#	cp -r $parentBasePath/package/bbox-visitor-web.zip $installPath/bbox-visitor-web
#	cp -r $parentBasePath/package/saas-user-center.zip $installPath/saas-user-center
#	cp -r $parentBasePath/package/bbox-VSM.zip $installPath/bbox-VSM
#   cp -r $parentBasePath/package/bbox-wechat-web.zip $installPath/bbox-wechat-web
	
	cp -r $parentBasePath/package/web-saas*.zip $installPath/opnext-web
#	cp -r $parentBasePath/package/web-store*.zip $installPath/oms-web
#	cp -r $parentBasePath/package/web-visitor-reception*.zip $installPath/bbox-visitor-web
	cp -r $parentBasePath/package/web-h5-user-center*.zip $installPath/saas-user-center
#	cp -r $parentBasePath/package/web-visitor-admin*.zip $installPath/bbox-VSM
#   cp -r $parentBasePath/package/web-visitor-wechat*.zip $installPath/bbox-wechat-web
	sleep 7
	
	sleep 2

	unzip $installPath/opnext-web/web-saas*.zip -d $installPath/opnext-web >>/dev/null
#	unzip $installPath/oms-web/web-store*.zip -d $installPath/oms-web >>/dev/null
#	unzip $installPath/bbox-visitor-web/web-visitor-reception*.zip -d $installPath/bbox-visitor-web>>/dev/null	
	unzip $installPath/saas-user-center/web-h5-user-center*.zip -d $installPath/saas-user-center>>/dev/null
#	unzip $installPath/bbox-VSM/web-visitor-admin*.zip -d $installPath/bbox-VSM >>/dev/null
#	unzip $installPath/bbox-wechat-web/web-visitor-wechat*.zip -d $installPath/bbox-wechat-web >>/dev/null 	
	
        sleep 2

	chmod -R 755 $installPath/opnext-web
#	chmod -R 755 $installPath/oms-web
	chmod -R 755 $installPath/bbox-visitor-web	
#	chmod -R 755 $installPath/saas-user-center
#	chmod -R 755 $installPath/bbox-VSM
#	chmod -R 755 $installPath/bbox-wechat-web
		
	echo `date +'%Y-%m-%d %H:%M:%S'`": Ended unzip file ..."
}

loadNginxConfig(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start load nginx file ..."
	if [ ! -d /etc/nginx/conf.d ];then
	   mkdir -p /etc/nginx/conf.d
	fi
	cp -r $parentBasePath/conf/nginx/* /etc/nginx/conf.d
	chmod -R 755 /etc/nginx
}
createContainer(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start create bbox_nginx container of docker .."
   # --env-file 加载环境变量 第一个 -v 挂载jar 第二个-v挂载日志
   docker create --name bbox_nginx --restart=always --net host -v /etc/localtime:/etc/localtime:ro -v $LOG_PATH:/var/log/nginx -v /etc/nginx/conf.d/:/etc/nginx/conf.d/ -v $installPath/opnext-web:$installPath/opnext-web -v $installPath/bbox-visitor-web:$installPath/bbox-visitor-web -v $installPath/bbox-VSM:$installPath/bbox-VSM -v $installPath/saas-user-center:$installPath/saas-user-center -v $installPath/oms-web:$installPath/oms-web -v $installPath/bbox-wechat-web:$installPath/bbox-wechat-web  openresty:prod
   sleep 2
   
   docker start bbox_nginx
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endded create bbox_nginx container of docker .."
}


updataContainer(){
        docker_Container=`docker ps -a |grep nginx |awk '{print $1}'`
        if [ -n "$docker_Container" ]; then
                        docker rm -f $docker_Container
            rm -rf  $installPath/opnext-web
            rm -rf  $installPath/oms-web

            rm -rf   $installPath/bbox-visitor-web
            rm -rf  $installPath/saas-user-center
            rm -rf $installPath/bbox-VSM
#   	    rm -rf $installPath/bbox-wechat-web
        fi
}

#Main function
updataContainer
sleep 3
loadImageMirro
sleep  5
loadWebPage
loadNginxConfig
createContainer


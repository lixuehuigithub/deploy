#!/bin/sh

basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
parentBasePath=$( cd $basePath/.. && pwd )

installPath=/usr/local

if [ ! -n "$1" ] ;then
    echo "you have not input a agrs!"
	exit 1
else
   	 sed -i "s/ceshi01/$1/g" $parentBasePath/conf/frp/frpc_https.ini


	 sed -i "s/ceshi01/$1/g" $parentBasePath/conf/nginx/wechat.conf

	 sed -i "s/ceshi01/$1/g" $parentBasePath/docker.conf
         
         sed -i "s/ceshi01/$1/g"  $parentBasePath/frp_client_install/frpc.conf

fi

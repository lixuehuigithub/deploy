#!/bin/sh
basePath=$(cd "$( dirname "$0")" && pwd)
parentBasePath=$( cd $basePath/.. && pwd )
INSTALLPATH=/usr/local
wx=$(grep subdomain ${parentBasePath}/opnext.conf | sed -n 1p |awk -F\= '{print $2}')
https=$(grep https ${parentBasePath}/opnext.conf | sed -n 1p |awk -F\= '{print $2}')
http_port=$(grep http_port ${parentBasePath}/opnext.conf | sed -n 1p |awk -F\= '{print $2}')
https_port=$(grep https_port ${parentBasePath}/opnext.conf | sed -n 1p |awk -F\= '{print $2}')
base_url=$(grep BB_WECHAT_DOMAIN ${parentBasePath}/docker.conf | sed -n 1p |awk -F\= '{print $2}'| awk -F '.' '{print $(2)"."$(3)"."$(4)}')
#modify weixin frp domain
sed -i -r "/BB_GATEWAY_DOMAIN/s/=.*/=${wx}.${base_url}/g" ${parentBasePath}/docker.conf
sed -i -r "/BB_SERVICE_DOMAIN/s/=.*/=${wx}.${base_url}/g" ${parentBasePath}/docker.conf
sed -i -r "/BB_VISITOR_DOMAIN/s/=.*/=${wx}.${base_url}/g" ${parentBasePath}/docker.conf

echo "****** subdomain value  ${wx}*********"
sleep 2
if [ "${wx}" == "beeboxes" ]; then
   echo "Subdomain cannot be  beeboxes  "
   exit 1
fi
if [  -n "${wx}" ]; then 

  echo "***copy frp to ${INSTALLPATH}**************" 
  tar -zxf ${basePath}/frp_client.tar.gz -C ${INSTALLPATH}/
  echo "***copy  frp successed"
  chmod u+x ${INSTALLPATH}/frp_client/frpc
 # make frpc.ini file 
  if [ "${https}" == "true" ]; then
     yes | cp -f ${INSTALLPATH}/frp_client/frpc_https.ini ${INSTALLPATH}/frp_client/frpc.ini 
	 http_var=https
  else
     yes | cp -f ${INSTALLPATH}/frp_client/frpc_http.ini ${INSTALLPATH}/frp_client/frpc.ini
     http_var=http
  fi
  sed -i "s/wx/${wx}/g"  ${INSTALLPATH}/frp_client/frpc.ini
  sed -i "s/80/${http_port}/g" ${INSTALLPATH}/frp_client/frpc.ini
  if [ "${https}" == "true" ]; then
     sed -i "s/443/${https_port}/g"  ${INSTALLPATH}/frp_client/frpc.ini
  fi
  echo "configure frpc service"
  cp ${basePath}/service/frpc.service /etc/systemd/system
  chmod +x /etc/systemd/system/frpc.service
  echo "running frpc"
  
  systemctl daemon-reload
  systemctl enable frpc.service
  systemctl start frpc.service  
  sleep 1
  pidFrp=`ps -ef|grep frpc.ini|grep -v grep|awk '{print $2}'`
  if [ -n "$pidFrp" ]; then
    echo "frpc is running!"
  else
    echo "frpc is not running!"
    cd ${INSTALLPATH}/frp_client
    setsid ./frpc  -c ./frpc.ini &
    echo "cd ${INSTALLPATH}/frp_client;setsid ./frpc  -c ./frpc.ini &" >> /etc/rc.local
    /usr/bin/chmod +x /etc/rc.local
  fi
  echo "****frp client started********* "
else  
  echo "Please fill in the subdomain value, in the configuration file frpc.conf"  
fi    

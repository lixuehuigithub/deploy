#!/bin/sh
basePath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INSTALL_ONLINE_DOCKER=$(cat $basePath/opnext.conf | grep "install_online_docker" | awk -F '=' '{print $2}')

echo `date +'%Y-%m-%d %H:%M:%S'`": This is docker.sh ..."

createLoaclRepo(){
  echo "create local yum repo"
  rpm --nodeps -i ${basePath}/software/yum/libxml2-python-2.9.1-5.el7_0.1.x86_64.rpm --force
  rpm --nodeps -i ${basePath}/software/yum/deltarpm-3.6-3.el7.x86_64.rpm --force
  rpm --nodeps -i ${basePath}/software/yum/python-deltarpm-3.6-3.el7.x86_64.rpm --force
  rpm --nodeps -i ${basePath}/software/yum/createrepo-0.9.9-23.el7.noarch.rpm --force
  if [ -d "/etc/yum.repos.d-bak" ]; then
    rm -rf /etc/yum.repos.d
  else 
    mv /etc/yum.repos.d /etc/yum.repos.d-bak
  fi
  mkdir /etc/yum.repos.d
  cp ${basePath}/software/docker.repo /etc/yum.repos.d/
  createrepo ${basePath}/software/yum/ &>> ${basePath}/docker.log
  yum clean all &>> ${basePath}/docker.log
  yum makecache &>> ${basePath}/docker.log
}

installExpect(){
    echo `date +'%Y-%m-%d %H:%M:%S'`" Start install expect ..."
	yum -y install expect expect-devel tcl
    echo `date +'%Y-%m-%d %H:%M:%S'`" Ended install expect ..."
}

installDocker(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start install docker environment.."
   yum -y install docker-io
   sleep 5
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endding install docker environment.."
}

settingDockerConf(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start install docker configure ..."
    mv  /etc/docker/daemon.json /etc/docker/daemon.json_bak
    cp ${basePath}/software/daemon.json /etc/docker
    mv /etc/sysconfig/docker /etc/sysconfig/docker_bak
    cp ${basePath}/software/docker /etc/sysconfig/
	systemctl start docker
	systemctl enable docker
    echo "Start add docker start image to rc.local .."
    echo "${basePath}/start.sh" >> /etc/rc.local
    /usr/bin/chmod +x /etc/rc.local
    echo "End add docker start image to rc.local .."
    echo `date +'%Y-%m-%d %H:%M:%S'`": Endding install docker configure ..."
}

settingDockerEvn(){
    echo  "reload docker  configure ..."
	sh $basePath/docker-data-env.sh
}
backyum(){
   echo `date +'%Y-%m-%d %H:%M:%S'`": Start recover yum  ..."
   rm -rf /etc/yum.repos.d
   mv  /etc/yum.repos.d-bak  /etc/yum.repos.d
   echo `date +'%Y-%m-%d %H:%M:%S'`": Endding recover yum  ..."
}

loadImageMirro(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": Start import java8_prod docker images..."
    docker load -i $basePath/images/java8_prod.tar
    echo `date +'%Y-%m-%d %H:%M:%S'`": Endded import java8_prod docker images..."
}
dockerVersion=$(rpm -qa|grep  docker)
#Main function
if [ -n "$dockerVersion" ];then
    echo `date +'%Y-%m-%d %H:%M:%S'`": docker evn already installed ..."
else
    if [ $INSTALL_ONLINE_DOCKER = "true" ];then
	    installDocker
    else    
	    createLoaclRepo
	    installDocker
	fi
	sleep 8
	settingDockerConf
	sleep 1
	#settingDockerEvn
	loadImageMirro
	if [ $INSTALL_ONLINE_DOCKER = "true" ];then
	   echo `date +'%Y-%m-%d %H:%M:%S'`": docker online install ..."
	else
	   backyum
	fi
	
fi









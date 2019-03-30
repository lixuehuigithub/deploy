#!/bin/sh
parentBasePath=/home

executeSql(){
    echo `date +'%Y-%m-%d %H:%M:%S'`": excute mysql user sql shell"
	USERNAME=root
	ROOTPASSWORD=123456
    
    del_user="delete from mysql.user where user='root' and host !='localhost'"
	user_create="CREATE USER IF NOT EXISTS '${LEE_MYSQL_USERNAME}'@'%' IDENTIFIED BY '$LEE_MYSQL_PASSWORD'"

	grant_db="GRANT ALL ON *.* TO '$LEE_MYSQL_USERNAME'@'%' IDENTIFIED BY '$LEE_MYSQL_PASSWORD' WITH GRANT OPTION"
    sleep 1
    
    echo "check mysql !!!"
	while true;
	do
	mysql -u${USERNAME} -p${ROOTPASSWORD} -e "show databases;"
        	if [ $? -eq 0 ];then
                	break;
        	else
                	sleep 5;
        	fi
	done

	mysql -u${USERNAME} -p${ROOTPASSWORD} -e "${user_create}" 2>/dev/null
	mysql -u${USERNAME} -p${ROOTPASSWORD} -e "${grant_db}" 2>/dev/null
	mysql -u${USERNAME} -p${ROOTPASSWORD} -e "${del_user}" 2>/dev/null
	mysql -u${USERNAME} -p${ROOTPASSWORD} -e "flush privileges" 2>/dev/null

	echo "**********end create user***********"

}
#Main function
executeSql



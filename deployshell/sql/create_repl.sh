#!/bin/bash
MYSQL_ROOT_PASSWORD=123456
MAST_USER=repl
MAST_PASS=SaaS123.com
MAST_PORT=3306


while true;
do
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "show databases;"
	if [ $? -eq 0 ];then
		break;
	else
		sleep 5;
	fi
done

del_user="delete from mysql.user where user='root' and host !='localhost'"
user_create="CREATE USER IF NOT EXISTS '${MAST_USER}'@'%' IDENTIFIED BY '$MAST_PASS'"
grant_db="grant replication slave on *.* TO '${MAST_USER}'@'%' IDENTIFIED BY '${MAST_PASS}'"

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "${user_create}"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "${grant_db}"
#mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "${del_user}"

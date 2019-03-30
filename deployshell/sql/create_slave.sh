#!/bin/bash
SLAVE_IP=ip
MYSQL_ROOT_PASSWORD=123456
MAST_USER=repl
MAST_PASS=SaaS123.com
MAST_PORT=3306

change_master="change master to master_host='${SLAVE_IP}',master_user='${MAST_USER}',master_password='${MAST_PASS}',master_port=${MAST_PORT},master_auto_position=1"
slave_start="start slave"
slave_status="show slave status\G"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "${change_master}"
sleep 3
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "${slave_start}"
sleep 3
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "${slave_status}"

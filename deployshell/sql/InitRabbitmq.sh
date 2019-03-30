#!/bin/bash

sleep 10
rabbitmqctl add_vhost LEE-server
sleep 10
rabbitmqctl set_permissions -p LEE-server  ${LEE_RABBITMQ_USERNAME}  '.*' '.*' '.*'
sleep 10
rabbitmq-plugins enable rabbitmq_delayed_message_exchange


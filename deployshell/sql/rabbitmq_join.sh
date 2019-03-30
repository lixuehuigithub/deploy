#!/bin/bash
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@rabbit1
#rabbitmqctl reset

rabbitmqctl start_app

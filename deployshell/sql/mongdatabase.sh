#!/bin/bash
mongo database --eval "db.createUser({user:\"$BB_MONGODB_USERNAME\",pwd:\"$BB_MONGODB_PASSWORD\",roles:[\"dbAdmin\"]})"

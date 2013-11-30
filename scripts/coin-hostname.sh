#!/bin/sh

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "HOSTNAME $now [INFO] Start"
hostname | awk '{print "HOSTNAME '$now'", $0}'

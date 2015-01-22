#!/bin/sh

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "MEMINFO $now [INFO] Start"
cat /proc/meminfo | awk '{print "MEMINFO '$now'", $0}'

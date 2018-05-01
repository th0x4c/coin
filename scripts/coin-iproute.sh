#!/bin/sh

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "IPROUTE $now [INFO] Start"
ip -s -s -d link | awk '{print "IPROUTE '$now'", $0}'

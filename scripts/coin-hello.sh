#!/bin/sh

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "HELLO $now [INFO] Start"
echo "hello, world" | awk '{print "HELLO '$now'", $0}'

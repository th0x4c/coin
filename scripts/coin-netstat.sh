#!/bin/sh

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "NETSTAT $now [INFO] Start"
netstat -a -i -n | awk '{print "NETSTAT '$now'", $0}'
netstat -s | awk '{print "NETSTAT '$now'", $0}'

case $(uname) in
  Linux)
    netstat -e -a -i -n | awk '{print "NETSTAT '$now'", $0}'
    ;;
  *)
    ;;
esac


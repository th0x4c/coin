#!/bin/sh

case $(uname) in
  Linux)
    PSAUX="ps aux"
    ;;
  HP-UX)
    PSAUX="env UNIX95= ps -A -o user,pid,pcpu,vsz,sz,tty,state,stime,time,args"
    ;;
  *)
    ;;
esac

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "PS-AUX $now [INFO] Start"
$PSAUX | awk '{print "PS-AUX '$now'", $0}'

#!/bin/sh

LANG=C
CNAME="TOP"

OPT_DELAY=""
OPT_COUNT=""

if [ -n "$1" ]
then
  OPT_DELAY="-d $1"
fi
if [ -n "$2" ]
then
  OPT_COUNT="-n $2"
fi

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "$CNAME $now [INFO] Start"

COMMAND="top -b -c $OPT_DELAY $OPT_COUNT"
$COMMAND | awk 'BEGIN{date = strftime("%Y-%m-%d"); \
                      split(strftime("%H:%M:%S"), timestamp, ":");} \
                /^top - [012][0-9]:[0-9][0-9]:[0-9][0-9]/{date = strftime("%Y-%m-%d"); \
                                                          split($3, timestamp, ":");} \
                {printf("'$CNAME' %sT%02d:%02d:%02d %s\n", date, \
                                                           timestamp[1], \
                                                           timestamp[2], \
                                                           timestamp[3], \
                                                           $0); \
                 system("");}' \
         | sed 's/ *$//'


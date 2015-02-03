#!/bin/sh

LANG=C
CNAME="MPSTAT"

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "$CNAME $now [INFO] Start"

COMMAND="mpstat -P ALL $@"
$COMMAND | awk 'BEGIN{date = strftime("%Y-%m-%d"); \
                      split(strftime("%H:%M:%S"), timestamp, ":");} \
                /^[012][0-9]:[0-9][0-9]:[0-9][0-9]/{date = strftime("%Y-%m-%d"); \
                                                    split($1, timestamp, ":"); \
                                                    if ($3 == "PM") {timestamp[1] += 12}; \
                                                    if ($3 == "AM" && timestamp[1] == 12) {timestamp[1] = 0}} \
                {printf("'$CNAME' %sT%02d:%02d:%02d %s\n", date, \
                                                           timestamp[1], \
                                                           timestamp[2], \
                                                           timestamp[3], \
                                                           $0); \
                 system("");}'

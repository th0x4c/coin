#!/bin/sh

LANG=C
CNAME="IOSTAT"

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "$CNAME $now [INFO] Start"

COMMAND="iostat -xk -t $@"
$COMMAND | awk 'BEGIN{date = strftime("%Y-%m-%d"); \
                      split(strftime("%H:%M:%S"), timestamp, ":");} \
                /Time:/{date = strftime("%Y-%m-%d"); \
                        split($2, timestamp, ":"); \
                        if ($3 == "PM") {timestamp[1] += 12}; \
                        if ($3 == "AM" && timestamp[1] == 12) {timestamp[1] = 0}} \
                {printf("'$CNAME' %sT%02d:%02d:%02d %s\n", date, \
                                                           timestamp[1], \
                                                           timestamp[2], \
                                                           timestamp[3], \
                                                           $0); \
                 system("");}'

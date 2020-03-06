#!/bin/sh

LANG=C
LC_ALL=C
CNAME="VMSTAT"

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "$CNAME $now [INFO] Start"

COMMAND="vmstat $@"
$COMMAND | awk '{printf("'$CNAME' %s %s\n", strftime("%Y-%m-%dT%H:%M:%S"), $0); system("");}'

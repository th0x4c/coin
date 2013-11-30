#!/bin/sh

TEMP_DIR=$(dirname $0)/../tmp
if [ ! -d $TEMP_DIR ]
then
  TEMP_DIR=/tmp
fi
TEMP_FILE=$TEMP_DIR/coin-vmstat.$$

vmstat 1 2 > $TEMP_FILE

lines=$(wc -l $TEMP_FILE | cut -d" " -f1)
lines=$(expr $lines - 2)

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "VMSTAT $now [INFO] Start"
head -n $lines $TEMP_FILE | awk '{print "VMSTAT '$now'", $0}'
tail -n 1 $TEMP_FILE | awk '{print "VMSTAT '$now'", $0}'
rm $TEMP_FILE


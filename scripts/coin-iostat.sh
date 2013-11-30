#!/bin/sh

TEMP_DIR=$(dirname $0)/../tmp
if [ ! -d $TEMP_DIR ]
then
  TEMP_DIR=/tmp
fi
TEMP_FILE=$TEMP_DIR/coin-iostat.$$

case $(uname) in
  Linux)
    HEADER="avg-cpu:"
    iostat -xk 1 2 > $TEMP_FILE
    ;;
  HP-UX)
    HEADER="  device"
    iostat 1 2 > $TEMP_FILE
    ;;
  *)
    ;;
esac

lines=$(wc -l $TEMP_FILE | cut -d" " -f1)
head=$(grep -n -E "^$HEADER" $TEMP_FILE | cut -d":" -f1 | tail -1)
lines=$(expr $lines - $head + 1)

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "IOSTAT $now [INFO] Start"
tail -n $lines $TEMP_FILE | awk '{print "IOSTAT '$now'", $0}'
rm $TEMP_FILE


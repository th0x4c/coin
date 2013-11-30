#!/bin/sh

TEMP_DIR=$(dirname $0)/../tmp
if [ ! -d $TEMP_DIR ]
then
  TEMP_DIR=/tmp
fi
TEMP_FILE=$TEMP_DIR/coin-top.$$

case $(uname) in
  Linux)
    HEADER="top -"
    top -b -c -n 2 -d 1 | sed 's/ *$//' > $TEMP_FILE
    ;;
  HP-UX)
    HEADER="System:"
    top -d 2 -s 1 -f $TEMP_FILE
    ;;
  *)
    ;;
esac

lines=$(wc -l $TEMP_FILE | cut -d" " -f1)
head=$(grep -n -E "^$HEADER" $TEMP_FILE | cut -d":" -f1 | tail -1)
lines=$(expr $lines - $head + 1)

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "TOP $now [INFO] Start"
tail -n $lines $TEMP_FILE | awk '{print "TOP '$now'", $0}'
rm $TEMP_FILE


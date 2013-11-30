#!/bin/sh

TEMP_DIR=$(dirname $0)/../tmp
if [ ! -d $TEMP_DIR ]
then
  TEMP_DIR=/tmp
fi
TEMP_FILE=$TEMP_DIR/coin-mpstat.$$

case $(uname) in
  Linux)
    HEADER="CPU"
    mpstat -P ALL 1 2 > $TEMP_FILE
    head=$(grep -n -E "$HEADER" $TEMP_FILE | cut -d":" -f1 | tail -2 | head -1)
    foot=$(grep -n -E "$HEADER" $TEMP_FILE | cut -d":" -f1 | tail -1)
    foot=$(expr $foot - 1)
    lines=$(expr $foot - $head + 1)
    ;;
  HP-UX)
    HEADER="%usr"
    sar -A -S 1 2 > $TEMP_FILE
    lines=$(wc -l $TEMP_FILE | cut -d" " -f1)    
    foot=$lines
    ;;
  *)
    ;;
esac

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "MPSTAT $now [INFO] Start"
head -n $foot $TEMP_FILE | tail -n $lines | awk '{print "MPSTAT '$now'", $0}'
rm $TEMP_FILE

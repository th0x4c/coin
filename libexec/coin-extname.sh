#!/bin/sh

INVERT=0

usage()
{
  cat <<EOF
Description:
    Return the extension

Usage: coin-extname.sh <path>

Option:
    -x, --invert    Output filename without the extension
    -h, --help      Output help

Example:
    coin-extname.sh test.sh             #=> sh
    coin-extname.sh /path/to/test.sh    #=> sh
    coin-extname.sh -x test.sh          #=> test
EOF
}

while [ $# -gt 0 ]
do
  case $1 in
    -x|--invert )
      INVERT=1
      shift
      ;;
    -h|--help )
      usage
      exit
      ;;
    * )
      break
      ;;
  esac
done

FILE_PATH=$1
if [ -z "$FILE_PATH" ]
then
  usage
  exit
fi

if [ $INVERT -eq 0 ]
then
  echo $FILE_PATH | sed 's/.*\.\(.*\)$/\1/'
else
  basename $FILE_PATH "."$($0 $FILE_PATH)
fi

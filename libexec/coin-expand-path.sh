#!/bin/sh

usage()
{
  cat <<EOF
Description:
    Convert a pathname to an absolute pathname

Usage: coin-expand-path.sh <path>

Option:
    -h, --help      Output help

Example:
    coin-expand-path.sh ./test.txt          #=> /path/to/test.txt
    coin-expand-path.sh ../../tmp           #=> /tmp
    coin-expand-path.sh ~user/test.txt      #=> /home/user/test.txt
EOF
}

while [ $# -gt 0 ]
do
  case $1 in
    -h|--help )
      usage
      exit
      ;;
    * )
      break
      ;;
  esac
done

PATH_NAME=$1
if [ -z "$PATH_NAME" ]
then
  usage
  exit
fi

if [ -d $PATH_NAME ]
then
  cd $PATH_NAME
  pwd
else
  dir=$(dirname $PATH_NAME)
  base=$(basename $PATH_NAME)

  cd $dir
  echo $(pwd)/$base
fi

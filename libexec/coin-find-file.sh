#!/bin/sh

AFTER_DATE=""
BEFORE_DATE=""
FILE_TYPE="f"
OUTPUT_DIR=""
DATE_FILE_DIR=$(dirname $0)/../tmp

if [ ! -d $DATE_FILE_DIR ]
then
  DATE_FILE_DIR=/tmp
fi

usage()
{
  cat <<EOF
Description:
    Find files with the specified timestamp

Usage: coin-find-file.sh [options] <dir>

Option:
    -a, --after-date <date>     Find only files newer than <date> (Format: YYYYMMDDhhmm.SS)
    -b, --before-date <date>    Find only files older than <date> (Format: YYYYMMDDhhmm.SS)
    -t, --type <c>              Find only files of type <c> (Default: f)
    -o, --output <outdir>       Found files are copied to <outdir>
    -h, --help                  Output help

Example:
    coin-find-file.sh -a 201310131309.00 ./                     # find files newer than 2013-10-13 13:09:00
    coin-find-file.sh -b 201310131309.00 -o ./ /path/to/dir     # find files under /path/to/dir older than 2013-10-13 13:09:00 and copy these files to ./
EOF
}

date_filename()
{
  local time=$1

  echo ${DATE_FILE_DIR}/coin-find-file.${time}.$$
}

create_time_file()
{
  local time=$1

  touch -t $time $(date_filename $time)
}

remove_time_file()
{
  local filename=$(date_filename $1)

  if [ -f $filename ]
  then
    rm $filename
  fi
}

find_target()
{
  local dir=$1
  local after=$2
  local before=$3
  local find_opt=""

  if [ -n "$after" ]
  then
    create_time_file $after
    find_opt=${find_opt}" -newer $(date_filename $after)"
  fi

  if [ -n "$before" ]
  then
    create_time_file $before
    find_opt=${find_opt}" ! -newer $(date_filename $before)"
  fi

  find $dir -type $FILE_TYPE $find_opt

  if [ -n "$after" ]
  then
    remove_time_file $after
  fi

  if [ -n "$before" ]
  then
    remove_time_file $before
  fi
}

fulldirname()
{
  local dir=$1

  if [ -f $dir ]
  then
    dir=$(dirname $dir)
  fi

  (
    cd $dir
    pwd
  )
}

copy_target()
{
  local targetfile=$1
  local dir=$(fulldirname $targetfile)
  
  if [ ! -d $OUTPUT_DIR/$dir ]
  then
    mkdir -p $OUTPUT_DIR/$dir
  fi

  cp -p $targetfile $OUTPUT_DIR/$dir
}

while [ $# -gt 0 ]
do
  case $1 in
    -a|--after-date )
      shift
      if [ -n "$1" ]
      then
        AFTER_DATE=$1
        shift
      fi
      ;;
    -b|--before-date )
      shift
      if [ -n "$1" ]
      then
        BEFORE_DATE=$1
        shift
      fi
      ;;
    -t|--type )
      shift
      if [ -n "$1" ]
      then
        FILE_TYPE=$1
        shift
      fi
      ;;
    -o|--output )
      shift
      if [ -n "$1" ]
      then
        OUTPUT_DIR=$1
        shift
      fi
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

DIR=$*

if [ -z "$DIR" ]
then
  usage
  exit
fi

if [ -z "$OUTPUT_DIR" ]
then
  find_target "$DIR" "$AFTER_DATE" "$BEFORE_DATE"
else
  if [ ! -d $OUTPUT_DIR ]
  then
    mkdir $OUTPUT_DIR
  fi

  for target in $(find_target "$DIR" "$AFTER_DATE" "$BEFORE_DATE")
  do
    echo $target
    copy_target $target
  done
fi

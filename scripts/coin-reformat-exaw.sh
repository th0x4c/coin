#!/bin/sh

SCRIPT_DIR=$(dirname $0)

usage()
{
  cat <<EOF
Description:
    Reformat ExaWatcher output files

Usage: coin-reformat-exaw.sh <file>

Option:
    -h, --help      Output help

Example:
    coin-reformat-exaw.sh *_IostatExaWatcher_*.dat.bz2  # reformat ExaWather iostat output
EOF
}

coin_meminfo()
{
  local cname="MEMINFO"
  awk '/^zzz/{split(substr($2, 2, 10), date, "/"); \
              split(substr($3, 1, 8), timestamp, ":");} \
       /^[^z#]/{date_str = sprintf("%d %d %d 00 00 00", date[3], date[1], date[2]); \
                printf("'$cname' %sT%02d:%02d:%02d %s\n", strftime("%Y-%m-%d", mktime(date_str)), \
                                                          timestamp[1], \
                                                          timestamp[2], \
                                                          timestamp[3], \
                                                          $0);}'
}

get_script()
{
  local file=$1

  if [ ! -f $file ]
  then
    return
  fi

  case $(basename $file) in
    *IostatExaWatcher* )
      echo "${SCRIPT_DIR}/coin-iostat.sh"
      ;;
    *MpstatExaWatcher* )
      echo "${SCRIPT_DIR}/coin-mpstat.sh"
      ;;
    *MeminfoExaWatcher* )
      echo "coin_meminfo"
      ;;
    * )
      echo ""
      ;;
  esac
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

DATFILES=$*

if [ -z "$DATFILES" ]
then
  usage
  exit
fi

for datfile in $DATFILES
do
  sh_script=$(get_script $datfile)

  if [ -n "$sh_script" ]
  then
    bzcat $datfile | $sh_script | perl ${SCRIPT_DIR}/coin-reformat.pl
  fi
done

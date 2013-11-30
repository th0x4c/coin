#!/bin/sh

TIMEOUT=0
CHECKFILE=""
INTERVAL=30
STOP_COMMAND=""
SIGNAL=15 # SIGTERM
COMMAND=""

LIBEXEC_DIR=$(dirname $0)

usage()
{
  cat <<EOF
Description:
    Run a command with a time limit or checking files update

Usage: coin-hang-check.sh [options] <command> [args]

Option:
    -t, --timeout <seconds>         Timeout in seconds
    -f, --file <filename>           File or directory that is checked
    -i, --interval <seconds>        File check interval (Default: 30)
    -s, --signal <signal>           Specify the signal to send on timeout (Default: 15)
    -x, --stop-command <command>    Specify the command to execute on timeout
    -h, --help                      Output help

Example:
    coin-hang-check.sh -t 10 sleep 60                               # timeout and terminated in 10 seconds
    coin-hang-check.sh -f /path/to/some.log -i 10 somecommand       # check some.log every 10 seconds and terminated if some.log is not modified
EOF
}

check_pid()
{
  local pid=$1
  ps -p $pid | grep $pid
}

date_format()
{
  date +%Y%m%d%H%M.%S
}

stop_process()
{
  local pid=$1

  if [ -n "$(check_pid $pid)" ]
  then
    if [ -n "$STOP_COMMAND" ]
    then
      $STOP_COMMAND
    else
      kill -s $SIGNAL $pid
    fi
  fi
}

watch_process()
{
  local pid=$1

  i=1
  while [ -n "$(check_pid $pid)" -a $i -le $TIMEOUT ]
  do
    sleep 1
    i=$(expr $i + 1)
  done

  stop_process $pid
}

watch_file()
{
  local pid=$1
  local updated_files=$CHECKFILE

  while [ -n "$(check_pid $pid)" -a -n "$updated_files" ]
  do
    pre_date=$(date_format)
    sleep $INTERVAL
    if [ -n "$(check_pid $pid)" ]
    then
      updated_files=$($LIBEXEC_DIR/coin-find-file.sh -a $pre_date $CHECKFILE)
    fi
  done

  stop_process $pid
}

while [ $# -gt 0 ]
do
  case $1 in
    -t|--timeout )
      shift
      if [ -n "$1" ]
      then
        TIMEOUT=$1
        shift
      fi
      ;;
    -f|--file )
      shift
      if [ -n "$1" ]
      then
        CHECKFILE=$1
        shift
      fi
      ;;
    -i|--interval )
      shift
      if [ -n "$1" ]
      then
        INTERVAL=$1
        shift
      fi
      ;;
    -s|--signal )
      shift
      if [ -n "$1" ]
      then
        SIGNAL=$1
        shift
      fi
      ;;
    -x|--stop-command )
      shift
      if [ -n "$1" ]
      then
        STOP_COMMAND=$1
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

COMMAND=$*

if [ -z "$COMMAND" ]
then
  usage
  exit
fi

pid=$$

if [ $TIMEOUT -gt 0 ]
then
  watch_process $pid &
fi
if [ -n "$CHECKFILE" ]
then
  watch_file $pid &
fi

exec $COMMAND

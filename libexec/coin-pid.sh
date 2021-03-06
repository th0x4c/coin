#!/bin/sh

COMMAND=""
FOLLOW=0
LONG=0
KILL=0
SIGNAL=15 # SIGTERM
PIDLIST=""
WAIT=0
EXCLUDE_COMM=""

# "env UNIX95= " for HP-UX
PS="env UNIX95= ps"

usage()
{
  cat <<EOF
Description:
    List PID of process whose command contains a match to the given string

Usage: coin-pid.sh [options] <command>

Option:
    -f, --follow                Follow child process
    -l, --long                  Display long format ps output
    -k, --kill                  Kill processes
    -s, --signal <signal>       Use the specified signal instead of SIGTERM
    -p, --pid <pidlist>         Select by PID (comma-delimited list)
    -w, --wait                  Wait processes
    -X, --exclude <comm>        Exclude processes based upon the specified command
    -h, --help                  Output help

Example:
    coin-pid.sh emacs               # list PID of emacs processes
    coin-pid.sh -l emacs            # list long format ps for emacs processes
    coin-pid.sh -l -p 1234,9876     # list long format ps for PID 1234 and 9876
    coin-pid.sh -k emacs            # kill (send SIGTERM) emacs processes
    coin-pid.sh -k -s 9 emacs       # send SIGNAL 9 (SIGKILL) to emacs processes
    coin-pid.sh -w emacs            # wait for emacs processes
EOF
}

wait_process()
{
  local pid=$1

  while [ -n "$(ps -p $pid | grep $pid)" ]
  do
    sleep 1
  done
}

list_process()
{
  local command=$1

  $PS -e -o pid,ppid,args | grep "$command" | grep -v "grep $command" | awk '$1 != '$MYPID' && $2 != '$MYPID'{print $1}'
}

exclude_from()
{
  local from_list=$1
  local exclude_list=$2
  local ret_list=$from_list

  for item in $exclude_list
  do
    ret_list=$(echo $ret_list | sed 's/\b'$item'\b//g')
  done

  echo $ret_list
}

while [ $# -gt 0 ]
do
  case $1 in
    -f|--follow )
      FOLLOW=1
      shift
      ;;
    -l|--long )
      LONG=1
      shift
      ;;
    -k|--kill )
      KILL=1
      shift
      ;;
    -s|--signal )
      shift
      if [ -n "$1" ]
      then
        SIGNAL=$1
        shift
      fi
      ;;
    -p|--pid )
      shift
      if [ -n "$1" ]
      then
        PIDLIST=$1
        shift
      fi
      ;;
    -w|--wait )
      WAIT=1
      shift
      ;;
    -X|--exclude )
      shift
      if [ -n "$1" ]
      then
        EXCLUDE_COMM=$1
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

if [ -z "$COMMAND" -a -z "$PIDLIST" ]
then
  usage
  exit
fi

MYPID=$$

if [ -z "$PIDLIST" ]
then
  pid_list=$(list_process "$COMMAND")
else
  pid_list=$(echo $PIDLIST | sed 's/,/ /g')
fi

if [ $FOLLOW -eq 1 ]
then
  target=$pid_list

  while [ -n "$target" ]
  do
    children=""
    for pid in $target
    do
      children="$children $($PS -e -o pid,ppid | awk '$2 == '$pid'{print $1}')"
    done

    pid_list="$pid_list $children"
    target=$children
  done
fi

if [ -n "$EXCLUDE_COMM" ]
then
  exclude_pid_list=$(list_process "$EXCLUDE_COMM")
  pid_list=$(exclude_from "$pid_list" "$exclude_pid_list")
fi

if [ -z "$pid_list" ]
then
  exit
fi

pid_list=$(exclude_from "$pid_list" $MYPID)
pid_csv_list=$(echo $pid_list | sed 's/ /,/g')

if [ $LONG -eq 0 ]
then
  $PS -o pid -p $pid_csv_list | grep -v PID
else
  $PS -lf -p $pid_csv_list
fi

if [ $KILL -eq 1 ]
then
  pid_list=$($PS -o pid -p $pid_csv_list | grep -v PID)
  kill -s $SIGNAL $pid_list
fi

if [ $WAIT -eq 1 ]
then
  for pid in $pid_list
  do
    wait_process $pid
  done
fi

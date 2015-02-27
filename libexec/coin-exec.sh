#!/bin/sh

CONNECT_STRING="/as sysdba"
SQL_FILE=""
SCRIPT_FILE=""
LOG_FILE=""
INTERVAL=-1
ALIGN_INTERVAL=0
NSAMPLE=-1
ORACLE_SID=$ORACLE_SID
ORACLE_HOME=$ORACLE_HOME
SQLPLUS_OPTS=""

LIBEXEC_DIR=$(dirname $0)

usage()
{
  cat <<EOF
Description:
    Execute sql or shell script

Usage: coin-exec.sh [options] <sqlfile>|<scriptfile>

Option:
    -c, --connect <string>      Connection string (Default: '/as sysdba')
    -S, --sid <oracle_sid>      Oracle SID
    -H, --home <oracle_home>    ORACLE_HOME
    -l, --log <logfile>         Log file
    -i, --interval <sec>        Interval in seconds
    -A, --align_interval        Align interval from the beginning to the beginning of the next
    -n, --num_sample <num>      Number of samples
    -P, --prelim                SQL*Plus with prelim option
    -h, --help                  Output help

Example:
    coin-exec.sh -i 10 -n 5 test.sql        # execute test.sql every 10 seconds 5 times
    coin-exec.sh -i 2 date                  # execute date command every 2 seconds
    coin-exec.sh -i 2 -l test.log date      # execute date command every 2 seconds and output to test.log
EOF
}

sql_setup()
{
  echo "whenever sqlerror exit sql.code"
  echo "connect $CONNECT_STRING"
  echo "whenever sqlerror continue"
}

sql_teardown()
{
  echo "exit"
}

sql_main()
{
  echo "@$SQL_FILE"
}

script_main()
{
  $SCRIPT_FILE
}

main_loop()
{
  local main=$1
  local setup=$2
  local teardown=$3
  local n=0
  local start_time=0
  local end_time=0
  local elapsed_time=0
  local sleep_interval=$INTERVAL

  $setup

  while [ $n -lt $NSAMPLE -o $NSAMPLE -lt 0 ]
  do
    if [ $n -ne 0 ]
    then
      if [ $ALIGN_INTERVAL -eq 1 ]
      then
        sleep_interval=$(expr $INTERVAL - $elapsed_time)
      fi
      if [ $sleep_interval -gt 0 ]
      then
        sleep $sleep_interval
      fi
    fi

    start_time=$(date +%s)
    $main
    end_time=$(date +%s)
    elapsed_time=$(expr $end_time - $start_time)

    n=$(expr $n + 1)

    if [ $n -eq 2147483647 ] # 2147483647 = 2 ** 31 -1
    then
      n=1
    fi
  done

  $teardown
}

while [ $# -gt 0 ]
do
  case $1 in
    -c|--connect )
      shift
      if [ -n "$1" ]
      then
        CONNECT_STRING=$1
        shift
      fi
      ;;
    -S|--sid )
      shift
      if [ -n "$1" ]
      then
        ORACLE_SID=$1
        export ORACLE_SID
        shift
      fi
      ;;
    -H|--home )
      shift
      if [ -n "$1" ]
      then
        ORACLE_HOME=$1
        export ORACLE_HOME
        shift
      fi
      ;;
    -l|--log )
      shift
      if [ -n "$1" ]
      then
        LOG_FILE=$1
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
    -A|--align_interval )
      ALIGN_INTERVAL=1
      shift
      ;;
    -n|--num_sample )
      shift
      if [ -n "$1" ]
      then
        NSAMPLE=$1
        shift
      fi
      ;;
    -P|--prelim )
      SQLPLUS_OPTS="-prelim"
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

SCRIPT_FILE=$*

if [ -z "$SCRIPT_FILE" ]
then
  usage
  exit
fi

if [ "$($LIBEXEC_DIR/coin-extname.sh $SCRIPT_FILE)" = "sql" ]
then
  SQL_FILE=$SCRIPT_FILE
  SCRIPT_FILE=""
fi

if [ $INTERVAL -le -1 ]
then
  INTERVAL=0
  if [ $NSAMPLE -le -1 ]
  then
    NSAMPLE=1
  fi
fi

trap "$LIBEXEC_DIR/coin-pid.sh --follow --long --kill --signal 9 --pid $$ > /dev/null; exit" 2 10 15

if [ -n "$SQL_FILE" -a -z "$SCRIPT_FILE" ]
then
  if [ -n "$LOG_FILE" ]
  then
    main_loop sql_main sql_setup sql_teardown | sqlplus $SQLPLUS_OPTS /nolog > $LOG_FILE &
  else
    main_loop sql_main sql_setup sql_teardown | sqlplus $SQLPLUS_OPTS /nolog &
  fi
elif [ -z "$SQL_FILE" -a -n "$SCRIPT_FILE" ]
then
  if [ -n "$LOG_FILE" ]
  then
    main_loop script_main "" "" > $LOG_FILE &
  else
    main_loop script_main "" "" &
  fi
fi

wait

#!/bin/sh

SHOW_SID=0
SHOW_HOME=0
SHOW_ALERT=0
PRINT_KEY=1

usage()
{
  cat <<EOF
Description:
    Show Oracle information

Usage: coin-orainfo.sh [options] db|asm|grid

Option:
    -S, --sid       Show Oracle SID
    -H, --home      Show ORACLE_HOME
    -A, --alert     Show alert.log file name and path
    -n, --no-key    Do not print key name
    -h, --help      Output help

Example:
    coin-orainfo.sh db                  # show ORACLE_SID, ORACLE_HOME, alert file name for DB
    coin-orainfo.sh -S db               # show ORACLE_SID for DB
    coin-orainfo.sh -n -H db            # show ORACLE_HOME for DB without key name
    coin-orainfo.sh -A grid             # show alert file name for Grid Infrastructure
    coin-orainfo.sh -A db asm grid      # show alert file name for DB, ASM, Grid Infrastructure
    coin-orainfo.sh db asm grid         # show ORACLE_SID, ORACLE_HOME, alert file name for DB, ASM, Grid Infrastructure
EOF
}

show_db_sid()
{
  ps -eo args | grep ora_pmon_ | grep "^ora_pmon_" | cut -d"_" -f3
}

show_asm_sid()
{
  ps -eo args | grep asm_pmon_ | grep "^asm_pmon_" | cut -d"_" -f3
}

show_grid_sid()
{
  echo "There is NO Grid Infrastructure SID." > /dev/null
}

show_db_home()
{
  grep -v "^\#" /etc/oratab 2>/dev/null | grep -v "^\$" | grep -v "^+ASM" | grep -v "^\*" | cut -d":" -f2  | uniq
}

show_asm_home()
{
  grep "^+ASM" /etc/oratab 2>/dev/null | cut -d":" -f2  | uniq
}

show_grid_home()
{
  show_asm_home
}

upper()
{
  local str=$1

  echo $str | tr '[a-z]' '[A-Z]'
}

lower()
{
  local str=$1

  echo $str | tr '[A-Z]' '[a-z]'
}

show_background_dump_dest()
{
  local oracle_home=$1
  local oracle_sid=$2

  ORACLE_HOME=$oracle_home
  ORACLE_SID=$oracle_sid

  sqlplus -S /nolog <<EOF 2> /dev/null
  set feedback off
  set pages 0
  connect / as sysdba
  select value from v\$parameter where upper(name) = 'BACKGROUND_DUMP_DEST';
EOF
}

show_dbasm_alert()
{
  local target=$1 # "db" or "asm"
  local subdir=""

  case $target in
    db )
      subdir="rdbms"
      ;;
    asm )
      subdir="asm"
      ;;
    * )
      break
      ;;
  esac

  for home in $(show_${target}_home)
  do
    adr_base=$(cat $home/log/diag/adrci_dir.mif 2> /dev/null)
    if [ -n "$adr_base" ]
    then
      for sid in $(show_${target}_sid)
      do
        find ${adr_base}/diag/${subdir} -name 'alert_'${sid}'.log'
      done
    else
      for sid in $(show_${target}_sid)
      do
        find $(show_background_dump_dest $home $sid) -name 'alert_'${sid}'.log'
      done
    fi
  done
}

show_db_alert()
{
  show_dbasm_alert "db"
}

show_asm_alert()
{
  show_dbasm_alert "asm"
}

show_grid_alert()
{
  local home=$(show_grid_home | cut -d" " -f2)

  if [ -n "$home" ]
  then
    find $home/log/$(lower $(hostname -s)) -name 'alert*.log'
  fi
}

key()
{
  local target=$1
  local suffix=$2

  if [ $PRINT_KEY -eq 1 ]
  then
    echo "$(upper $target)_${suffix}:"
  else
    echo ""
  fi
}

while [ $# -gt 0 ]
do
  case $1 in
    -S|--sid )
      SHOW_SID=1
      shift
      ;;
    -H|--home )
      SHOW_HOME=1
      shift
      ;;
    -A|--alert )
      SHOW_ALERT=1
      shift
      ;;
    -n|--no-key )
      PRINT_KEY=0
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

TARGETS=$*

if [ -z "$TARGETS" ]
then
  usage
  exit
fi

if [ $SHOW_SID -eq 0 -a $SHOW_HOME -eq 0 -a $SHOW_ALERT -eq 0 ]
then
  SHOW_SID=1
  SHOW_HOME=1
  SHOW_ALERT=1
fi

for target in $TARGETS
do
  if [ $target != "db" -a $target != "asm" -a $target != "grid" ]
  then
    echo "$target is unknown."
    usage
    exit
  fi
done

for target in $TARGETS
do
  if [ $SHOW_SID -eq 1 ]
  then
    show_${target}_sid | awk '{print "'$(key $target "SID")'" $1}'
  fi

  if [ $SHOW_HOME -eq 1 ]
  then
    show_${target}_home | awk '{print "'$(key $target "HOME")'" $1}'
  fi

  if [ $SHOW_ALERT -eq 1 ]
  then
    show_${target}_alert | awk '{print "'$(key $target "ALERT")'" $1}'
  fi
done

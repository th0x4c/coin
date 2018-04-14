#!/bin/sh

PASSWORD=""

if [ -n "$COIN_SSHPASS_PASSWORD" ]
then
  echo $COIN_SSHPASS_PASSWORD
  exit
fi

usage()
{
  cat <<EOF
Description:
    Provide password to ssh noninteractively

Usage: coin-sshpass.sh [options] ssh|scp [args]

Option:
    -p, --password <password>       Password given on the command line
    -h, --help                      Output help

Example:
    coin-sshpass.sh -p examplepass ssh -l exampleuser host.example.com hostname
    coin-sshpass.sh ssh exampleuser/examplepass@host.example.com hostname
    coin-sshpass.sh -p examplepass scp ./example.log exampleuser@host.example.com:/path/to/somewhere
EOF
}

get_password()
{
  local args=$1 # "user/password@hostname command arguments"
  local passowrd=""

  for login_string in $args
  do
    password=$(echo $login_string | sed 's/^[^\/]*\/\([^\/]*\)@.*\|.*/\1/')
    if [ -n "$password" ]
    then
       break
    fi
  done

  echo $password
}

remove_password()
{
  local args=$1
  local password=""
  local ret=""

  for arg in $args
  do
    arg=$(echo $arg | sed 's/^\([^\/]*\)\/[^\/]*\(@.*\)/\1\2/' | sed 's/^@//')
    ret="$ret $arg"
  done

  echo $ret | sed 's/^ //'
}

while [ $# -gt 0 ]
do
  case $1 in
    -p|--password )
      shift
      if [ -n "$1" ]
      then
        PASSWORD=$1
        shift
      fi
      ;;
    -h|--help )
      usage
      exit
      ;;
    --get-password )
      shift
      get_password "$*"
      exit
      ;;
    --remove-password )
      shift
      remove_password "$*"
      exit
      ;;
    * )
      break
      ;;
  esac
done

COMMAND=$1
shift
arguments=$*

if [ "$COMMAND" != "ssh" -a "$COMMAND" != "scp" ]
then
  echo "$COMMAND must be ssh or scp."
  usage
  exit
fi

if [ -z "$arguments" ]
then
  usage
  exit
fi

if [ -z "$PASSWORD" ]
then
  PASSWORD=$(get_password "$arguments")
  arguments=$(remove_password "$arguments")
fi

if [ -z "$PASSWORD" ]
then
  exec $COMMAND $arguments
fi

export COIN_SSHPASS_PASSWORD=$PASSWORD
export SSH_ASKPASS=$0 # see ENVIRONMENT section in the man page of ssh(1)
export DISPLAY="dummy:0"

exec setsid $COMMAND -o StrictHostKeyChecking=no $arguments

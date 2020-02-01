#!/bin/sh

usage()
{
  cat <<EOF
Description:
    Decompress files to stdout

Usage: coin-cat.sh <file>

Option:
    -h, --help      Output help

Example:
    coin-cat.sh test.gz     # identical to "zcat test.gz"
    coin-cat.sh test.bz2    # identical to "bzcat test.bz2"
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

INPUT_FILE=$*

if [ -z "$INPUT_FILE" ]
then
  usage
  exit
fi

for input_file in $INPUT_FILE
do
  case $(file -i $input_file) in
    *x-zip* )
      zcat $input_file
      ;;
    *x-gzip* )
      zcat $input_file
      ;;
    *x-bzip2* )
      bzcat $input_file
      ;;
    *zip* )
      zcat $input_file
      ;;
    * )
      cat $input_file
      ;;
  esac
done

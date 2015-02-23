#!/bin/sh

LANG=C
CNAME="IOSTAT"

FIRST_REPORT_COUNT=1

while [ $# -gt 0 ]
do
  case $1 in
    --no-first-report )
      FIRST_REPORT_COUNT=2
      shift
      ;;
    * )
      break
      ;;
  esac
done

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "$CNAME $now [INFO] Start"

COMMAND="iostat -xk -t $@"
$COMMAND | awk 'BEGIN{report_count = 0; \
                      date = strftime("%Y-%m-%d"); \
                      split(strftime("%H:%M:%S"), timestamp, ":");} \
                $2 ~ /[012][0-9]:[0-9][0-9]:[0-9][0-9]/{report_count += 1; \
                                                        date = strftime("%Y-%m-%d"); \
                                                        split($2, timestamp, ":"); \
                                                        if ($3 == "PM") {timestamp[1] += 12}; \
                                                        if ($3 == "AM" && timestamp[1] == 12) {timestamp[1] = 0}} \
                {if (report_count >= '$FIRST_REPORT_COUNT') { \
                   printf("'$CNAME' %sT%02d:%02d:%02d %s\n", date, \
                                                             timestamp[1], \
                                                             timestamp[2], \
                                                             timestamp[3], \
                                                             $0);} \
                 system("");}'

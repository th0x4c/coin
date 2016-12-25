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

if [ ! -t 0 -a $# -eq 0 ]
then
  COMMAND="cat -"
fi

$COMMAND | awk 'BEGIN{report_count = 0; \
                      split(strftime("%m/%d/%Y"), date, "/"); \
                      am_pm = ""; \
                      split(strftime("%H:%M:%S"), timestamp, ":");} \
                $4 ~ /[01][0-9]\/[0-3][0-9]\/[0-9][0-9]/{split($4, date, "/"); date[3] += 2000;} \
                $4 ~ /[01][0-9]\/[0-3][0-9]\/20[0-9][0-9]/{split($4, date, "/");} \
                $2 ~ /[012][0-9]:[0-9][0-9]:[0-9][0-9]/{report_count += 1; \
                                                        split($2, timestamp, ":"); \
                                                        if ($3 == "PM" && timestamp[1] != 12) {timestamp[1] += 12;} \
                                                        if ($3 == "AM" && timestamp[1] == 12) {timestamp[1] = 0;} \
                                                        if ($3 == "AM" && am_pm == "PM") {date[2] += 1;} \
                                                        am_pm = $3;
                                                        if (match($1, /[01][0-9]\/[0-3][0-9]\/[0-9][0-9]/)) {split($1, date, "/"); date[3] += 2000;} \
                                                        if (match($1, /[01][0-9]\/[0-3][0-9]\/20[0-9][0-9]/)) {split($1, date, "/");}} \
                {if (report_count >= '$FIRST_REPORT_COUNT') { \
                   date_str = sprintf("%d %d %d 00 00 00", date[3], date[1], date[2]); \
                   printf("'$CNAME' %sT%02d:%02d:%02d %s\n", strftime("%Y-%m-%d", mktime(date_str)), \
                                                             timestamp[1], \
                                                             timestamp[2], \
                                                             timestamp[3], \
                                                             $0);} \
                 system("");}'

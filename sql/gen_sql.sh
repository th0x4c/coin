#!/bin/sh

cname()
{
  local tab=$1

  echo $tab | cut -d"\$" -f2
}

upper()
{
  local str=$1

  echo $str | tr '[a-z]' '[A-Z]'
}

for tab in $(cat table.lst)
do
  cat <<EOF > $(cname $tab).sql
select
  '$(upper $(cname $tab))' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  $tab.*
from
  $tab
/
EOF
done


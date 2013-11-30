select
  'PGASTAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$pgastat.*
from
  v$pgastat
/

select
  'ENQUEUE_STAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$enqueue_stat.*
from
  v$enqueue_stat
/

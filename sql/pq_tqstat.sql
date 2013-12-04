select
  'PQ_TQSTAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$pq_tqstat.*
from
  v$pq_tqstat
/

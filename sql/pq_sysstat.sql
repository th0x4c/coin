select
  'PQ_SYSSTAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$pq_sysstat.*
from
  v$pq_sysstat
/

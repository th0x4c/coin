select
  'DATAGUARD_STATS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$dataguard_stats.*
from
  v$dataguard_stats
/

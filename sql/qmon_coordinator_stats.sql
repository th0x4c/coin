select
  'QMON_COORDINATOR_STATS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$qmon_coordinator_stats.*
from
  v$qmon_coordinator_stats
/

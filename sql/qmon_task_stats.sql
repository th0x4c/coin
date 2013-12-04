select
  'QMON_TASK_STATS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$qmon_task_stats.*
from
  v$qmon_task_stats
/

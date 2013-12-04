select
  'QMON_SERVER_STATS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$qmon_server_stats.*
from
  v$qmon_server_stats
/

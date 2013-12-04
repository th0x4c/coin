select
  'DYNAMIC_REMASTER_STATS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$dynamic_remaster_stats.*
from
  v$dynamic_remaster_stats
/

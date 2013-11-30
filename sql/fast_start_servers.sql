select
  'FAST_START_SERVERS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$fast_start_servers.*
from
  v$fast_start_servers
/

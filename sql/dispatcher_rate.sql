select
  'DISPATCHER_RATE' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$dispatcher_rate.*
from
  v$dispatcher_rate
/

select
  'SYSTEM_EVENT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$system_event.*
from
  v$system_event
/

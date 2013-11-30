select
  'SYSTEM_WAIT_CLASS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$system_wait_class.*
from
  v$system_wait_class
/

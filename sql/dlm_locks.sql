select
  'DLM_LOCKS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$dlm_locks.*
from
  v$dlm_locks
/

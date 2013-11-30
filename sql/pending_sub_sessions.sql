select
  'PENDING_SUB_SESSIONS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  sys.pending_sub_sessions$.*
from
  sys.pending_sub_sessions$
/

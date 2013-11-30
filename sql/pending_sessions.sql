select
  'PENDING_SESSIONS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  sys.pending_sessions$.*
from
  sys.pending_sessions$
/

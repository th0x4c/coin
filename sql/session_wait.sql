select
  'SESSION_WAIT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$session_wait.*
from
  v$session_wait
/

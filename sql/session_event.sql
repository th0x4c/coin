select
  'SESSION_EVENT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$session_event.*
from
  v$session_event
/

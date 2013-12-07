select
  'ACTIVE_SESSION_HISTORY_LAST1' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$active_session_history.*
from
  v$active_session_history
where
  sample_id = (select max(sample_id) from v$active_session_history)
/

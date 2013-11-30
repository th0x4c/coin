select
  'PX_PROCESS_SYSSTAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$px_process_sysstat.*
from
  v$px_process_sysstat
/

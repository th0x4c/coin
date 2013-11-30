select
  'SYS_TIME_MODEL' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$sys_time_model.*
from
  v$sys_time_model
/

select
  'RMAN_STATUS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$rman_status.*
from
  v$rman_status
/

select
  'HANG_STATISTICS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$hang_statistics.*
from
  v$hang_statistics
/

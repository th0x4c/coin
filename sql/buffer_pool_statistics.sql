select
  'BUFFER_POOL_STATISTICS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$buffer_pool_statistics.*
from
  v$buffer_pool_statistics
/

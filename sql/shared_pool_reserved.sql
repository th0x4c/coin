select
  'SHARED_POOL_RESERVED' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$shared_pool_reserved.*
from
  v$shared_pool_reserved
/

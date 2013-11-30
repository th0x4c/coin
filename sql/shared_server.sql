select
  'SHARED_SERVER' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$shared_server.*
from
  v$shared_server
/

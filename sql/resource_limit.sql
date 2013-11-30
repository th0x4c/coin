select
  'RESOURCE_LIMIT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$resource_limit.*
from
  v$resource_limit
/

select
  'GES_BLOCKING_ENQUEUE' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$ges_blocking_enqueue.*
from
  v$ges_blocking_enqueue
/

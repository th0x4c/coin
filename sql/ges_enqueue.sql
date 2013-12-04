select
  'GES_ENQUEUE' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$ges_enqueue.*
from
  v$ges_enqueue
/

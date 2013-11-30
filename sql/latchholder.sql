select
  'LATCHHOLDER' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$latchholder.*
from
  v$latchholder
/

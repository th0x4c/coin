select
  'PENDING_TRANS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  sys.pending_trans$.*
from
  sys.pending_trans$
/

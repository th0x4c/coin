select
  'GES_STATISTICS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$ges_statistics.*
from
  v$ges_statistics
/

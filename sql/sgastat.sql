select
  'SGASTAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$sgastat.*
from
  v$sgastat
/

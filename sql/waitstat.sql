select
  'WAITSTAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$waitstat.*
from
  v$waitstat
/

select
  'LIBRARYCACHE' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$librarycache.*
from
  v$librarycache
/

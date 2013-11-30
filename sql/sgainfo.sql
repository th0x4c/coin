select
  'SGAINFO' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$sgainfo.*
from
  v$sgainfo
/

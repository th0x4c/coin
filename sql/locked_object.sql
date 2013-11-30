select
  'LOCKED_OBJECT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$locked_object.*
from
  v$locked_object
/

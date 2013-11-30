select
  'IOSTAT_FUNCTION' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$iostat_function.*
from
  v$iostat_function
/

select
  'IOSTAT_FUNCTION_DETAIL' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$iostat_function_detail.*
from
  v$iostat_function_detail
/

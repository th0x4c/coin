select
  'IOSTAT_FILE' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$iostat_file.*
from
  v$iostat_file
/

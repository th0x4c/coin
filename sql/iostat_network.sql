select
  'IOSTAT_NETWORK' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$iostat_network.*
from
  v$iostat_network
/

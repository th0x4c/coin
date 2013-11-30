select
  'CR_BLOCK_SERVER' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$cr_block_server.*
from
  v$cr_block_server
/

select
  'WAIT_CHAINS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$wait_chains.*
from
  v$wait_chains
/

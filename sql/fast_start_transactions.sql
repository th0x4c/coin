select
  'FAST_START_TRANSACTIONS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$fast_start_transactions.*
from
  v$fast_start_transactions
/

select
  'DLM_RESS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$dlm_ress.*
from
  v$dlm_ress
/

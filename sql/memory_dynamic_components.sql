select
  'MEMORY_DYNAMIC_COMPONENTS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$memory_dynamic_components.*
from
  v$memory_dynamic_components
/

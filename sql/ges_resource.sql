select
  'GES_RESOURCE' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$ges_resource.*
from
  v$ges_resource
/

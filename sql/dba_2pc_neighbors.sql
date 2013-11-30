select
  'DBA_2PC_NEIGHBORS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  dba_2pc_neighbors.*
from
  dba_2pc_neighbors
/

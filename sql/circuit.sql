select
  'CIRCUIT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$circuit.*
from
  v$circuit
/

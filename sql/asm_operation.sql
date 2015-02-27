select
  'ASM_OPERATION' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$asm_operation.*
from
  v$asm_operation
/

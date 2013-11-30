select
  'ASM_DISK_STAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$asm_disk_stat.*
from
  v$asm_disk_stat
/

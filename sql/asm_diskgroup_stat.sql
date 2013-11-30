select
  'ASM_DISKGROUP_STAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$asm_diskgroup_stat.*
from
  v$asm_diskgroup_stat
/

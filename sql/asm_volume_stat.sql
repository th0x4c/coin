select
  'ASM_VOLUME_STAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$asm_volume_stat.*
from
  v$asm_volume_stat
/

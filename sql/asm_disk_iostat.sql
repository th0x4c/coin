select
  'ASM_DISK_IOSTAT' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$asm_disk_iostat.*
from
  v$asm_disk_iostat
/

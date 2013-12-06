select
  'KSMSS' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  ksmdsidx SUBPOOL#,
  ksmssnam NAME,
  sum(ksmsslen) BYTES
from
  x$ksmss
group by
  ksmdsidx, ksmssnam
order by
  ksmdsidx, ksmssnam
/


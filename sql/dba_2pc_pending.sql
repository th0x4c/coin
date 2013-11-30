column TRAN_COMMENT format a64
column OS_USER format a10
column OS_TERMINAL format a10
column HOST format a10
select
  'DBA_2PC_PENDING' CNAME, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') PTIME,
  dba_2pc_pending.*
from
  dba_2pc_pending;
clear columns

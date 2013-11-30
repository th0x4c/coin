select
  'GES_TRAFFIC_CONTROLLER' CNAME, to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.ff') CTIMESTAMP,
  v$ges_traffic_controller.*
from
  v$ges_traffic_controller
/

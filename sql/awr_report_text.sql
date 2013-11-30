set linesize 80;
set pagesize 50000;
set heading off;
set trimspool on
set termout on;
set feedback off;
set verify off;
set tab off;

variable dbid     NUMBER
variable inst_num NUMBER
variable bid      NUMBER
variable eid      NUMBER

BEGIN
  SELECT dbid INTO :dbid FROM v$database;
  SELECT instance_number INTO :inst_num FROM v$instance;
  SELECT MIN(snap_id) INTO :bid FROM dba_hist_snapshot
    WHERE end_interval_time >= to_date('&1', 'YYYYMMDDHH24MI.SS');
  SELECT MAX(snap_id) INTO :eid FROM dba_hist_snapshot
    WHERE end_interval_time <= to_date('&2', 'YYYYMMDDHH24MI.SS');
END;
/

SELECT output FROM table(dbms_workload_repository.awr_report_text( :dbid,
                                                                   :inst_num,
                                                                   :bid, :eid));

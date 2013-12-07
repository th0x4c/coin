set serveroutput on
set feedback off
set verify off;
set linesize 8192
set trimspool on

DEFINE rptdir = '&1'
DEFINE startdate = '&2'

spool &rptdir/_awr_report_text_rac.sql

DECLARE
  dbid         NUMBER;
  inst_num     NUMBER;
  min_inst_num NUMBER;
  bid          NUMBER;
  eid          NUMBER;
  CURSOR c IS
    SELECT instance_number FROM gv$instance;
BEGIN
  SELECT dbid INTO dbid FROM v$database;
  SELECT instance_number INTO inst_num FROM v$instance;
  SELECT MIN(instance_number) INTO min_inst_num FROM gv$instance;

  IF inst_num = min_inst_num THEN
    eid := DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT;

    SELECT MIN(snap_id) INTO bid FROM dba_hist_snapshot
      WHERE end_interval_time >= to_date('&startdate', 'YYYYMMDDHH24MI.SS');

    OPEN c;
    LOOP
      FETCH c INTO inst_num;
      EXIT WHEN c%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE('set linesize 80;');
      DBMS_OUTPUT.PUT_LINE('set pagesize 50000;');
      DBMS_OUTPUT.PUT_LINE('set heading off;');
      DBMS_OUTPUT.PUT_LINE('set trimspool on');
      DBMS_OUTPUT.PUT_LINE('set termout on;');
      DBMS_OUTPUT.PUT_LINE('set feedback off;');
      DBMS_OUTPUT.PUT_LINE('set verify off;');
      DBMS_OUTPUT.PUT_LINE('set tab off;');

      DBMS_OUTPUT.PUT_LINE('spool &rptdir/awrrpt_' || inst_num || '_' || bid || '_' || eid || '.txt');

      DBMS_OUTPUT.PUT_LINE('SELECT output FROM table(dbms_workload_repository.awr_report_text('
                           || dbid || ',' || inst_num || ',' || bid || ',' || eid || '));');
      DBMS_OUTPUT.PUT_LINE('spool off');
    END LOOP;
    CLOSE c;
  END IF;
END;
/

spool off

@&rptdir/_awr_report_text_rac.sql

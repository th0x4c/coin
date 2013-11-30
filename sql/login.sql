set feedback on
set term on
set wrap on
set trimspool on
set pagesize 1000
set linesize 8192
set numwidth 20
set echo on
set tab off

alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
alter session set timed_statistics = true;
alter session set max_dump_file_size = UNLIMITED;


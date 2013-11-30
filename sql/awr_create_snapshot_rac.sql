DECLARE
  inst_num     NUMBER;
  min_inst_num NUMBER;
BEGIN
  SELECT instance_number INTO inst_num FROM v$instance;
  SELECT MIN(instance_number) INTO min_inst_num FROM gv$instance;
  IF inst_num = min_inst_num THEN
    DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT;
  END IF;
END;
/

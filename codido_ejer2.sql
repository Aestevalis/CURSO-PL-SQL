connect / as sysdba

CREATE OR REPLACE DIRECTORY EXTRACT_DIR AS 'C:\Users\jorge.olvera\Documents\Oracle';
GRANT READ, WRITE ON DIRECTORY EXTRACT_DIR TO udiplo;
GRANT EXECUTE ON UTL_FILE TO udiplo;

/*@%ORACLE_HOME%\rdbms\admin\spcreate
@%ORACLE_HOME%\rdbms\admin\spdrop
sys_password
tablespace: diplo
enter
CONNECT perfstat/sys_password
EXECUTE statspack.snap;*/




connect udiplo

create or replace function
  gen_numbers(n in number default null)
  return arreglo
  PIPELINED
  as
  begin
     for i in 1 .. nvl(n,999999999)
     loop
         pipe row(i);
     end loop;
     return;
  end;
/

select *
  from (
  select *
    from (select * from table(gen_numbers(500)))
  order by dbms_random.random
  )
where rownum <= 50
/


CREATE OR REPLACE PROCEDURE unload_txt AS
  CURSOR c_data IS
select *
  from (
  select *
    from (select * from table(genera_numeros(20000)))
  order by dbms_random.random
  )
where rownum <= 50;
    
  v_file  UTL_FILE.FILE_TYPE;
BEGIN
  v_file := UTL_FILE.FOPEN(location     => 'EXTRACT_DIR',
                           filename     => 'rand_txt.txt',
                           open_mode    => 'w',
                           max_linesize => 32767);
  FOR cur_rec IN c_data LOOP
    UTL_FILE.PUT_LINE(v_file,
                      cur_rec.COLUMN_VALUE);
  END LOOP;
  UTL_FILE.FCLOSE(v_file);
  
EXCEPTION
  WHEN OTHERS THEN
    UTL_FILE.FCLOSE(v_file);
    RAISE;
END;
/

EXEC unload_txt;


create or replace function
  gen_numbers_parall(l_cursor in sys_refcursor)
  return arreglo
  PIPELINED
  parallel_enable ( partition l_cursor by any )
  as
  begin
     for i in 1 .. 50000
     loop
         pipe row(i);
     end loop;
     return;
  end;
/


CREATE OR REPLACE PROCEDURE unload_txt_par AS
  CURSOR c_data IS
select *
  from (
  select *
    from (select * from table(gen_num_par(Cursor(select /*+ PARALLEL(4)*/* from curs_fila)))
  order by dbms_random.random
  ))
where rownum <= 500;
    
  v_file  UTL_FILE.FILE_TYPE;
BEGIN
  v_file := UTL_FILE.FOPEN(location     => 'EXTRACT_DIR',
                           filename     => 'rand_txt_par.txt',
                           open_mode    => 'w',
                           max_linesize => 32767);
  FOR cur_rec IN c_data LOOP
    UTL_FILE.PUT_LINE(v_file,
                      cur_rec.COLUMN_VALUE);
  END LOOP;
  UTL_FILE.FCLOSE(v_file);
  
EXCEPTION
  WHEN OTHERS THEN
    UTL_FILE.FCLOSE(v_file);
    RAISE;
END;
/

EXEC unload_txt_par;

select *
  from (
  select *
    from (select * from table(gen_num_par(Cursor(select /*+ PARALLEL(4)*/* from curs_fila))))
  order by dbms_random.random
  )
where rownum <= 50;


--De aqui en adelando es puro paralelismo--
------------------------------------------
------------------------------------------
------------------------------------------
------------------------------------------
connect udiplo
@%ORACLE_HOME%\rdbms\admin\UTLXPLAN.SQL

connect / as sysdba
@%ORACLE_HOME%\sqlplus\admin\PLUSTRCE.SQL
grant execute on sys.dbms_lock to udiplo;
GRANT PLUSTRACE TO udiplo;




DROP TABLE id_list;
CREATE TABLE id_list AS
SELECT ROWNUM id FROM all_objects WHERE ROWNUM <= 5000;
 
CREATE OR REPLACE TYPE private_rec IS OBJECT (
    id      NUMBER
,   data_1      NUMBER(16)
,   data_2      NUMBER(20)
,   date_1      DATE
,   date_2      DATE
);
/
CREATE OR REPLACE TYPE private_tab AS TABLE OF private_rec;
/

CREATE OR REPLACE FUNCTION retrieve_private_data(I_cursor IN SYS_REFCURSOR)
    RETURN private_tab PARALLEL_ENABLE(PARTITION I_cursor BY ANY) PIPELINED 
IS
    L_id_rec id_list%ROWTYPE;
    TYPE id_tab IS TABLE OF id_list%ROWTYPE;
    L_id_tab id_tab;
    L_num NUMBER := 0;
    L_start_time DATE := SYSDATE;
    L_end_time DATE;
BEGIN
    LOOP
        FETCH I_cursor BULK COLLECT INTO L_id_tab LIMIT 10; 
 
        L_num := L_num + L_id_tab.COUNT;
        FOR i IN 1 .. L_id_tab.COUNT LOOP
            --each retrieval of sensitive data takes 0.05 seconds
            dbms_lock.sleep(0.05);
 
            --in reality this is where the sensitive data would be piped back.
            --PIPE ROW(private_rec(L_id_tab(i).id,dbms_random.value(1,10),dbms_random.value(1,10),NULL,NULL));
        END LOOP;
 
        EXIT WHEN I_cursor%NOTFOUND;
    END LOOP;
    L_end_time := SYSDATE;
 
    -- pipe a row showing number of records processed by the call and the start and end time
    PIPE ROW(private_rec(L_num,NULL,NULL,L_start_time,L_end_time));
 
    CLOSE I_cursor;
END retrieve_private_data;
/

alter session set nls_date_format ='DD-MON-YYYY HH24:MI:SS';
set timing on
set autotrace on
SELECT * FROM table(retrieve_private_data(CURSOR(SELECT * FROM id_list i)));
set autotrace off

alter session set nls_date_format ='DD-MON-YYYY HH24:MI:SS';
set timing on
set autotrace on
SELECT * FROM table(retrieve_private_data(CURSOR(SELECT  /*+ PARALLEL(i 4)*/ * FROM id_list i)));
set autotrace off
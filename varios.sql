select r
  from (select r
           from (select rownum r
                   from all_objects
                  where rownum < 50)
          order by dbms_random.value)
  where rownum <= 6;

  create type arreglo
    as table of number
/

create function
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
    from (select * from table(gen_numbers(49)))
  order by dbms_random.random
  )
where rownum <= 6
/

DECLARE
BEGIN 
DBMS_OUTPUT.PUT_LINE(gen_numbers(49));
END;
/

create or replace view stats
as select 'STAT...' || a.name name, b.value
from v$statname a, v$mystat b
where a.statistic# = b.statistic#
union all
select 'LATCH.' || name, gets
from v$latch
union all
select 'STAT...Elapsed Time', hsecs from v$timer;

create table t1
as
select object_id id, object_name text
from all_objects;

create table t2
as
select t1.*, 0 session_id
from t1
where 1=0;

CREATE OR REPLACE TYPE t2_type
AS OBJECT (
id number,
text varchar2(30),
session_id number
)
/

create or replace type t2_tab_type
as table of t2_type
/


create or replace function parallel_pipelined( l_cursor in sys_refcursor )
return t2_tab_type
pipelined
parallel_enable ( partition l_cursor by any )
is
l_session_id number;
l_rec t1%rowtype;
begin
select sid into l_session_id
from v$mystat
where rownum =1;
loop
fetch l_cursor into l_rec;
exit when l_cursor%notfound;
pipe row(t2_type(l_rec.id,l_rec.text,l_session_id));
end loop;
close l_cursor;
return;
end;
/

grant create any directory to udiplo;

create or replace directory tmp as '/tmp'
/

create table all_objects_unload
organization external
( type oracle_datapump
default directory TMP
location( 'allobjects.dat' )
)
as
select *
  from (
  select *
    from (select * from table(gen_numbers(49)))
  order by dbms_random.random
  )
where rownum <= 6
/

create table juegos
organization external
( type oracle_datapump
default directory TMP
location( 'juegos.dat' )
)
as
select *
  from (
  select *
    from (select * from table(gen_numbers(49)))
  order by dbms_random.random
  )
where rownum <= 6
/

create type filas as table of number;
/

create table curs_fila as select * from table(genera_numeros(50000));

	ALTER TABLESPACE diplo ADD DATAFILE 'C:\ORACLEXE\ORADATA\XE\diplo3.dbf' SIZE 100M;

CREATE OR REPLACE FUNCTION genera_numeros(n in number DEFAULT null)
return filas
PIPELINED
as
BEGIN
 for i in 1..nvl(n,99999)
 loop
 pipe row(i);
 end loop;
 return;
end;
/

select * from table(genera_numeros(10));

select *
  from (
  select *
    from (select * from table(genera_numeros(20000))
  order by dbms_random.random
  ))
where rownum <= 50;


CREATE OR REPLACE FUNCTION gen_num_par(I_cursor IN SYS_REFCURSOR)
return filas parallel_enable(partition I_cursor BY any) PIPELINED
is
BEGIN
 for i in 1..20000
 loop
 pipe row(i);
 end loop;
 return;
end;
/
ñ
select * from table(gen_num_par(Cursor(select /*+ PARALLEL(4)*/* from curs_fila)));
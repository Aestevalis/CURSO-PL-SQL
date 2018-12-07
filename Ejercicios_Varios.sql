CREATE OR REPLACE PACKAGE paquete_empleo
AS
PROCEDURE agrega_empleo
(id_chamba IN jobs.job_id%TYPE,
tit_chamba IN jobs.job_title%TYPE);
PROCEDURE borra_empleo
(id_chamba IN jobs.job_id%TYPE);
PROCEDURE actualiza_empleo
(id_chamba IN jobs.job_id%TYPE,
salario_minimo IN jobs.min_salary%TYPE,
salario_maximo IN jobs.max_salary%TYPE);
FUNCTION obtiene_anios_servicio
(id_empleado IN employees.employee_id%TYPE)
RETURN NUMBER;
END paquete_empleo;
/


CREATE OR REPLACE PACKAGE BODY paquete_empleo
AS
PROCEDURE agrega_empleo
(id_chamba IN jobs.job_id%TYPE,
tit_chamba IN jobs.job_title%TYPE)
IS
v_id jobs.job_id%TYPE:=id_chamba;
v_ti jobs.job_title%TYPE:=tit_chamba;
BEGIN
INSERT INTO jobs(job_id, job_title) VALUES(UPPER(v_id),INITCAP(v_ti));
EXCEPTION
WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE('No se puede hacer la inserción en la tabla');
END agrega_empleo;
PROCEDURE borra_empleo
(id_chamba IN jobs.job_id%TYPE)
IS
v_id jobs.job_id%TYPE:=upper(id_chamba);
BEGIN
DELETE FROM jobs where job_id=v_id;
EXCEPTION
WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE('No se puede hacer el borrado de la tabla');
END borra_empleo;
PROCEDURE actualiza_empleo
(id_chamba IN jobs.job_id%TYPE,
salario_minimo IN jobs.min_salary%TYPE,
salario_maximo IN jobs.max_salary%TYPE)
IS
v_id jobs.job_id%TYPE:=id_chamba;
v_salmin jobs.min_salary%TYPE:=salario_minimo;
v_salmax jobs.max_salary%TYPE:=salario_maximo;
BEGIN
UPDATE jobs set min_salary=v_salmin, max_salary=v_salmax WHERE job_id=upper(v_id);
EXCEPTION
WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE('No se puede hacer la actualización de la tabla');
END actualiza_empleo;
FUNCTION obtiene_anios_servicio
(id_empleado IN employees.employee_id%TYPE)
RETURN NUMBER
IS
v_idemp employees.employee_id%TYPE:=id_empleado;
v_fecha employees.hire_date%TYPE;
v_anti NUMBER;
BEGIN
SELECT hire_date INTO v_fecha
FROM employees
WHERE employee_id=v_idemp;
v_anti:=TRUNC(months_between(sysdate,v_fecha)/12);
RETURN v_anti;
END obtiene_anios_servicio;
END paquete_empleo;
/

SET SERVEROUTPUT ON 
DECLARE
texto_id jobs.job_id%TYPE:='&v_id';
texto_tit jobs.job_title%TYPE:='&v_tit';
BEGIN

paquete_empleo.agrega_empleo(texto_id, texto_tit);
END;
/

SET SERVEROUTPUT ON 
DECLARE
texto_id jobs.job_id%TYPE:='&v_id';
BEGIN
paquete_empleo.borra_empleo(texto_id);
END;
/

SET SERVEROUTPUT ON 
DECLARE
texto_id jobs.job_id%TYPE:='&v_id';
v_salmin jobs.min_salary%TYPE:=&salario_minimo;
v_salmax jobs.max_salary%TYPE:=&salario_maximo;
BEGIN
paquete_empleo.actualiza_empleo(texto_id, v_salmin, v_salmax);
END;
/

SET SERVEROUTPUT ON 
DECLARE
result NUMBER;
BEGIN
result:=paquete_empleo.obtiene_anios_servicio(&v_id);
DBMS_OUTPUT.PUT_LINE(result);
END;
/



CREATE OR REPLACE TRIGGER new_emp_dept
INSTEAD OF INSERT ON emp_details
FOR EACH ROW
BEGIN
INSERT INTO new_emps VALUES (:NEW.employee_id, :NEW.last_name, :NEW.salary, :NEW.department_id, :NEW.email, :NEW.job_id, sysdate);
DELETE FROM new_depts;
INSERT INTO new_depts select d.department_id, d.department_name, d.location_id,
       sum (e.salary) tot_dept_sal
from new_emps e, departments d
where e.department_id= d.department_id
group by d.department_id, d.department_name, d.location_id;
END;
/

create table new_emps as 
  select employee_id, last_name, salary, department_id,
         email, job_id, hire_date
from employees;

create table new_depts as
 select d.department_id, d.department_name, d.location_id,
       sum (e.salary) tot_dept_sal
from employees e, departments d
where e.department_id= d.department_id
group by d.department_id, d.department_name, d.location_id;

create view emp_details as
 select e.employee_id, e.last_name, e.salary, e.department_id,
        e.email, e.job_id, d.department_name, d.location_id
from employees e, departments d
where e.department_id = d.department_id;

INSERT INTO emp_details VALUES (208,'Cabrera',15000,210, 'prueba@prueba.com', 'IT_SYST', 'IT Support', 1700);


CREATE OR REPLACE TRIGGER act_min_sal
AFTER UPDATE ON jobs
FOR EACH ROW
DECLARE
v_idtrab jobs.job_id%TYPE:=:NEW.job_id;
v_salmin jobs.min_salary%TYPE:=:NEW.min_salary;
BEGIN
UPDATE employees SET salary=v_salmin where job_id=v_idtrab and salary<v_salmin;
END;
/


CREATE OR REPLACE PROCEDURE upd_empm_sal
(id_trabajo jobs.job_id%TYPE,
sal_min jobs.min_salary%TYPE);
IS
v_idtrab jobs.job_id%TYPE:=id_trabajo;
v_salmin jobs.min_salary%TYPE:=sal_min;
BEGIN
UPDATE jobs SET min_salary=v_salmin WHERE job_id=v_idtrab;
END;
/

UPDATE jobs SET min_salary=5000 WHERE job_id='IT_PROG';

CREATE TABLE INFO_TABLA
(
	Usuario VARCHAR2(30),
	Nombre_Tabla VARCHAR2(30),
	Fecha DATE,
	Hora TIMESTAMP
);

CREATE OR REPLACE TRIGGER monitor_tabla
AFTER CREATE ON SCHEMA
DECLARE
nombre_tabla user_objects.object_name%TYPE;
BEGIN
IF SYS.DICTIONARY_OBJ_TYPE = 'TABLE' THEN
select object_name into nombre_tabla from user_objects where object_type='TABLE'
AND TIMESTAMP=(select MAX(TIMESTAMP) from user_objects where object_type='TABLE');
INSERT INTO INFO_TABLA VALUES (USER,nombre_tabla,SYSDATE,SYSDATE);
END IF;
END;
/


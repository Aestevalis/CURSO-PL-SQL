-- Practica 6 pagina 55 segunda presentación
CREATE OR REPLACE FUNCTION curso_profesor(num_prof instructor.instructor_id%TYPE)
RETURN varchar2
AS
v_clase number(3);
CURSOR c_instructor is
select i.instructor_id, i.first_name, i.last_name, count(unique(s.section_no)) as cuenta
from instructor i, section s
WHERE i.instructor_id=s.instructor_id
AND i.instructor_id=num_prof
GROUP BY i.instructor_id, i.first_name, i.last_name;
BEGIN
FOR r_instructor in c_instructor LOOP
v_clase:=r_instructor.cuenta;
END LOOP;
IF v_clase IS NULL THEN
RETURN('Este profesor no existe');
ELSIF v_clase>4 THEN
RETURN ('Por favor tomate vacaciones');
ELSE 
RETURN('Estas dando clases a '||v_clase||' secciones');
END IF;
END;
/

select curso_profesor(101) from dual;

CREATE OR REPLACE FUNCTION BOOLEAN_TO_CHAR(STATUS IN BOOLEAN)
RETURN VARCHAR2 IS
BEGIN
  RETURN
   CASE STATUS
     WHEN TRUE THEN 'VERDADERO'
     WHEN FALSE THEN 'FALSO'
     ELSE 'NULO'
   END;
END;



CREATE OR REPLACE FUNCTION	cod_post(codigo zipcode.zip%TYPE)
RETURN BOOLEAN
AS
v_codigo zipcode.zip%TYPE:=NULL;
BEGIN
select unique(zip) INTO v_codigo
from zipcode
WHERE zip=codigo;
RETURN FALSE;
EXCEPTION
WHEN OTHERS THEN
RETURN TRUE;
END;
/

begin
  dbms_output.put_line(boolean_to_char(cod_post('48104')));
end;
/

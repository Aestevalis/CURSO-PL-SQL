-- Clase del Sabado 10 de Noviembre de 2018

DECLARE
v_idestudiante student.student_id%type := &sv_idestudiante;
v_total_cursos NUMBER;
e_id_invalido EXCEPTION;
BEGIN
IF v_idestudiante < 0 THEN
RAISE e_id_invalido;
ELSE
SELECT COUNT(*)
INTO v_total_cursos
FROM enrollment WHERE student_id = v_idestudiante;
DBMS_OUTPUT.PUT_LINE ('El estudiante esta registrado en '||
v_total_cursos||' courses');
END IF;
DBMS_OUTPUT.PUT_LINE ('Ninguna excepcion ha sido encontrada');
EXCEPTION
WHEN e_id_invalido THEN DBMS_OUTPUT.PUT_LINE ('Un id no puede ser negativo');
END;
/



DECLARE
e_fechdeb EXCEPTION; --declaracion externa
v_numact NUMBER;
BEGIN
DECLARE ---------- empieza sub-bloque
e_fechdeb EXCEPTION; -- esta declaración (interna) prevalece
v_numact NUMBER;
fecha_debida DATE := SYSDATE - 1;
fecha_actual DATE := SYSDATE;
BEGIN
IF fecha_debida < fecha_actual THEN
RAISE e_fechdeb; -- Este no se maneja
END IF;
END; ------------- termina sub-bloque
EXCEPTION
WHEN e_fechdeb THEN
DBMS_OUTPUT.PUT_LINE
('Manejo de la excepcion e_fechdeb.');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE
('No es posible reconocer la excepcion e_fechdeb en este alcance.');
END;
/

SET SERVEROUTPUT ON
DECLARE
v_nombre_est VARCHAR2(15); ---linea 3
BEGIN
v_nombre_est := 'JOSE ANTONIO CORIA'; ---- linea 5
DBMS_OUTPUT.PUT_LINE ('Mi nombre es '||v_nombre_est);
DECLARE
v_nombre_din VARCHAR2(15);
BEGIN
v_nombre_din := '&sv_nombre_din';
DBMS_OUTPUT.PUT_LINE ('Tu nombre es '||v_nombre_din);
EXCEPTION
WHEN VALUE_ERROR THEN
DBMS_OUTPUT.PUT_LINE ('El nombre es muy largo (interno');
END;
EXCEPTION
WHEN VALUE_ERROR THEN
DBMS_OUTPUT.PUT_LINE ('El nombre es muy largo (externo)');
END;
/

DECLARE
v_cp zipcode.zip%type := '&sv_cp';
BEGIN
DELETE FROM zipcode
WHERE zip = v_cp;
DBMS_OUTPUT.PUT_LINE ('EL CP '||v_cp||' se ha borrado');
COMMIT;
END;
/


DECLARE
v_cp zipcode.zip%type := '&sv_cp';
e_existe_estudiante EXCEPTION;
PRAGMA EXCEPTION_INIT(e_existe_estudiante, -2292);
BEGIN
DELETE FROM zipcode
WHERE zip = v_cp;
DBMS_OUTPUT.PUT_LINE ('El CP '||v_cp||' se ha borrado');
COMMIT;
EXCEPTION
WHEN e_existe_estudiante THEN
DBMS_OUTPUT.PUT_LINE ('Primero se debe borrar estudiantes para este CP');
END;
/


DECLARE
v_idestudiante student.student_id%type := &sv_idestudiante;
v_total_cursos NUMBER;
BEGIN
IF v_idestudiante < 0 THEN
RAISE_APPLICATION_ERROR (-20000, 'Un id estudiante no puede ser negativo', true);
ELSE
SELECT COUNT(*)
INTO v_total_cursos
FROM enrollment
WHERE student_id = v_idestudiante;
DBMS_OUTPUT.PUT_LINE ('El estudiante esta registrado en: '||v_total_cursos||' cursos');
END IF;
END;
/



create or replace procedure valida_cupo 
is
  v_estudiantes NUMBER(3) := 0;
begin
  SELECT COUNT(*) INTO v_estudiantes
    FROM enrollment e, section s
   WHERE e.section_id = s.section_id
     AND s.course_no = 25
     AND s.section_id = 89;
    If v_estudiantes > 10 then
        RAISE_APPLICATION_ERROR (-20001, 'El curso tiene mas de 10 estudiantes', true);
    else
        DBMS_OUTPUT.PUT_LINE ('El Curso 25, sección 89 tiene '||v_estudiantes|| ' estudiantes');
    End if;    
End;


SET SERVEROUTPUT ON
DECLARE
    v_estudiantes NUMBER(3) := 0;
   e_curso_lleno EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_curso_lleno, -20001);
BEGIN
     valida_cupo;  
EXCEPTION
    WHEN e_curso_lleno THEN
       DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


/* SQLCODE y SQLERRM*/
/* Ingrese el valor  07548 */
/* En este ejemplo se muestra un mensaje de que  */
/* ocurrió un error en tiempo de ejecución, pero */
/* no se sabe que error es y que fue lo que causó */


DECLARE
v_zip VARCHAR2(5) := '&sv_zip';
v_city VARCHAR2(15);
v_state CHAR(2);
BEGIN
SELECT city, state
INTO v_city, v_state
FROM zipcode
WHERE zip = v_zip;
DBMS_OUTPUT.PUT_LINE (v_city||', '||v_state);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE ('Un error ocurrio');
END;
/

/*
Podría no existir el código ingresado en la
tabla de ZIPCODE, o quizás el tipo de datos 
podría no coincidir en el SELECT INTO. Existen
otras posibilidades que pueden dar pie a un
error en tiempo de ejecución. Es BUENA PRACTICA.
hacer uso de el manejo de excepciones OTHERS (atrapa el error que no haya sido
atrapado antes por otra excepción)
Oracle nos facilita dos funciones, empleadas con
OTHERS,
SQLCODE = nos regresa el número de error de oracle
SQLERRM = nos regresa el mensaje del error

*/

DECLARE
v_zip VARCHAR2(5) := '&sv_zip';
v_city VARCHAR2(15);
v_state CHAR(2);
v_err_code NUMBER;
v_err_msg VARCHAR2(200);
BEGIN
SELECT city, state
INTO v_city, v_state
FROM zipcode
WHERE zip = v_zip;
DBMS_OUTPUT.PUT_LINE (v_city||', '||v_state);
EXCEPTION
WHEN OTHERS THEN
v_err_code := SQLCODE;
v_err_msg := SUBSTR(SQLERRM, 1, 200);
DBMS_OUTPUT.PUT_LINE ('Codigo de Error: '||v_err_code);
DBMS_OUTPUT.PUT_LINE ('Mensaje de Error: '||v_err_msg);
END;
/

/* Ejercicio : 
Escribir un bloque pl/sql que:
seleccione el nombre de un empleado con
un valor de salario dado.
Emplear el comando DEFINE para proporcionar
el salario. Pasar el valor al bloque ,
a través de sustitución de variable.

Si el salario ingresado regresa más de una fila, manejar la excepción
con un manejador de exepción apropiado e insertarlo en una tabla
MENSAJES, ingresando el mensaje "Más de un empleado con un salario de <salario>"
Si no regresa ninguna fila, manejar la exepción e insertar el mensaje
"No existen empleados con un salario de <salario>"
Si el salario ingresado regresa una fila, insertar un mensaje en la tabla
MENSAJES, con el nombre del empleado y la cantidad de salario.

Manejar cualquier otra excepción, con un un manejo de exepciones apropiado,
e insertar el mensaje "Algun otro error ocurrio"

Cambie el mensaje si ocurre alguna otra excepción, por el codigo y el mensaje
de error e ingreselo en la tabla MENSAJES.
*/



--Triggers o Disparadores

CREATE OR REPLACE TRIGGER Imprime_cambio_salario
BEFORE DELETE OR INSERT OR UPDATE ON trabajadores
FOR EACH ROW
DECLARE
dif_sal number;
BEGIN
dif_sal := :NEW.Sueldo - :OLD.Sueldo;
dbms_output.put('Salario anterior: ' || :OLD.Sueldo);
dbms_output.put('Nuevo Salario: ' || :NEW.Sueldo);
dbms_output.put_line(' Diferencia: ' || dif_sal);
END;
/

UPDATE trabajadores SET sueldo = sueldo - 500.00 WHERE nombre = 'Boo';

begin
  dbms_output.put_line(sys.diutil.bool_to_int(true));
end;

CREATE OR REPLACE TRIGGER ai_estudiante
BEFORE INSERT ON student
FOR EACH ROW
DECLARE
v_id_estudiante STUDENT.STUDENT_ID%TYPE;
BEGIN
SELECT STUDENT_ID_SEQ.NEXTVAL
INTO v_id_estudiante
FROM dual; /* Esta tabla es utilizada en oracle cuando se necesita ejecutar un comando
SQL que no tiene lógicamente el nombre de tabla */
:NEW.student_id := v_id_estudiante; /* :NEW pseudoregistro */
:NEW.created_by := USER;
:NEW.created_date := SYSDATE;
:NEW.modified_by := USER;
:NEW.modified_date := SYSDATE;
END;
/

INSERT INTO student (first_name, last_name, zip, registration_date)
VALUES ('Jesus', 'Vazquez', '00914', SYSDATE);


CREATE TABLE estadisticas
(
TABLE_NAME VARCHAR2(30),
TRANSACTION_NAME VARCHAR2(10),
TRANSACTION_USER VARCHAR2(30),
TRANSACTION_DATE DATE
);

CREATE OR REPLACE TRIGGER dad_instructor
AFTER UPDATE OR DELETE ON INSTRUCTOR
DECLARE
v_tipo VARCHAR2(10);
BEGIN
IF UPDATING THEN
v_tipo := 'UPDATE';
ELSIF DELETING THEN
v_tipo := 'DELETE';
END IF;
UPDATE estadisticas
SET transaction_user = USER,
transaction_date = SYSDATE
WHERE table_name = 'INSTRUCTOR'
AND transaction_name = v_tipo;
IF SQL%NOTFOUND THEN /* se evalúa en Verdadero si la sentencia update no actualizó ningún registro*/
INSERT INTO estadisticas VALUES ('INSTRUCTOR', v_tipo, USER, SYSDATE);
END IF;
END;
/

CREATE OR REPLACE TRIGGER aia_instructor
BEFORE INSERT OR UPDATE OR DELETE ON scott.INSTRUCTOR
DECLARE
v_dia VARCHAR2(10);
BEGIN
v_ddia := RTRIM(TO_CHAR(SYSDATE, 'DAY'));
IF v_dia LIKE ('S%') THEN /* fecha en sabado o domingo, notación inglés*/
RAISE_APPLICATION_ERROR (-20000, 'una tabla no puede ser modificada durante horarios fuera de
oficina');
END IF;
END;

CREATE OR REPLACE TRIGGER aia_instructor
BEFORE INSERT OR UPDATE OR DELETE ON INSTRUCTOR
DECLARE
v_dia VARCHAR2(10);
BEGIN
v_dia := RTRIM(TO_CHAR(SYSDATE, 'DAY'));
IF v_dia LIKE ('F%') THEN /* fecha en sabado o domingo, notación inglés*/
RAISE_APPLICATION_ERROR (-20000, 'una tabla no puede ser modificada durante horarios fuera de oficina');
END IF;
END;
/

UPDATE instructor
SET zip = 10025
WHERE zip = 10015;


CREATE VIEW instructor_vista_resumen AS
SELECT i.instructor_id, COUNT(s.section_id) total_courses
FROM instructor i
LEFT OUTER JOIN section s ON (i.instructor_id = s.instructor_id)
GROUP BY i.instructor_id;

DELETE FROM instructor_vista_resumen
WHERE instructor_id = 109;

CREATE OR REPLACE TRIGGER eld_instructor_resumen
INSTEAD OF DELETE ON instructor_vista_resumen
FOR EACH ROW
BEGIN
DELETE FROM instructor
WHERE instructor_id = :OLD.INSTRUCTOR_ID;
END;
/

DELETE FROM instructor_vista_resumen
WHERE instructor_id = 109;

CREATE OR REPLACE PACKAGE maneja_estudiantes
AS
PROCEDURE encuentra_nombre_est
(i_idestudiante IN student.student_id%TYPE,
o_nombre OUT student.first_name%TYPE,
o_apellido OUT student.last_name%TYPE
);
FUNCTION id_es_valido
(i_idestudiante IN student.student_id%TYPE)
RETURN BOOLEAN;
END maneja_estudiantes;
/



CREATE OR REPLACE PACKAGE BODY maneja_estudiantes
AS
PROCEDURE encuentra_nombre_est
(i_idestudiante IN student.student_id%TYPE,
o_nombre OUT student.first_name%TYPE,
o_apellido OUT student.last_name%TYPE
)
IS
v_idestudiante student.student_id%TYPE;
BEGIN
SELECT first_name, last_name
INTO o_nombre, o_apellido
FROM student
WHERE student_id = i_idestudiante;
EXCEPTION
WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE
('Error para encontrar al id_estudiante: '||v_idestudiante);
END encuentra_nombre_est;
FUNCTION id_es_valido
(i_idestudiante IN student.student_id%TYPE)
RETURN BOOLEAN
IS
v_idcontador number;
BEGIN
SELECT COUNT(*)
INTO v_idcontador
FROM student
WHERE student_id = i_idestudiante;
RETURN 1 = v_idcontador;
EXCEPTION
WHEN OTHERS
THEN
RETURN FALSE;
END id_es_valido;
END maneja_estudiantes;
/


SET SERVEROUTPUT ON
DECLARE
v_nombre student.first_name%TYPE;
v_apellido student.last_name%TYPE;
BEGIN
IF maneja_estudiantes.id_es_valido(&&v_id) /* se pide el valor y se define la variable como el valor.
Cualquier referencia subsecuente no se pedirá el valor nuevamente */
THEN
maneja_estudiantes.encuentra_nombre_est(&&v_id, v_nombre,
v_apellido);
DBMS_OUTPUT.PUT_LINE('Estudiante No. '||&&v_id||' es '
||v_apellido||', '||v_nombre);
ELSE
DBMS_OUTPUT.PUT_LINE
('El ID Estudiante: '||&&v_id||' no esta en la base de datos.');
END IF;
END;
/
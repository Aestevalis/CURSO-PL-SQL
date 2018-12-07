-- Clase Viernes 26 de Octubre de 2018
-- Cursores Avanzados

--Ejemplo de la pagina 5 Segunda Presentación
-- Cursos Anidado a traves de un FOR...LOOP que hace el open, fetch y close de manera implicita
SET SERVEROUTPUT ON
SET ECHO ON
DECLARE
CURSOR c_cp (p_estado IN zipcode.state%TYPE)
IS
SELECT zip, city, state
FROM zipcode
WHERE state = p_estado;
BEGIN
FOR r_zip IN c_cp('NJ') LOOP
DBMS_OUTPUT.PUT_LINE(r_zip.city||' '||r_zip.zip);
END LOOP;
END;
/


-- Script de la pagina 8 Segunda Presentación
DECLARE
v_zip zipcode.zip%TYPE;
v_student_flag CHAR;
CURSOR c_zip IS
SELECT zip, city, state
FROM zipcode
WHERE state = 'CT';
CURSOR c_student IS
SELECT first_name, last_name
FROM student
WHERE zip = v_zip;
BEGIN
FOR r_zip IN c_zip
LOOP
v_student_flag := 'N';
v_zip := r_zip.zip;
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('El estudiante vive en '|| r_zip.city);
FOR r_student in c_student
LOOP
DBMS_OUTPUT.PUT_LINE( r_student.first_name||' '||r_student.last_name);
v_student_flag := 'Y';
END LOOP;
IF v_student_flag = 'N' THEN
DBMS_OUTPUT.PUT_LINE
('No existen estudiantes para ese código postal');
END IF;
END LOOP;
END;
/

-- Script de la pagina 10 Segunda presentación.
SET SERVEROUTPUT ON
DECLARE
v_amount course.cost%TYPE;
v_instructor_id instructor.instructor_id%TYPE;
CURSOR c_inst IS
SELECT first_name, last_name, instructor_id
FROM instructor;
CURSOR c_cost IS
SELECT c.cost
FROM course c, section s, enrollment e
WHERE s.instructor_id = v_instructor_id
AND c.course_no = s.course_no
AND s.section_id = e.section_id;
BEGIN
FOR r_inst IN c_inst
LOOP
v_instructor_id := r_inst.instructor_id;
v_amount := 0;
DBMS_OUTPUT.PUT_LINE( 'Cantidad generada por instructor '||
r_inst.first_name||' '||r_inst.last_name ||' es');
FOR r_cost IN c_cost
LOOP
v_amount := v_amount + NVL(r_cost.cost, 0);
END LOOP;
DBMS_OUTPUT.PUT_LINE (' '||TO_CHAR(v_amount,'$999,999'));
END LOOP;
END;
/
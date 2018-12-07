--Practica 2

-- Ejercicio 1
SET SERVEROUTPUT ON
SET ECHO ON
DECLARE
CURSOR c_sp (p_ciudad IN zipcode.city%TYPE)
IS
SELECT zip, state, city
FROM zipcode
WHERE city = p_ciudad;
BEGIN
FOR r_zip IN c_sp('Brooklyn') LOOP
DBMS_OUTPUT.PUT_LINE(r_zip.state||' '||r_zip.zip);
END LOOP;
END;
/

--Ejercicio 2
DECLARE
v_secid section.section_id%TYPE;
v_cuenta NUMBER(8);
CURSOR c_course IS
SELECT c.course_no, c.description, s.section_no, s.section_id
FROM course c, section s
WHERE c.course_no=s.course_no;
CURSOR c_enroll IS
SELECT  s.section_no, e.student_id
FROM enrollment e, section s
WHERE s.section_id=e.section_id
AND s.section_id=v_secid;
BEGIN
	FOR r_course IN c_course LOOP
	v_secid := r_course.section_id;
	v_cuenta := 0;
		FOR r_enroll IN c_enroll LOOP
		v_cuenta := v_cuenta + 1;
		END LOOP;
	DBMS_OUTPUT.PUT_LINE ('EL curso '||r_course.description||' de la seccion '||r_course.section_no||' tiene '||' '||v_cuenta||' alumnos');
	END LOOP;
END;
/


--Ejercicio 3

DECLARE
v_stud_id grade.student_id%TYPE;
v_sec_id grade.section_id%TYPE;
CURSOR c_estu IS
select first_name,last_name,student_id
FROM student st;
CURSOR c_curso IS
SELECT c.description, e.student_id, s.section_id, s.section_no
FROM enrollment e, section s, course c
WHERE e.student_id=v_stud_id
AND s.section_id=e.section_id
AND c.course_no=s.course_no;
CURSOR c_cali IS
select g.student_id,g.section_id, g.grade_type_code, gt.description, avg(g.numeric_grade) as prom
FROM grade g, grade_type gt
WHERE g.grade_type_code=gt.grade_type_code
and g.student_id=v_stud_id
and g.section_id=v_sec_id
GROUP BY g.student_id,g.section_id, g.grade_type_code, gt.description;
BEGIN
FOR r_estu IN c_estu LOOP
DBMS_OUTPUT.PUT_LINE ('Alumno: '||r_estu.first_name||' '||r_estu.last_name);
v_stud_id:=r_estu.student_id;
		FOR r_curso in c_curso LOOP
		DBMS_OUTPUT.PUT_LINE (chr(9)||'Calificaciones del Curso: '||r_curso.description||' de la seccion número: '||r_curso.section_no);
		v_sec_id:=r_curso.section_id;
				FOR r_cali IN c_cali LOOP 
				DBMS_OUTPUT.PUT_LINE (chr(9)||to_char(r_cali.prom,'99.99')||' '||r_cali.description);
				END LOOP;
		END LOOP;
END LOOP;
END;
/

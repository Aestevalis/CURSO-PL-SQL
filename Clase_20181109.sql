-- Clase del Viernes 09 de Noviembre de 2018

--EJEMPLO VARRAY (1/2) pagina 36 y 37 segunda presentación
DECLARE
TYPE integer_varray IS VARRAY(3) OF INTEGER;
varray_integer INTEGER_VARRAY := integer_varray(NULL,NULL,NULL);
BEGIN
dbms_output.put (CHR(10));
dbms_output.put_line('Varray inicializado con NULLS.');
dbms_output.put_line('--------------------------------');
FOR i IN 1..3 LOOP
dbms_output.put ('Varray de enteros ['||i||'] ');
dbms_output.put_line('['||varray_integer(i)||']');
END LOOP;
varray_integer(1) := 11;
varray_integer(2) := 12;
varray_integer(3) := 13;
dbms_output.put (CHR(10));
dbms_output.put_line('Varray inicializado con valores.');
dbms_output.put_line('---------------------------------');
FOR i IN 1..3 LOOP
dbms_output.put_line('Varray de enteros ['||i||'] '|| '['||varray_integer(i)||']');
END LOOP;
END;
/


-- Ejempo 2 VARRAY pagina 38 segunda presentación
DECLARE
CURSOR c_nombre IS
SELECT last_name
FROM student
WHERE rownum <= 10;
TYPE tipo_apellido IS VARRAY(10) OF student.last_name%TYPE;
varray_apellido tipo_apellido := tipo_apellido();
v_contador INTEGER := 0;
BEGIN
FOR reg_nombre IN c_nombre LOOP
v_contador := v_contador + 1;
varray_apellido.EXTEND;
varray_apellido(v_contador) := reg_nombre.last_name;
DBMS_OUTPUT.PUT_LINE ('Apellido('||v_contador||'): '|| varray_apellido(v_contador));
END LOOP;
END;
/

-- Practica 4 pagina 39 segunda presentación
DECLARE
CURSOR c_ciudad IS
SELECT city
FROM zipcode
WHERE rownum <= 10;
TYPE tipo_ciudad IS VARRAY(10) OF zipcode.city%TYPE;
varray_ciudad tipo_ciudad:= tipo_ciudad();
v_contador INTEGER := 0;
BEGIN
FOR reg_ciudad IN c_ciudad LOOP
v_contador := v_contador + 1;
varray_ciudad.EXTEND;
varray_ciudad(v_contador) := reg_ciudad.city;
DBMS_OUTPUT.PUT_LINE('Varray_ciudad('||v_contador||'): '||
varray_ciudad(v_contador));
END LOOP;
END;
/


-- Ejemplo Registro pagina 41 segunda presentación
DECLARE
rec_curso course%ROWTYPE;
BEGIN
SELECT *
INTO rec_curso
FROM course
WHERE course_no = 25;
DBMS_OUTPUT.PUT_LINE ('Curso No: '||rec_curso.course_no);
DBMS_OUTPUT.PUT_LINE ('Descripción del Curso: '||rec_curso.description);
DBMS_OUTPUT.PUT_LINE ('Prerequisito: '||rec_curso.prerequisite);
END;
/


-- Ejemplo Registro con Cursor pagina 43 segunda persentación
DECLARE
CURSOR c_estudiante IS
SELECT first_name, last_name, registration_date
FROM student
WHERE rownum <= 4;
reg_estudiante c_estudiante%ROWTYPE;
BEGIN
OPEN c_estudiante;
LOOP
FETCH c_estudiante INTO reg_estudiante;
EXIT WHEN c_estudiante%NOTFOUND;
DBMS_OUTPUT.PUT_LINE ('Nombre: '|| reg_estudiante.first_name||' '||reg_estudiante.last_name);
DBMS_OUTPUT.PUT_LINE ('Fecha de Registro: '|| reg_estudiante.registration_date);
END LOOP;
END;
/

-- Ejemplo de Función pagina 50 segunda presentación
CREATE OR REPLACE FUNCTION muestra_descripcion
(i_numcurso course.course_no%TYPE)
RETURN varchar2
AS
v_descripcion varchar2(50);
BEGIN
SELECT description
INTO v_descripcion
FROM course
WHERE course_no = i_numcurso;
RETURN v_descripcion;
EXCEPTION
WHEN NO_DATA_FOUND
THEN
RETURN('El curso no esta en la base de datos');
WHEN OTHERS
THEN
RETURN('Error al ejecutar la funcion muestra descripcion');
END;
/

SET SERVEROUTPUT ON
DECLARE
v_descripcion VARCHAR2(50);
BEGIN
dbms_output.put (CHR(10));
v_descripcion:= muestra_descripcion(350);
dbms_output.put_line('El curso buscado es:'||v_descripcion);
dbms_output.put (CHR(10));
END;
/

--Ejemplo función pagina 52 segunda presentación
declare
v_pi NUMBER:=3.14;
function f_obtieneDiferencia(i_rad1 NUMBER,i_rad2 NUMBER)
return NUMBER is
v_area1 NUMBER;
v_area2 NUMBER;
v_salida NUMBER;
function f_obtieneArea (i_rad NUMBER)
return NUMBER
is
begin
return v_pi*(i_rad**2);
end;
begin
v_area1 := f_obtieneArea (i_rad1);
v_area2 := f_obtieneArea (i_rad2);
v_salida :=v_area1-v_area2;
return v_salida;
end;
begin
DBMS_OUTPUT.put_line ('Diferencia entre 3 y 4: '||f_obtieneDiferencia(4,3));
DBMS_OUTPUT.put_line ('Diferencia entre 4 y 5: '||f_obtieneDiferencia(5,4));
DBMS_OUTPUT.put_line ('Diferencia entre 5 y 6: '||f_obtieneDiferencia(6,5));
end;
/

--Ejemplo función pagina 54 segunda presentación
DECLARE
v_idcurso NUMBER:=350;
v_costo NUMBER;
v_descripcion VARCHAR(50);
BEGIN
select cost,muestra_descripcion(v_idcurso)
into v_costo,v_descripcion
from course
where course_no=v_idcurso;
dbms_output.put (CHR(10));
DBMS_OUTPUT.put_line ('Curso: '||v_descripcion||' '||'Costo:'||v_costo);
dbms_output.put (CHR(10));
END;
/

-- Manejo de errores pagina 56 segunda presentación
DECLARE
v_num1 INTEGER := &sv_num1;
v_num2 INTEGER := &sv_num2;
v_result NUMBER;
BEGIN
v_result := v_num1 / v_num2;
DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
END;
/

--Mismo ejemplo corregido en pagina 59 segunda presentación
DECLARE
v_num1 INTEGER := &sv_num1;
v_num2 INTEGER := &sv_num2;
v_result NUMBER;
BEGIN
v_result := v_num1 / v_num2;
DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
EXCEPTION
WHEN ZERO_DIVIDE THEN
DBMS_OUTPUT.PUT_LINE ('Un número no puede ser dividido por cero.');
END;
/

-- Ejemplo manejo de errores pagina 65 segunda presentación
DECLARE
emp_column VARCHAR2(30) := 'last_name';
table_name VARCHAR2(30) := 'employees';
temp_var VARCHAR2(30);
BEGIN
temp_var := emp_column;
SELECT COLUMN_NAME INTO temp_var FROM USER_TAB_COLS
WHERE TABLE_NAME = 'EMPLOYEES'
AND COLUMN_NAME = UPPER(emp_column);
temp_var := table_name;
SELECT OBJECT_NAME INTO temp_var FROM USER_OBJECTS
WHERE OBJECT_NAME = UPPER(table_name)
AND OBJECT_TYPE = 'TABLE';
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('No se encontraron Datos para SELECT en ' || temp_var);
END;
/

--Practica 7 pagina 66 segunda presentación
SET SERVEROUTPUT ON
DECLARE
v_numero NUMBER := &sv_numero;
BEGIN
DBMS_OUTPUT.PUT_LINE ('La raiz cuadrada de '||v_numero||' es '||SQRT(v_numero));
EXCEPTION
WHEN VALUE_ERROR THEN
DBMS_OUTPUT.PUT_LINE ('Un numero no puede ser negativo');
END;
/


declare
v_texto VARCHAR2(50):= 'Imprime la <in> linea';
procedure p_imprime
(i_cadena_texto in VARCHAR2,
i_reemplazo_texto in VARCHAR2 := 'nueva')
is
begin
DBMS_OUTPUT.put_line(replace(i_cadena_texto,
'<in>', i_reemplazo_texto));
end p_imprime;
begin
p_imprime (v_texto,'primera');
p_imprime (v_texto,'segunda');
p_imprime (v_texto);
end;
/

-- Clase 19/10/2018
--50% examem
--50% proyecto, citado con formato APA
--Punto Extra: Todos los ejercicios resueltos
--Para presentar trabajos seguir el formato que viene como ejemplos de los PDF y para el proyecto usar formato APA para citar referencias bibliograficas
--Para el examen se puede utilizar acorden, el cual no puede ser electronico, pero no aplica ninguna otra restricción

SET serveroutput on;

DECLARE
var_nombre VARCHAR2(35);
var_apellido VARCHAR2(35);
BEGIN
SELECT fname, iname
INTO var_nombre, var_apellido
FROM client
WHERE clientno = 'CR100';
DBMS_OUTPUT.PUT_LINE ('Nombre de Cliente: '||var_nombre||' '||
var_apellido);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE ('No existe un cliente con '||
'numero de cliente CR100');
END;
/

--Ejercicio que se puede usar crear el documento para punto extra, capturar la pantalla de resultado
SET SERVEROUTPUT ON;
DECLARE
v_cadena varchar2(20):='Hola
Mundo';
BEGIN
dbms_output.put_line(v_cadena);
END
/

--Este siguiente codigo no sirve, por que esta usando una palabra reservada como variable y manda muchos errores
set serveroutput on size 5000;
declare
exception varchar2(15);
Begin
exception:='Esto es un ejercicio para no usar
palabras reservadas';
dbms_output.put_line(exception);
End;
/

SET SERVEROUTPUT ON;
DECLARE
v_var1 NUMBER(5,3);
v_var2 NUMBER(5,3);
v_var3 NUMBER(5,3);
BEGIN
v_var1 := 11.234;
v_var2 := 12.345;
v_var3 := v_var1 + v_var2;
DBMS_OUTPUT.PUT_LINE('v_var1: '||v_var1);
DBMS_OUTPUT.PUT_LINE('v_var2: '||v_var2);
DBMS_OUTPUT.PUT_LINE('v_var3: '||v_var3);
END;
/



SET SERVEROUTPUT ON;
DECLARE
v_var1 NUMBER(5,3);
v_var2 NUMBER(5,3);
v_var3 NUMBER(5,3);
BEGIN
v_var1 := 3;
v_var2 := 3;
v_var3 := v_var1 ** v_var2;
DBMS_OUTPUT.PUT_LINE('v_var1: '||v_var1);
DBMS_OUTPUT.PUT_LINE('v_var2: '||v_var2);
DBMS_OUTPUT.PUT_LINE('v_var3: '||v_var3);
END;
/


DECLARE
-- Definir variable booleana
v_bool BOOLEAN;
BEGIN
-- La funcion NVL. Sustituye un valor cuando un valor nulo es encontrado
IF NOT NVL(v_bool,FALSE) THEN
dbms_output.put_line('Esto debe mostrarse');
ELSE
dbms_output.put_line('Esto no debe mostrarse');
END IF;
END;
/


-- Estructura de Control: LOOP
DECLARE
x NUMBER := 0;
BEGIN
LOOP -- Depués de la declaración CONTINUE, el control continua aqui control
DBMS_OUTPUT.PUT_LINE ('Ciclo interno: x = ' || TO_CHAR(x));
x := x + 1;
--CONTINUE WHEN x < 3; -- Sentencia válida para oracle 11g
DBMS_OUTPUT.PUT_LINE
('Ciclo interno, despues de CONTINUE: x = ' || TO_CHAR(x));
EXIT WHEN x = 5;
END LOOP;
DBMS_OUTPUT.PUT_LINE ('Despues del Loop: x = ' || TO_CHAR(x));
END;
/

-- Estructura de Control: WHILE
declare
v_test varchar2(8) := 'SIGUE';
n_numb number := 2;
begin
while v_test <> 'PARA' loop
if n_numb > 5
then v_test := 'PARA';
end if;
dbms_output.put_line (v_test||': '||n_numb);
n_numb := n_numb + 1;
end loop;
v_test := 'ABAJO';
while n_numb > 1 AND v_test = 'ABAJO' loop
dbms_output.put_line (v_test||': '||n_numb);
n_numb := n_numb - 1;
end loop;
while 7 = 4 loop
NULL; -- no entra aqui
end loop;
end;

-- Estructura de Control: FOR
BEGIN
FOR i IN REVERSE 1..10 LOOP
dbms_output.put_line('El valor del indice es ['||i||']');
END LOOP;
END;
/


-- Estructura de Control: CASE
BEGIN
CASE TRUE
WHEN (1 > 3) THEN
dbms_output.put_line('Uno es mayor que tres');
WHEN (3 < 5) THEN
dbms_output.put_line('Tres es menor que cinco');
WHEN (1 = 2) THEN
dbms_output.put_line('Uno es igual a dos');
ELSE
dbms_output.put_line('Nada es cierto.');
END CASE;
END;
/

--Cursos Implicito
DECLARE
vdescripcion VARCHAR2(50);
BEGIN
SELECT desc_pais
INTO vdescripcion
from PAIS
WHERE id_PAIS = '2';
dbms_output.put_line('La lectura del cursor es: '
|| vdescripcion);
end;
/

--Cursos Explicito
DECLARE
CURSOR c_paises is
select id_pais, desc_pais
from pais;
v_pais varchar2(3);
v_descripcion varchar2(50);
BEGIN
OPEN c_paises;
FETCH c_paises INTO v_pais,v_descripcion;
while c_paises%FOUND
LOOP
dbms_output.put_line(chr(13));
dbms_output.put_line('la lectura del cursos es:'||v_pais||'
'||v_descripcion);
FETCH c_paises INTO v_pais,v_descripcion;
END LOOP;
CLOSE c_paises;
END;
/

DECLARE
CURSOR c_equipos is
select e.id_equipo,e.desc_equipo,p.desc_pais
FROM equipo e, pais p
WHERE e.id_pais=p.id_pais;
v_equipo varchar2(3);
v_descripcion varchar2(50);
v_pais varchar2(50);
BEGIN 
OPEN c_equipos;
FETCH c_equipos INTO v_equipo,v_descripcion,v_pais;
WHILE c_equipos%FOUND
LOOP
dbms_output.put_line(chr(13));
dbms_output.put_line('la lectura del cursos es:'||v_equipo||'
'||v_descripcion||' de '||v_pais);
FETCH c_equipos INTO v_equipo,v_descripcion,v_pais;
END LOOP;
CLOSE c_equipos;
END;
/

DECLARE
CURSOR c_equipos is
select e.id_equipo,e.desc_equipo,p.desc_pais
FROM equipo e, pais p
WHERE e.id_pais=p.id_pais;
vr_equipos c_equipos%ROWTYPE;
BEGIN 
OPEN c_equipos;
LOOP
FETCH c_equipos INTO vr_equipos;
EXIT WHEN c_equipos%NOTFOUND;
dbms_output.put_line('la lectura del cursos es:'||vr_equipos.id_equipo||' '||vr_equipos.desc_equipo||' de '||vr_equipos.desc_pais);
END LOOP;
CLOSE c_equipos;
END;
/
--Practica 1
--Ejercicio 1
create or replace procedure separacadena
(v_cadori IN VARCHAR2,
v_cad1 OUT VARCHAR2,
v_cad2 OUT VARCHAR2)
AS
BEGIN
IF length(v_cadori)<60 THEN v_cad1:=v_cadori;
v_cad2:='No hay cadena';
ELSE
v_cad1:=substr(v_cadori,1,instr(v_cadori,' ',(60-length(v_cadori)),1));
v_cad2:=substr(v_cadori,instr(v_cadori,' ',(60-length(v_cadori)),1)+1,length(v_cadori)-instr(v_cadori,' ',(60-length(v_cadori)),1));
END IF;
END separacadena;
/

CREATE GLOBAL TEMPORARY TABLE temp_texto
(
texto1 VARCHAR2(60),
texto2 VARCHAR2(120)
)
ON COMMIT DELETE ROWS;

SET SERVEROUTPUT ON
DECLARE
v_cadori VARCHAR2(120):='&cadenacompleta';
v_cad1 VARCHAR2(120);
v_cad2 VARCHAR2(120);
BEGIN
separacadena(v_cadori,v_cad1,v_cad2);
DBMS_OUTPUT.PUT_LINE (v_cad1);
DBMS_OUTPUT.PUT_LINE (v_cad2);
INSERT INTO temp_texto VALUES(v_cad1,v_cad2);
END;
/

--4 Construir Salida
DECLARE
v_nombre trabajadores.nombre%TYPE;
v_sueldo trabajadores.salporhora%TYPE;
CURSOR c_trabajador IS
SELECT nombre
FROM trabajadores;
CURSOR c_sueldo IS
SELECT nombre, salporhora*horastrabajadas sueldo
FROM trabajadores
WHERE nombre=v_nombre;
BEGIN
FOR r_trabajador IN c_trabajador LOOP
v_nombre:=r_trabajador.nombre;
FOR r_sueldo in c_sueldo LOOP
v_sueldo:=r_sueldo.sueldo;
DBMS_OUTPUT.PUT_LINE('El empleado :['||v_nombre||']');
DBMS_OUTPUT.PUT_LINE('tiene un sueldo sin impuestos de:['||to_char((v_sueldo)*(1-0.16),'$999,999.99')||']');
DBMS_OUTPUT.PUT_LINE('Sueldo mas iva:['||to_char((v_sueldo)*(1.16),'$999,999.99')||']');
DBMS_OUTPUT.PUT_LINE('Sueldo menos 10% isr, y 10% iva:['||to_char((v_sueldo)*(0.9)*(0.9),'$999,999.99')||']');
DBMS_OUTPUT.PUT_LINE('su sueldo neto es de:['||numero_a_texto(round((v_sueldo)*(0.9)*(0.9)+1,0))||']');
END LOOP;
DBMS_OUTPUT.PUT_LINE('================================================================================');
END LOOP;
END;
/
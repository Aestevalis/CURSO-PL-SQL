--Practica 4 Pagina 39 Segunda Presentación

DECLARE
CURSOR c_ciudad IS
SELECT city
FROM zipcode
WHERE rownum <= 10;
TYPE tipo_ciudad IS VARRAY(10) OF zipcode.city%TYPE;
varray_ciudad tipo_ciudad:=tipo_ciudad(); --faltaba inicializar
v_contador INTEGER := 0;
BEGIN
FOR reg_ciudad IN c_ciudad LOOP
v_contador := v_contador + 1;
varray_ciudad.EXTEND; --faltaba extender para poder escribir
varray_ciudad(v_contador) := reg_ciudad.city;
DBMS_OUTPUT.PUT_LINE('Varray_ciudad('||v_contador||'): '||varray_ciudad(v_contador));
END LOOP;
END;
/
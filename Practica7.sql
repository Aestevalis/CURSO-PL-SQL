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
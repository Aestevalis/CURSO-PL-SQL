--Clase 20/10/2018

--Ejercicio pagina 54 primera presentación
set serveroutput on;
BEGIN
DBMS_OUTPUT.PUT_LINE ('HOLA MUNDO');
END;
/

--Aqui se corrio el archivo donde se guardo el codigo anterior
--Hay que guardar el archivo como extension .pls desde un bloc de notas por ejemplo
@'N:\DiplomadoBD\Modulo3\2.pls';


--Ejercicio pagina 55 primera presentación
DECLARE
d DATE := SYSTIMESTAMP;
t TIMESTAMP(3) := SYSTIMESTAMP;
BEGIN
dbms_output.put_line('DATE ['||d||']');
dbms_output.put_line('TO_CHAR ['||
TO_CHAR(d,'DD-MON-YY HH24:MI:SS')||']');
dbms_output.put_line('TIMESTAMP ['||t||']');
END;
/

--Ejercicio pagina 56 primera presentación
DECLARE
nombre VARCHAR2(30);
BEGIN
nombre := '&entrada';
dbms_output.put_line('Hola '|| nombre );
END;
/

--Ejercicio pagina 57 primera presentación
DECLARE
CURSOR c_ejercicio IS
SELECT desc_equipo FROM equipo;
BEGIN
FOR i IN c_ejercicio LOOP
dbms_output.put_line('El equipo es ['||i.desc_equipo||']');
END LOOP;
END;
/

--Ejercicio pagina 58 primera presentación
DECLARE
var_numero NUMBER := &numero;
var_resultado NUMBER;
BEGIN
var_resultado := POWER(var_numero,2);
DBMS_OUTPUT.PUT_LINE ('El resultado es: '||var_resultado);
END;
/

--Ejercicio pagina 59 primera presentación
CREATE TABLE trabajadores
(
nombre varchar2(50),
salporhora number(8,2),
horastrabajadas number(10)
);

INSERT INTO trabajadores values('Mario','100','100');
INSERT INTO trabajadores values('Luigi','110','500');
INSERT INTO trabajadores values('Bowser','120','110');
INSERT INTO trabajadores values('Toad','130','95');
INSERT INTO trabajadores values('Peach','140','44');
INSERT INTO trabajadores values('Lakitu','150','23');
INSERT INTO trabajadores values('Koopa','160','22');
INSERT INTO trabajadores values('Koopa Paratroopa','170','11');
INSERT INTO trabajadores values('Daisey','180','130');
INSERT INTO trabajadores values('Rosalina','190','150');

SET SERVEROUTPUT ON
DECLARE
CURSOR ctrabajador
IS
SELECT nombre, SALPORHORA, HORASTRABAJADAS
FROM trabajadores;
vnombre VARCHAR2(50);
vsalporhora number(8,2);
vhorastrabajadas number(10);
BEGIN
OPEN ctrabajador;
LOOP
FETCH ctrabajador INTO vnombre,vsalporhora,vhorastrabajadas;
EXIT WHEN ctrabajador%NOTFOUND;
dbms_output.put_line('El registro es: ['||vnombre||' '||vsalporhora||' '||vhorastrabajadas ||']');
END LOOP;
CLOSE ctrabajador;
END;
/

SET SERVEROUTPUT ON
DECLARE
CURSOR ctrabajador
IS
SELECT nombre, SALPORHORA, HORASTRABAJADAS
FROM trabajadores;
vtrabajador ctrabajador%ROWTYPE;
sueldocalc number(8,2);
BEGIN
OPEN ctrabajador;
LOOP
FETCH ctrabajador INTO vtrabajador;
EXIT WHEN ctrabajador%NOTFOUND;
sueldocalc:=vtrabajador.salporhora*vtrabajador.HORASTRABAJADAS;
UPDATE trabajadores set sueldo=sueldocalc where trabajadores.nombre=vtrabajador.nombre;
--dbms_output.put_line('El trabajador '||vtrabajador.nombre||' ganó '||to_char(sueldo,'$999,999.00'));
END LOOP;
CLOSE ctrabajador;
END;
/

ALTER table trabajadores add sueldo number(8,2);

--Crear prodecimiento de pagina 68 primera presentación
-- Dato tipo IN
create or replace procedure insdato
(v_nombre IN trabajadores.nombre%TYPE, v_salxhora IN
trabajadores.salporhora%TYPE, v_horatrab IN
trabajadores.horastrabajadas%TYPE)
IS
BEGIN
INSERT INTO trabajadores (nombre,salporhora,horastrabajadas,sueldo)
values (v_nombre,v_salxhora,v_horatrab,v_salxhora*v_horatrab);
commit work;
end insdato;
/
@ 'N:\DiplomadoBD\Modulo3\procedimientoin.pls'

exec insdato('Boo', 30,50)

-- Crear procedimiento de pagina 69 primera persentación
--Dato tipo OUT
create or replace procedure consdato
(v_nombre IN VARCHAR2,
v_salxhora OUT NUMBER,
v_horatrab OUT NUMBER)
AS
BEGIN
select salporhora,horastrabajadas
into v_salxhora,v_horatrab
from trabajadores
where nombre=v_nombre;
END consdato;
/
@ 'N:\DiplomadoBD\Modulo3\consdato.pls'

--Usar el procedure del ejercicio anterior
SET SERVEROUTPUT ON
DECLARE
v_salxhora trabajadores.salporhora%TYPE;
v_horatrab trabajadores.horastrabajadas%TYPE;
BEGIN
consdato('Boo',v_salxhora,v_horatrab);
dbms_output.put_line('El empleado Boo tiene un salario x hora de:' ||' '|| v_salxhora ||' '|| 'y trabaja ' ||' '|| v_horatrab ||' '|| 'horas');
END;
/
@ 'N:\DiplomadoBD\Modulo3\llamarout.pls'


--Ejercicio procedimiento (IN/OUT) Pagina 71 primera presentación
CREATE TABLE estudiantes
(
	num_cuenta VARCHAR2(9) constraint es_pk PRIMARY KEY,
	nombre VARCHAR2(30),
	apellidos VARCHAR2(60)
);

INSERT INTO estudiantes values('123456789','Christian','Vazquez');
INSERT INTO estudiantes values('987654321','Steve','Pearce');
INSERT INTO estudiantes values('421563879','Ian','Kinsler');
INSERT INTO estudiantes values('354786900','Rafael','Devers');
INSERT INTO estudiantes values('578946125','Xander','Bogaerts');
INSERT INTO estudiantes values('548236971','Andrew','Benintendi');
INSERT INTO estudiantes values('402156931','Jackie','Bradley Jr.');
INSERT INTO estudiantes values('458963251','Mookie','Betts');
INSERT INTO estudiantes values('345789601','Brock','Holt');
INSERT INTO estudiantes values('478596325','Eduardo','Nunez');


create or replace procedure pbuscaalumno
(v_num_cuenta IN VARCHAR2,
v_nombre OUT VARCHAR2,
v_apellidos OUT VARCHAR2)
AS
BEGIN
select nombre,apellidos
into v_nombre,v_apellidos
from estudiantes
where num_cuenta=v_num_cuenta;
END pbuscaalumno;
/
@ 'N:\DiplomadoBD\Modulo3\pbuscaalumno.pls'

SET SERVEROUTPUT ON
DECLARE
v_nombre estudiantes.nombre%TYPE;
v_apellidos estudiantes.apellidos%TYPE;
v_ncta estudiantes.num_cuenta%TYPE :='&n';
BEGIN
pbuscaalumno(v_ncta,v_nombre,v_apellidos);
dbms_output.put_line('El estudiante con numero de cuenta '||v_ncta||' se llama '||v_nombre ||' '||v_apellidos);
END;
/
@ 'N:\DiplomadoBD\Modulo3\llamapbusca.pls'
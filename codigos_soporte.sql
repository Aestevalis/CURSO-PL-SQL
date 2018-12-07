-- https://docs.oracle.com/cd/B28359_01/appdev.111/b28371/adobjint.htm#ADOBJ001
--Ventajas de Usar Objetos en Oracle

-- Ejercicios de Programación Orientada a Objetos

CREATE TYPE food_t AS OBJECT (
   food_name    VARCHAR2 (100)
 , food_group   VARCHAR2 (100)
)
NOT FINAL;
/

CREATE TYPE dessert_t UNDER food_t (
   contains_chocolate   CHAR (1)
)
NOT FINAL;
/


DECLARE
   my_fav_veggie food_t := 
      food_t ('Broccoli', 'Vegetable');
BEGIN
   DBMS_OUTPUT.PUT_LINE (my_fav_veggie.food_name);
END;
/



CREATE TYPE food_t AS OBJECT (
   food_name    VARCHAR2 (100)
 , food_group   VARCHAR2 (100)
 , MEMBER FUNCTION food_string RETURN VARCHAR2
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY food_t
IS
   MEMBER FUNCTION food_string RETURN VARCHAR2
   IS
   BEGIN
      RETURN (SELF.food_name || ' - ' || SELF.food_group);
   END;
END;
/

CREATE TYPE dessert_t UNDER food_t (
   contains_chocolate   CHAR (1)
);
/

DECLARE
   my_croissant dessert_t := 
      dessert_t ('Croissant', 'Fun', 'Y');
BEGIN
   DBMS_OUTPUT.PUT_LINE (my_croissant.food_string);
END;
/

DECLARE
   my_croissant food_t := food_t ('Croissant', 'Fun');
BEGIN
   DBMS_OUTPUT.PUT_LINE (my_croissant.food_string);
END;
/


CREATE TYPE food_t AS OBJECT (
   food_name    VARCHAR2 (100)
 , food_group   VARCHAR2 (100)
 , NOT INSTANTIABLE MEMBER 
      FUNCTION food_string RETURN VARCHAR2      
)  NOT INSTANTIABLE NOT FINAL;
/


CREATE TYPE dessert_t UNDER food_t (
   contains_chocolate   CHAR (1)
 , OVERRIDING MEMBER FUNCTION food_string RETURN VARCHAR2
);
/


CREATE OR REPLACE TYPE BODY dessert_t
IS
   OVERRIDING MEMBER FUNCTION food_string RETURN VARCHAR2
   IS
   BEGIN
      RETURN (
         CASE SELF.contains_chocolate 
            WHEN 'Y' THEN UPPER (SELF.food_name)
            ELSE SELF.food_name
         END);
   END;
END;
/

DECLARE
   my_mint dessert_t := dessert_t ('Mint', 'Candy', 'Y');
BEGIN
   DBMS_OUTPUT.PUT_LINE (my_mint.food_string);
END;
/

DECLARE
   my_mint food_t := food_t ('Mint', 'Candy');
BEGIN
   DBMS_OUTPUT.PUT_LINE ('MINT');
END;
/

DECLARE
   my_mint dessert_t := dessert_t ('Mint', 'Candy', 'N');
BEGIN
   DBMS_OUTPUT.PUT_LINE (my_mint.food_string);
END;
/


DECLARE 
   r1 rectangle; 
   r2 rectangle; 
   r3 rectangle; 
   inc_factor number := 5; 
BEGIN 
   r1 := rectangle(3, 4); 
   r2 := rectangle(5, 7); 
   r3 := r1.enlarge(inc_factor); 
   r3.display;  
   IF (r1 > r2) THEN -- calling measure function 
      r1.display; 
   ELSE 
      r2.display; 
   END IF; 
END; 
/

everyone, everyone10+, teen, mature, AdultsOnly

CREATE TYPE videojuego_type as OBJECT(
Title VARCHAR2(50),
Developer VARCHAR2(50),
Publisher VARCHAR2(50),
ESRB_rating VARCHAR2(4),
MSRP NUMBER(5,2),
MEMBER FUNCTION can_sell return VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY videojuego_type
IS
	MEMBER FUNCTION can_sell return VARCHAR2
	IS
	BEGIN
	IF SELF.ESRB_rating = 'M' THEN
	RETURN(SELF.title||' no puede ser vendido a menores de 17 años');
	ELSIF SELF.ESRB_rating = 'AO' THEN
	RETURN(SELF.title||' no puede ser vendido a menores de 18 años');
	ELSE
	RETURN(SELF.title||' puede ser vendido sin restricciones');
	END IF;
	END;
END;
/

DECLARE
mijuego videojuego_type:=videojuego_type('The Witcher 3','CD Projekt','Bandai Namco','M',59.99);
BEGIN
DBMS_OUTPUT.PUT_LINE(mijuego.can_sell);
END;
/

CREATE TABLE videojuego_table OF videojuego_type;

INSERT INTO videojuego_table VALUES(
videojuego_type('Super Mario Odyssey','Nintendo','Nintendo','E',59.99)
);

INSERT INTO videojuego_table VALUES(
videojuego_type('The Witcher 3','CD Projekt','Bandai Namco','M',59.99)
);


CREATE TYPE team_type AS OBJECT(
	team_id NUMBER(4,0),
	team_name VARCHAR2(30),
	team_city VARCHAR2(30),
	country VARCHAR2(30),
	MEMBER FUNCTION team_str return VARCHAR2
)
NOT FINAL;
/

CREATE OR REPLACE TYPE BODY team_type
IS
	MEMBER FUNCTION team_str return VARCHAR2
	IS
	BEGIN
	RETURN('El equipo '||SELF.team_name||' juega en la ciudad de '||SELF.team_city||', '||SELF.country);
	END;
END;
/

CREATE TYPE academy_type UNDER team_type(
academy_name VARCHAR2(30),
OVERRIDING MEMBER FUNCTION team_str return VARCHAR2
)
NOT FINAL;
/

CREATE OR REPLACE TYPE BODY academy_type AS
	OVERRIDING MEMBER FUNCTION team_str return VARCHAR2 
	IS
	BEGIN
	RETURN(SELF.academy_name||' es el equipo de ligas menores perteneciente a '||SELF.team_city||' '||SELF.team_name);
	END;
END;
/

CREATE TYPE player_type AS OBJECT(
gamer_tag VARCHAR2(30),
first_name VARCHAR2(30),
last_name VARCHAR2(30),
DOB DATE,
jersey_number NUMBER(3,0),
country_birth VARCHAR2(50),
current_team team_type,
MEMBER PROCEDURE player_bio (SELF IN OUT NOCOPY player_type),
MEMBER FUNCTION player_age return VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY player_type AS
	MEMBER FUNCTION player_age return VARCHAR2 IS
	fecha DATE;
	edad NUMBER;
	BEGIN
	edad:=MONTHS_BETWEEN(sysdate,SELF.DOB)/12;
	RETURN(trunc(edad)||' años');
	END player_age;
	MEMBER PROCEDURE player_bio (SELF IN OUT NOCOPY player_type) IS
	BEGIN
	DBMS_OUTPUT.PUT_LINE('Jugador: '||INITCAP(first_name)||' "'||gamer_tag||'" '||INITCAP(last_name));
	DBMS_OUTPUT.PUT_LINE('Nacio el: '||DOB||' en '||country_birth);
	DBMS_OUTPUT.PUT_LINE('Edad: '||player_age);
	DBMS_OUTPUT.PUT_LINE('Equipo Actual: '||current_team.team_city||' '||current_team.team_name);
	DBMS_OUTPUT.PUT_LINE('Usa el numero: '||jersey_number);
	END player_bio;
END;
/


CREATE TABLE teams_table OF team_type;
CREATE TABLE roster_table OF player_type;
CREATE TABLE academy_table OF academy_type;

DECLARE
BEGIN
INSERT INTO teams_table VALUES(team_type(1,'Excelsior','New York','USA'));
INSERT INTO teams_table VALUES(team_type(2,'Valiant','Los Angeles','USA'));
INSERT INTO teams_table VALUES(team_type(3,'Uprising','Boston','USA'));
INSERT INTO teams_table VALUES(team_type(4,'Gladiators','Los Angeles','USA'));
INSERT INTO teams_table VALUES(team_type(5,'Spitfire','London','UK'));
INSERT INTO teams_table VALUES(team_type(6,'Fusion','Philadelphia','USA'));
INSERT INTO teams_table VALUES(team_type(7,'Outlaws','Houston','USA'));
INSERT INTO teams_table VALUES(team_type(8,'Dynasty','Seoul','South Korea'));
INSERT INTO teams_table VALUES(team_type(9,'Shock','San Francisco','USA'));
INSERT INTO teams_table VALUES(team_type(10,'Fuel','Dallas','USA'));
INSERT INTO teams_table VALUES(team_type(11,'Mayhem','Florida','USA'));
INSERT INTO teams_table VALUES(team_type(12,'Dragons','Shangai','China'));
END;
/

DECLARE
BEGIN
INSERT INTO academy_table VALUES(academy_type(1,'Excelsior','New York','USA','XL Academy'));
INSERT INTO academy_table VALUES(academy_type(4,'Gladiators','Los Angeles','USA','Gladiators Legion'));
INSERT INTO academy_table VALUES(academy_type(10,'Fuel','Dallas','USA','Envy Us'));
END;
/

DECLARE
equipo team_type;
BEGIN
select value(t) INTO equipo from teams_table t WHERE team_id=8;
INSERT INTO roster_table VALUES('Ryujehong','ryu','je-hong','05/09/1991',14,'South Korea'
	,team_type(equipo.team_id,equipo.team_name,equipo.team_city,equipo.country));
INSERT INTO roster_table VALUES('Tobi','Jin-mo','Yang','26/02/1994',7,'South Korea'
	,team_type(equipo.team_id,equipo.team_name,equipo.team_city,equipo.country));
INSERT INTO roster_table VALUES('Fissure','Baek','Chan-hyung','26/02/1994',22,'South Korea'
	,team_type(equipo.team_id,equipo.team_name,equipo.team_city,equipo.country));
select value(t) INTO equipo from teams_table t WHERE team_id=10;
INSERT INTO roster_table VALUES('Seagull','Brandon','Larned','23/07/1992',23,'USA'
	,team_type(equipo.team_id,equipo.team_name,equipo.team_city,equipo.country));
INSERT INTO roster_table VALUES('OGE','Min-Seok','Son','15/10/1999',2,'South Korea'
	,team_type(equipo.team_id,equipo.team_name,equipo.team_city,equipo.country));
END;
/

DECLARE
equipo team_type;
BEGIN
SELECT value(t) INTO equipo from teams_table t WHERE team_id=8;
DBMS_OUTPUT.PUT_LINE (equipo.team_str);
END;
/

DECLARE
jugador player_type;
BEGIN
SELECT value(t) INTO jugador from roster_table t WHERE gamer_tag='Seagull';
DBMS_OUTPUT.PUT_LINE ('El jugador '||jugador.gamer_tag||' juega en el equipo '||jugador.current_team.team_name);
DBMS_OUTPUT.PUT_LINE (jugador.current_team.team_str);
END;
/

DECLARE
juego videojuego_type;
BEGIN
SELECT value(t) INTO juego from videojuego_table t WHERE Title='Super Mario Odyssey';
DBMS_OUTPUT.PUT_LINE (juego.can_sell);
END;
/

DECLARE
academia academy_type;
BEGIN
SELECT value(t) INTO academia from academy_table t WHERE academy_name='Gladiators Legion';
DBMS_OUTPUT.PUT_LINE (academia.team_str);
END;
/

DECLARE
jugador player_type;
BEGIN
SELECT value(t) INTO jugador FROM roster_table t WHERE t.gamer_tag='Ryujehong';
jugador.player_bio();
END;
/

select r.current_team.team_name from roster_table r where r.current_team.team_id=8;

DROP TABLE roster_table;
DROP TABLE academy_table;
DROP TABLE teams_table;
DROP TYPE player_type;
DROP TYPE academy_type;
DROP TYPE team_type;
CREATE OR REPLACE FUNCTION Numero_a_Texto ( Imp Number, NumDec Number Default 2)
RETURN VarChar2
IS
Es_Un_Numero Number;
imp_let VarChar2(150);
imp_char VarChar2(12);
impd_char VarChar2(2);
importe_let varchar2(100);

BEGIN
-- Se pasa a cadena
imp_char := To_Char(Trunc(Imp));
impd_char:= Substr(Ltrim(Ltrim(To_Char(Imp - Trunc(Imp)),'.'),','), 1, NumDec);

SELECT

--Centenas de miles de millones.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),1,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,2),'00','CIEN ','CIENTO '),
2,'DOSCIENTOS ',
3,'TRESCIENTOS ',
4,'CUATROCIENTOS ',
5,'QUINIENTOS ',
6,'SEISCIENTOS ',
7,'SETECIENTOS ',
8,'OCHOCIENTOS ',
9,'NOVECIENTOS ',
0,'')

||
--Decenas miles de millones.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),2,1),
1,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1),
0,'DIEZ ',
1,'ONCE MIL ',
2,'DOCE MIL ',
3,'TRECE MIL ',
4,'CATORCE MIL ',
5,'QUINCE MIL ',
6,'DICISEIS MIL ',
7,'DIECISIETE MIL ',
8,'DIECIOCHO MIL ',
9,'DIECINUEVE MIL '),
2,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'VEINTE ','VEINTI'),
3,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'TREINTA ','TREINTA Y '),
4,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'CUARENTA ','CUARENTA Y '),
5,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'CINCUENTA ','CINCUENTA Y '),
6,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'SESENTA ','SESENTA Y '),
7,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'SETENTA ','SETENTA Y '),
8,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'OCHENTA ','OCHENTA Y '),
9,DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1), 0,'NOVENTA ','NOVENTA Y '),
0,'')

||
--Unidades de milles de millones
DECODE (SUBSTR(LPAD(imp_char,12,'0'),3,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),'1','',
DECODE(SUBSTR(LPAD(imp_char,12,'0'),1,3),'001','MIL ','UN MIL ' ) ),
2,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','DOS MIL '),
3,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','TRES MIL '),
4,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','CUATRO MIL '),
5,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','CINCO MIL '),
6,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','SEIS MIL '),
7,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','SIETE MIL '),
8,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','OCHO MIL '),
9,DECODE(SUBSTR(LPAD(imp_char,12,'0'),2,1),1,'','NUEVE MIL '),
0,DECODE(SUBSTR(LPAD(imp_char,12,'0'),1,3),'000','','MIL '))

||
--Centenas de millon.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),4,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,2),'00','CIEN ','CIENTO '),
2,'DOSCIENTOS ',
3,'TRESCIENTOS ',
4,'CUATROCIENTOS ',
5,'QUINIENTOS ',
6,'SEISCIENTOS ',
7,'SETECIENTOS ',
8,'OCHOCIENTOS ',
9,'NOVECIENTOS ',
0,'')

||
--Decenas de millon.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),5,1),
1,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1),
0,'DIEZ ',
1,'ONCE MILLONES ',
2,'DOCE MILLONES ',
3,'TRECE MILLONES ',
4,'CATORCE MILLONES ',
5,'QUINCE MILLONES ',
6,'DICISEIS MILLONES ',
7,'DIECISIETE MILLONES ',
8,'DIECIOCHO MILLONES ',
9,'DIECINUEVE MILLONES '),
2,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'VEINTE ','VEINTI'),
3,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'TREINTA ','TREINTA Y '),
4,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'CUARENTA ','CUARENTA Y '),
5,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'CINCUENTA ','CINCUENTA Y '),
6,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'SESENTA ','SESENTA Y '),
7,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'SETENTA ','SETENTA Y '),
8,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'OCHENTA ','OCHENTA Y '),
9,DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1), 0,'NOVENTA ','NOVENTA Y '),
0,'')

||
--Unidades de millon.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),6,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),'1','',
DECODE(SUBSTR(LPAD(imp_char,12,'0'),3,2),'00','UN MILLON ','UN MILLONES ') ),
2,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','DOS MILLONES '),
3,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','TRES MILLONES '),
4,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','CUATRO MILLONES '),
5,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','CINCO MILLONES '),
6,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','SEIS MILLONES '),
7,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','SIETE MILLONES '),
8,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','OCHO MILLONES '),
9,DECODE(SUBSTR(LPAD(imp_char,12,'0'),5,1),1,'','NUEVE MILLONES '),
0,DECODE(SUBSTR(LPAD(imp_char,12,'0'),3,3),'000','','MILLONES '))

||
--Centenas de millar.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),7,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,2),'00','CIEN ','CIENTO '),
2,'DOSCIENTOS ',
3,'TRESCIENTOS ',
4,'CUATROCIENTOS ',
5,'QUINIENTOS ',
6,'SEISCIENTOS ',
7,'SETECIENTOS ',
8,'OCHOCIENTOS ',
9,'NOVECIENTOS ',
0,'')

||
--Decenas de millar.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),8,1),
1,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1),
0,'DIEZ ',
1,'ONCE MIL ',
2,'DOCE MIL ',
3,'TRECE MIL ',
4,'CATORCE MIL ',
5,'QUINCE MIL ',
6,'DICISEIS MIL ',
7,'DIECISIETE MIL ',
8,'DIECIOCHO MIL ',
9,'DIECINUEVE MIL '),
2,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'VEINTE ','VEINTI'),
3,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'TREINTA ','TREINTA Y '),
4,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'CUARENTA ','CUARENTA Y '),
5,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'CINCUENTA ','CINCUENTA Y '),
6,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'SESENTA ','SESENTA Y '),
7,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'SETENTA ','SETENTA Y '),
8,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'OCHENTA ','OCHENTA Y '),
9,DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1), 0,'NOVENTA ','NOVENTA Y '),
0,'')

||
--Unidades de millar
DECODE (SUBSTR(LPAD(imp_char,12,'0'),9,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),'1','',
DECODE(SUBSTR(LPAD(imp_char,12,'0'),7,3),'001','MIL ','UN MIL ' ) ),
2,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','DOS MIL '),
3,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','TRES MIL '),
4,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','CUATRO MIL '),
5,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','CINCO MIL '),
6,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','SEIS MIL '),
7,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','SIETE MIL '),
8,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','OCHO MIL '),
9,DECODE(SUBSTR(LPAD(imp_char,12,'0'),8,1),1,'','NUEVE MIL '),
0,DECODE(SUBSTR(LPAD(imp_char,12,'0'),7,3),'000','','MIL '))

||
--Centenas.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),10,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,2),'00','CIEN','CIENTO '),
2,'DOSCIENTOS ',
3,'TRESCIENTOS ',
4,'CUATROCIENTOS ',
5,'QUINIENTOS ',
6,'SEISCIENTOS ',
7,'SETECIENTOS ',
8,'OCHOCIENTOS ',
9,'NOVECIENTOS ',
0,'')

||
--Decenas.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),11,1),
1,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12),
0,'DIEZ ',
1,'ONCE ',
2,'DOCE ',
3,'TRECE ',
4,'CATORCE ',
5,'QUINCE ',
6,'DIECISEIS ',
7,'DIECISIETE ',
8,'DIECIOCHO ',
9,'DIECINUEVE '),
2,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'VEINTE ','VEINTI'),
3,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'TREINTA ','TREINTA Y '),
4,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'CUARENTA ','CUARENTA Y '),
5,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'CINCUENTA ','CINCUENTA Y '),
6,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'SESENTA ','SESENTA Y '),
7,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'SETENTA ','SETENTA Y '),
8,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'OCHENTA ','OCHENTA Y '),
9,DECODE (SUBSTR(LPAD(imp_char,12,'0'),12), 0,'NOVENTA ','NOVENTA Y '),
0,'')

||
--Unidades.
DECODE (SUBSTR(LPAD(imp_char,12,'0'),12,1),
1,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','UNO '),
2,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','DOS '),
3,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','TRES '),
4,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','CUATRO '),
5,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','CINCO '),
6,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','SEIS '),
7,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','SIETE '),
8,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','OCHO '),
9,DECODE(SUBSTR(LPAD(imp_char,12,'0'),11,1),1,'','NUEVE '),
0,DECODE(SUBSTR(LPAD(imp_char,12,'0'),1,12),'000000000000','CERO ','') )
||
DECODE(LPAD(impd_char,2,'0'),'00','','CON ')||
--Decimales
--Decenas.
DECODE (SUBSTR(LPAD(impd_char,2,'0'),1,1),
0,DECODE(SUBSTR(LPAD(impd_char,2,'0'),2),
1,'UNO ',
2,'DOS ',
3,'TRES ',
4,'CUATRO ',
5,'CINCO ',
6,'SEIS ',
7,'SIETE ',
8,'OCHO ',
9,'NUEVE '),
1,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2),
0,'DIEZ ',
1,'ONCE ',
2,'DOCE ',
3,'TRECE ',
4,'CATORCE ',
5,'QUINCE ',
6,'DIECISEIS ',
7,'DIECISIETE ',
8,'DIECIOCHO ',
9,'DIECINUEVE '),
2,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'VEINTE ','VEINTI'),
3,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'TREINTA ','TREINTA Y '),
4,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'CUARENTA ','CUARENTA Y '),
5,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'CINCUENTA ','CINCUENTA Y '),
6,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'SESENTA ','SESENTA Y '),
7,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'SETENTA ','SETENTA Y '),
8,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'OCHENTA ','OCHENTA Y '),
9,DECODE (SUBSTR(LPAD(impd_char,2,'0'),2), 0,'NOVENTA ','NOVENTA Y '),
0,'')
||
--Unidades.
DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),0,'',
DECODE (SUBSTR(LPAD(impd_char,2,'0'),2,1),
1,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','UN '),
2,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','DOS '),
3,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','TRES '),
4,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','CUATRO '),
5,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','CINCO '),
6,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','SEIS '),
7,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','SIETE '),
8,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','OCHO '),
9,DECODE(SUBSTR(LPAD(impd_char,2,'0'),1,1),1,'','NUEVE ')))
INTO importe_let
FROM DUAL;
RETURN (importe_let);
END Numero_a_Texto;
/
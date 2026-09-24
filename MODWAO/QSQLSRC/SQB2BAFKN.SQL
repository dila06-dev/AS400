/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: FM 02.06.2025 B2B-Web-Anbindung                             */
/*  --------------------------------------------------------------------  */
/*  Änderung: PH 03.06.2025 Projekt Dometic Germany - B2B (Case #03777387)*/
/*            AGJJ nach KOJJ und AGNR nach KONR umbenannt.                */
/*  Änderung: XX XX.XX.XXXX                                               */
/*  --------------------------------------------------------------------  */
/*                                                                        */
/*  Defintion SQL-Funktion                                                */
/*                                                                        */
/* Wichtig:                                                               */
/* LANGUAGE RPGLE                                                         */
/* PARAMETER STYLE GENERAL                                                */
/*                                                                        */
/* Unwichtig / optional:                                                  */
/* SPECIFIC MODWAO/GETB2BAFKNKOWT  -- Bibliotheksangabe                   */
/**************************************************************************/

CREATE OR REPLACE FUNCTION GETB2BAFKNKOWT (
 FIRM VARCHAR(2) CCSID 1141,
 KOJJ NUMERIC(4),
 KONR VARCHAR(6) CCSID 1141,
 KART VARCHAR(4) CCSID 1141
 )
 RETURNS NUMERIC(15, 2)
 LANGUAGE RPGLE
 SPECIFIC GETB2BAFKNKOWT
 NOT DETERMINISTIC
 READS SQL DATA
 CALLED ON NULL INPUT
 NOT FENCED
 EXTERNAL NAME 'SQB2B(GETB2BAFKNKOWT)'
 PARAMETER STYLE GENERAL ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION GETB2BAFKNKOWT
TO PUBLIC WITH GRANT OPTION ;

/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: FM 02.06.2025 B2B-Web-Anbindung                             */
/*  --------------------------------------------------------------------  */
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
/* SPECIFIC MODWAO1/GETB2BMWSTWERT -- Bibliotheksangabe                   */
/**************************************************************************/

CREATE OR REPLACE FUNCTION GETB2BMWSTWERT (
 FIRM VARCHAR(2) CCSID 1141,
 KDNR VARCHAR(10) CCSID 1141,
 VSNR VARCHAR(3) CCSID 1141
  )
 RETURNS NUMERIC(5, 2)
 LANGUAGE RPGLE
 SPECIFIC GETB2BMWSTWERT
 NOT DETERMINISTIC
 READS SQL DATA
 CALLED ON NULL INPUT
 NOT FENCED
 EXTERNAL NAME 'SQB2B(GETB2BMWSTWERT)'
 PARAMETER STYLE GENERAL ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION GETB2BMWSTWERT
TO PUBLIC WITH GRANT OPTION ;

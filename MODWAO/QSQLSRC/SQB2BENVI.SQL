/**************************************************************************/
/*                                                                        */
/*  Copyright 2022 by    trend SWM                                        */
/*                       Verwaltung GmbH                                  */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: FM 27.05.2025 B2B-Web-Anbindung                             */
/*  --------------------------------------------------------------------  */
/*                                                                        */
/*  Defintion SQL-Furnktion                                               */
/*                                                                        */
/* Wichtig:                                                               */
/* LANGUAGE RPGLE                                                         */
/* PARAMETER STYLE GENERAL                                                */
/*                                                                        */
/* Unwichtig / optional:                                                  */
/* SPECIFIC MODWAO1/GETB2BENVI     -- Bibliotheksangabe                   */
/**************************************************************************/

CREATE OR REPLACE FUNCTION MODWAO/GETB2BENVI (
 PGST VARCHAR(10) )
 RETURNS VARCHAR(10) CCSID 1141
 LANGUAGE RPGLE
 SPECIFIC MODWAO/GETB2BENVI
 NOT DETERMINISTIC
 READS SQL DATA
 CALLED ON NULL INPUT
 NOT FENCED
 EXTERNAL NAME 'SQB2B(GETB2BENVI)'
 PARAMETER STYLE GENERAL ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION GETB2BENVI
TO PUBLIC WITH GRANT OPTION ;

/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: FM 27.05.2025 B2B-Web-Anbindung                             */
/*  --------------------------------------------------------------------  */
/*  Änderung: PH 28.05.2025 Case #04303295 "B2B-Erweiterung Status 80     */
/*            Ablauf". Anpassung Länge PAKN und Rückgabewert. JAHR nach   */
/*            KMJJ und NMKR nach KMNR umbenannt.                          */
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
/* SPECIFIC MODWAO1/GETB2BAFVSURL  -- Bibliotheksangabe                   */
/**************************************************************************/

CREATE OR REPLACE FUNCTION MODWAO/GETB2BAFVSURL (
 FIRM VARCHAR(2) CCSID 1141,
 KMJJ NUMERIC(4),
 KMNR CHAR(6) CCSID 1141,
 PAKN CHAR(20) CCSID 1141
 )
 RETURNS VARGRAPHIC(300) CCSID 1200
 LANGUAGE RPGLE
 SPECIFIC MODWAO/GETB2BAFVSURL
 NOT DETERMINISTIC
 READS SQL DATA
 CALLED ON NULL INPUT
 NOT FENCED
 EXTERNAL NAME 'SQB2B(GETB2BAFVSURL)'
 PARAMETER STYLE GENERAL ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION GETB2BAFVSURL
TO PUBLIC WITH GRANT OPTION ;

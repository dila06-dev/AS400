/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: PH 27.05.2025 Case #04303295 "B2B-Erweiterung Status 80     */
/*            Ablauf"                                                     */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*                                                                        */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ002 "Ermitteln Preise (Liste!)"                                  */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ002
(
  IN FIRM VARCHAR(2) CCSID 1141,
  IN KDNR VARCHAR(10) CCSID 1141,
  IN GADA NUMERIC(8, 0),
  IN REQDTA VARCHAR(5000) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ002 GENERAL


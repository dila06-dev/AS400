/**************************************************************************/
/*  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: PH 16.02.2026 Case 05947674 "B2B Wiederverfügbarkeit"       */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*  --------------------------------------------------------------------  */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ009 "Ermitteln Wiederverfügbarkeitstermin".                      */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ009
(
  IN FIRM VARCHAR(2) CCSID 1141,
  IN REQDTA VARCHAR(5000) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ009 GENERAL


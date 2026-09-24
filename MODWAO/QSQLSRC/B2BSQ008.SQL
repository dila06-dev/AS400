/**************************************************************************/
/*  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: MG 13.02.2026 Case #05947700 Neue Angebotsabwicklung B2B    */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*                                                                        */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ008 "Generieren KD-Auftrag auf Basis KD-Angebots-Positionen"     */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ008
(
  IN inFIRM CHAR(2) CCSID 1141,
  IN inAGNR CHAR(11) CCSID 1141,
  IN inPOSI VARCHAR(5000) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ008 GENERAL


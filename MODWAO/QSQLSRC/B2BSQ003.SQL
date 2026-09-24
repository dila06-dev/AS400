/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: MG 05.06.2025 Case #03777387 ID: 6.1 Order histoty Details  */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*                                                                        */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ003 "Ermitteln Schlusskonditionen"                               */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ003
(
  IN FIRM CHAR(2) CCSID 1141,
  IN KONR CHAR1(11) CCSID 1141,
  IN KART CHAR(4) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ003 GENERAL


/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: MG 01.08.2025 Case #03777387 ID: 21.1  Quotation details   */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*                                                                        */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ007 "Ermitteln Positionskonditionen"                             */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ007
(
  IN FIRM CHAR(2) CCSID 1141,
  IN AGNR CHAR1(11) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ007 GENERAL


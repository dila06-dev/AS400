/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: PH 18.06.2025 Projekt Dometic Germany - B2B (Case #03777387)*/
/*            ID 6.1 "Order History Details"                              */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*                                                                        */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ006 "Auftragsdetail-Information"                                 */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ006
(
  IN FIRM VARCHAR(2) CCSID 1141,
  IN KDNR VARCHAR(10) CCSID 1141,
  IN AFJJNR CHAR(11) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ006 GENERAL


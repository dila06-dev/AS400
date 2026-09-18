/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: PH 05.06.Projekt Dometic Germany - B2B (Case #03777387)     */
/*            ID 23.1 "Determining the conditions for the order preview"  */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*                                                                        */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ004 "EErmitteln Schlusskonditionen Kunden-Nr/VS-Adresse"         */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ004
(
  IN FIRM VARCHAR(2) CCSID 1141,
  IN KDNR VARCHAR(10) CCSID 1141,
  IN VSNR VARCHAR(3) CCSID 1141,
  IN MENG NUMERIC(11, 2),
  IN WERT NUMERIC(11, 2)
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ004 GENERAL


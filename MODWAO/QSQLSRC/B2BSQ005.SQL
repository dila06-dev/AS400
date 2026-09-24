/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: MG 26.06.2025 Case #03777387 B2B Interface                  */
/*            ID 22 "Quotation Submission"                                */
/*  --------------------------------------------------------------------  */
/*  Änderung: XX XX.XX.XXXX                                               */
/*                                                                        */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ005 "Generieren KD-Auftrag auf Basis KD-Angebot"                 */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ005
(
  IN inFIRM CHAR(2) CCSID 1141,
  IN inAGNR CHAR(11) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ005 GENERAL


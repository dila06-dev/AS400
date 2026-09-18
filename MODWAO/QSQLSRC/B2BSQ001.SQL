/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: PH 27.05.2025 Case #04303295 "B2B-Erweiterung Status 80     */
/*            Ablauf"                                                     */
/*  --------------------------------------------------------------------  */
/*  Änderung: PH 25.06.2025 Case #04303295 "B2B-Erweiterung Status 80     */
/*            Ablauf". Nachtrag: Übergabe mehrerer Ident-Nr und der dazu- */
/*            gehörigen Mengen in einem langen String REQDTA. Der Über-   */
/*            gabeparameter FIRM ist nun als VARCHAR statt CHAR definiert.*/
/*  --------------------------------------------------------------------  */
/*  Dieses Programm erzeugt die Stored-Procedure für das Programm         */
/*  B2BSQ001 "Ermitteln/Prüfen Verfügbarkeit Auslaufartikel".             */
/*                                                                        */
/**************************************************************************/

CREATE OR REPLACE PROCEDURE B2BSQ001
(
  IN FIRM VARCHAR(2) CCSID 1141,
  IN REQDTA VARCHAR(5000) CCSID 1141
)
LANGUAGE RPGLE DYNAMIC RESULT SET 1
EXTERNAL NAME B2BSQ001 GENERAL


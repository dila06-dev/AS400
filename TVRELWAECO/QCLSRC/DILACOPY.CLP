/*    * PROGRAMMNAME.:COPY MEMBER FILES FOR DEVELOPMENT                      */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2011   COPY MEMBER FILES                                    */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/

  PGM        PARM(&SRC &TOMBR &CONFIRM)

  /* PARAMETER */
  DCL        VAR(&SRC)       TYPE(*CHAR) LEN(64)
  DCL        VAR(&TOMBR)     TYPE(*CHAR) LEN(64)
  DCL        VAR(&CONFIRM)   TYPE(*CHAR) LEN(4)

  /* PFADE */
  DCL        VAR(&FROMSTMF)  TYPE(*CHAR) LEN(256)
  DCL        VAR(&TOMBRPATH) TYPE(*CHAR) LEN(256)

  /* PARAMETER TRIMMEN */
  CHGVAR     VAR(&SRC)      VALUE(%TRIM(&SRC))
  CHGVAR     VAR(&TOMBR)    VALUE(%TRIM(&TOMBR))
  CHGVAR     VAR(&CONFIRM)  VALUE(%TRIM(&CONFIRM))


  /* BESTÄTIGUNG PRÜFEN */
  IF         COND(&CONFIRM *NE '*YES') THEN(DO)
     SNDPGMMSG  MSG('KOPIEREN NICHT BESTÄTIGT. AUFRUF MIT CONFIRM(*YES) ERFORDERLICH.')
     RETURN
  ENDDO

  /* IFS-QUELLPFAD: /HOME/LANGLITZ/<SRC> */
  CHGVAR     VAR(&FROMSTMF) +
               VALUE('/HOME/LANGLITZ/' *CAT &SRC)

  /* ZIELPFAD: /QSYS.LIB/TVRELWAECO.LIB/QRPGLESRC.FILE/<TOMBR> */
  CHGVAR     VAR(&TOMBRPATH) +
               VALUE('/QSYS.LIB/TVRELWAECO.LIB/QRPGLESRC.FILE/' +
                     *CAT &TOMBR)

  /* KOPIEREN */
  CPYFRMSTMF FROMSTMF(&FROMSTMF) +
             TOMBR(&TOMBRPATH) +
             MBROPT(*REPLACE) STMFCODPAG(*PCASCII)

  /* ERFOLGSMELDUNG */
  SNDPGMMSG  MSG('KOPIEREN ERFOLGREICH ABGESCHLOSSEN.')

  ENDPGM






















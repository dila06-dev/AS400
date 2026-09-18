/*    * PROGRAMMNAME.:COPY MEMBER FILES FOR DEVELOPMENT                      */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2011   COPY MEMBER FILES                                    */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/


  PGM        PARM(&SRCMBR &TOSTMF &CONFIRM)

  /* PARAMETER */
  DCL        VAR(&SRCMBR)   TYPE(*CHAR) LEN(10)
  DCL        VAR(&TOSTMF)   TYPE(*CHAR) LEN(64)
  DCL        VAR(&CONFIRM)  TYPE(*CHAR) LEN(4)

  /* PFADE */
  DCL        VAR(&FROMMBR)  TYPE(*CHAR) LEN(256)
  DCL        VAR(&STMF)     TYPE(*CHAR) LEN(256)

  /* PARAMETER TRIMMEN */
  CHGVAR     VAR(&SRCMBR)   VALUE(%TRIM(&SRCMBR))
  CHGVAR     VAR(&TOSTMF)   VALUE(%TRIM(&TOSTMF))
  CHGVAR     VAR(&CONFIRM)  VALUE(%TRIM(&CONFIRM))

  /* BESTÄTIGUNG PRÜFEN */
  IF         COND(&CONFIRM *NE '*YES') THEN(DO)
     SNDPGMMSG  MSG('EXPORT NICHT BESTÄTIGT. AUFRUF MIT CONFIRM(*YES) ERFORDERLICH.')
     RETURN
  ENDDO

  /* FROMMBR: /QSYS.LIB/DOMGEN.LIB/QRPGLESRC.FILE/<SRCMBR>.MBR */
  CHGVAR     VAR(&FROMMBR) +
               VALUE('/QSYS.LIB/DOMGEN.LIB/QRPGLESRC.FILE/' *CAT +
                     &SRCMBR *TCAT '.MBR')

  /* TOSTMF: /HOME/LANGLITZ/<TOSTMF> */
  CHGVAR     VAR(&STMF) +
               VALUE('/HOME/LANGLITZ/' *CAT &TOSTMF)
  /* KOPIEREN: QSYS ? IFS */
  CPYTOSTMF  FROMMBR(&FROMMBR) +
             TOSTMF(&STMF) +
             STMFOPT(*REPLACE) STMFCODPAG(*PCASCII)

  /* ERFOLGSMELDUNG */
  SNDPGMMSG MSG('EXPORT ERFOLGREICH ABGESCHLOSSEN.')

  ENDPGM






















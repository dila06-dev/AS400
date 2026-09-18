/*    * PROGRAMMNAME.:$DUMMY                                                 */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-START DUMMY                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

             IF         COND(&QTIME *GT '173000') THEN(GOTO +
                          CMDLBL(ENDPGM))

    /*       RTVDTAARA  DTAARA(GANG/$GANG) (1 1)) +          */
    /*                    RTNVAR(&$GANG)                     */
    /*       MONMSG     MSGID(CPF0000) EXEC(DO)              */
    /*           GOTO       CMDLBL(ENDPGM)                   */
    /*       ENDDO                                           */
    /*                                                       */
    /*       IF         COND($GANG *NE '1') THEN(DO)         */
    /*           GOTO       CMDLBL(ENDPGM)                   */
    /*       ENDDO                                           */

/*    *-AKTUALISIEREN ARTIKELSTAMM ENDVERBRAUCHERPREIS                       */
             CALL       PGM(DUMMY512) PARM(' ' '#AR0510' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(ENDPGM)

             DLYJOB     DLY(300)

 ENDPGM:

             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM

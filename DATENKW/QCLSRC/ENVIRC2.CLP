/*    * PROGRAMMNAME.:LAGERBEWUC                                             */
/*    * FUNKTION.....:BUCHUNGEN DER BEWEGUNGEN AUS TREND                     */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&VERSION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(01)
             DCL        VAR(&RC)      TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256)

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR4)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR5)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR6)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR7)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR8)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR9)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR0)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

             IF         COND(&PARM = '1') THEN(DO)
             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGPRJ2) POSITION(*AFTER QTEMP)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGAFPN) POSITION(*AFTER PROGPRJ2)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGAFP) POSITION(*AFTER PROGAFPN)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR5) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGN) POSITION(*AFTER PROGAFP)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR6) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROG) POSITION(*AFTER PROGN)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR7) +
                          VALUE('1'))

             ADDLIBLE   LIB(PRODDMS53) POSITION(*AFTER PROG)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR8) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROD) POSITION(*AFTER PRODDMS53)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR9) +
                          VALUE('1'))

        /*   CALL       PGM(PROG/LDA000)   */
        /*   MONMSG     MSGID(CPF0000)     */

             ENDDO

             IF         COND(&PARM = '2') THEN(DO)
                RMVLIBLE   LIB(DATENKW)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(BAR_KALK)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(PROGPRJ2)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(PROGAFPN)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(PROGAFP)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(PROGN)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(PROG)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(PRODDMS53)
             MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(PROD)
             MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:
             ENDPGM

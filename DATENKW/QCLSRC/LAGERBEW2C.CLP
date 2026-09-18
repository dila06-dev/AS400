/*    * PROGRAMMNAME.:LAGERBEWUC                                             */
/*    * FUNKTION.....:BUCHUNGEN DER BEWEGUNGEN AUS TREND                     */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&VERSION)

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

             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVPF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGPRJ2) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR5) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGAFPN) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR6) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGAFP) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR7) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROGN) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR8) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR9) +
                          VALUE('1'))

             ADDLIBLE   LIB(PRODWIN51) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(PROD) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR0) +
                          VALUE('1'))

             CALL       PGM(PROG/LDA000)
             MONMSG     MSGID(CPF0000)

/*                -ARTIKELDATEN AUFBAUEN                                     */
                   CALL PGM(ARTIKELC) PARM('$$EL_PS_DB')
                   MONMSG     MSGID(CPF0000)

             CALL       PGM(DATENKW/LAGERBEW2R) PARM(&VERSION '0' '0')
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(DATENKW)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
             ENDDO
             IF         COND(&ERROR4 = '0') THEN(DO)
                RMVLIBLE   LIB(TVPF)
             ENDDO
             IF         COND(&ERROR5 = '0') THEN(DO)
                RMVLIBLE   LIB(PROGPRJ2)
             ENDDO
             IF         COND(&ERROR6 = '0') THEN(DO)
                RMVLIBLE   LIB(PROGAFPN)
             ENDDO
             IF         COND(&ERROR7 = '0') THEN(DO)
                RMVLIBLE   LIB(PROGAFP)
             ENDDO
             IF         COND(&ERROR8 = '0') THEN(DO)
                RMVLIBLE   LIB(PROGN)
             ENDDO
             IF         COND(&ERROR9 = '0') THEN(DO)
                RMVLIBLE   LIB(PROG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(PRODWIN51)
             ENDDO
             IF         COND(&ERROR0 = '0') THEN(DO)
                RMVLIBLE   LIB(PROD)
             ENDDO

             ENDPGM

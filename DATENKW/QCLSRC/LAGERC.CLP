/*    * PROGRAMMNAME.:LAGERC                                                 */
/*    * FUNKTION.....:ÜBERNAHME LAGERDATEN                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&LAGER)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&LAGER)   TYPE(*CHAR) LEN(08)
             DCL        VAR(&VERSION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(01)
             DCL        VAR(&RC)      TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256)

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR4)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR5)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(PRODTST88) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

             ADDLIBLE   LIB(TAMF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVPF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR5) +
                          VALUE('1'))

             IF         COND(&LAGER = '99999999') THEN(DO)
                CLRPFM     PRJ605P
                MONMSG     MSGID(CPF0000)
                CLRPFM     PRJ605P2
                MONMSG     MSGID(CPF0000)
                CLRPFM     PRJ605P3
                MONMSG     MSGID(CPF0000)
             ENDDO

             CALL       PGM(LAGERR) PARM(&VERSION ' ' &MODUS)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(PRODTST88)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(DATENKW)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(TAMF)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(TVPF)
             ENDDO

             ENDPGM

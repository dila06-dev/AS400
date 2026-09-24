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
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

     /*      ADDLIBLE   LIB(PRODTST88) POSITION(*LAST)            */
     /*      MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) + */
     /*                   VALUE('1'))                             */

             ADDLIBLE   LIB(PRODWIN51) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVPF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

             CRTSQLRPGI OBJ(DATENKW/LAGERBEWR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKW/LAGERBEW2R) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKW/TRENDSTATR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
      /*     IF         COND(&ERROR1 = '0') THEN(DO)     */
      /*        RMVLIBLE   LIB(PRODTST88)                */
      /*     ENDDO                                       */
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(PRODWIN51)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(DATENKW)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(TVPF)
             ENDDO

             ENDPGM

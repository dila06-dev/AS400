/*    * PROGRAMMNAME.:CALL LOHAUR                                            */
/*    * FUNKTION.....:AUSWERTUNGEN FRAU LOHAUS                               */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

             IF         COND(&PARM = '1') THEN(DO)
                ADDLIBLE   LIB(AISOBJ) POSITION(*LAST)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                           VALUE('1'))
             ENDDO
             IF         COND(&PARM = '0') THEN(DO)
                RMVLIBLE   LIB(AISOBJ)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                           VALUE('1'))
                DSPJOBLOG  OUTPUT(*PRINT)
             ENDDO
 ENDPGM:

             ENDPGM

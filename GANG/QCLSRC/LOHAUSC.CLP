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

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CLRPFM     FILE(#DL0050)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#DL0051)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#DL0100)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#DL0200)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#DL0205)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(LOHAUSR)
             MONMSG     MSGID(CPF0000)

             MONMSG     MSGID(CPF0000)
             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM

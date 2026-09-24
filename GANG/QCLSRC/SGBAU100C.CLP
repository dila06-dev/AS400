/*    * PROGRAMMNAME.:CALL SGBAU100R                                         */
/*    * FUNKTION.....:UPDATE AUF AUFTRAGSDATEI                               */
/*    * JUNI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*DEC) LEN(06)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(WAECOEDI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             DLYJOB     DLY(05)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&PARM) VALUE(40631)
             CALL       PGM(SGBAU100R) PARM(&PARM)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&PARM) VALUE(88505)
             CALL       PGM(SGBAU100R) PARM(&PARM)
             MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(WAECOEDI)
             ENDDO

             ENDPGM

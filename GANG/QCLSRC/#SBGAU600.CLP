/*    * PROGRAMMNAME.:#SBGAU600                                              */
/*    * FUNKTION.....:.                                                      */
/*    * SEPTEMBER 2010 GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(WAECOEDI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

/*    *-PRÜFUNG FELDINHALT KORRKETUR AU6090                                  */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0055' ' ' ' ' +
                             ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*    *-FÜLLEN WAECOEDI/#SBGAU600                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0056' ' ' ' ' +
                             '#SBGAU600' 'WAECOEDI' '*ADD')
             MONMSG     MSGID(CPF0000)

/*    *-ÜBERNAHME FEHLENDER SBAU600-SÄTZE                                    */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0057' ' ' ' ' +
                             'SBGAU600' '*LIBL' '*ADD')
             MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(WAECOEDI)
             ENDDO
             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM

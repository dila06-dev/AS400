/*-------------------------------------------------*/
/*    * PROGRAMMNAME.:SBGPRS00_P                                             */
/*    * FUNKTION.....:CALL SBGPRS00_P VERBUCHUNG PREISE IN SBGPRS00          */
/*    * OKTOBER 2009                                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             PGM        PARM(&PARM)

             /* PARM = KUNDEN                               */
             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&MD)      TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&RCD)     TYPE(*CHAR) LEN(01) VALUE('0')

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&PARM *NE '     ') THEN(DO)
                /* LÖSCHEN ALLER PREISLISTEN FÜR DEN KUNDEN    */
                CHGVAR     VAR(%SST(&MD 01 05)) VALUE(%SST(&PARM +
                          01 05))
                CALL       PGM(DUMMY512) PARM(&MD '#KA0300' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             enddo
             CALL       PGM(SBGPRS00_P) PARM(&PARM &RCD)

 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM

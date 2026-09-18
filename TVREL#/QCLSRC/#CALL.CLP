/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

   /*TESTUMGEBUNG AKTIV           */
   /*        CALL       PGM(TE)   */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(%SST(&CALL 1 2)) VALUE('TR')
             CHGVAR     VAR(%SST(&CALL 3 4)) VALUE(%SST(&PARM 1 4))
             CHGVAR     VAR(%SST(&CALL 7 2)) VALUE('ST')
             CHGVAR     VAR(%SST(&CALL 9 2)) VALUE('  ')
             CALL       PGM(&CALL)
             MONMSG     MSGID(CPF0000)

             CALL PGM(#DEFLDA)
             MONMSG     MSGID(CPF0000)
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO

             ENDPGM

/*    * PROGRAMMNAME.:ABSATZZAHLEN ERMITTELN                                 */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ABSATZR) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ABSATZ2C  ')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

/*          ERMITTLUNG NUR NOCH FÜR ÖSTERREICH                               */
             CALL       PGM(ABSATZC_SC)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILE1)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILE1_)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILE2)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILE3)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILE4)
             MONMSG     MSGID(CPF0000)

/*          ______________________________________________                   */

/*          UMWELTMANAGEMENT DATASTREAM                                      */
             CALL       PGM(ABSATZ2R)
             MONMSG     MSGID(CPF0000)

/*          ______________________________________________                   */

             CLRPFM     FILE(TVRELWAECO/UMMFILEAU1)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILEAU2)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILEAU3)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/UMMFILEAU4)
             MONMSG     MSGID(CPF0000)

/*          ______________________________________________                   */

/*          UMWELTMANAGEMENT DATASTREAM   AU411                              */
             CALL       PGM(ABSATZ2AUR)
             MONMSG     MSGID(CPF0000)

/*          ______________________________________________                   */

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM

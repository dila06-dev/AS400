/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SC88505_C ')
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

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

    /*       GOTO SAVE    */

 START:
             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
                CALL       PGM(DUMMY512) PARM(&MD '#DC4000' ' ' ' ' +
                           '#AFRK88505' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#DC4002' ' ' ' ' +
                           '#AFRK88505' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(TVRELWAECO/DOMINV_FR) +
                           TOFILE(TVRELWAECO/DOMINV_FRS) +
                           TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/DOMINV_FR)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(SC88505_R)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(TVRELWAECO/DOMINV_FR) +
                             TOFILE(WAECOEDI/DOMINVCHCK) +
                             MBROPT(*REPLACE) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)

  SAVE:
                RTVMBRD    FILE(TVRELWAECO/DOMINV_FR) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURRCD) +
                           VALUE(0))
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   CALL       PGM(GFTPINV) PARM('fr')
                   MONMSG     MSGID(CPF0000)
                ENDDO


                CALL       PGM(DUMMY512) PARM(&MD '#DC4001' ' ' ' ' +
                           '#DC4001   ' 'QTEMP     ' '*REPLACE')
                MONMSG     MSGID(CPF0000)

                RTVMBRD    FILE(QTEMP/#DC4001) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURRCD) +
                           VALUE(0))
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   DLYJOB     DLY(60)
                   MONMSG     MSGID(CPF0000)
                   GOTO       CMDLBL(START)
                ENDDO
                IF         COND(&NBRCURRCD *EQ 0) THEN(DO)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 14)) VALUE('Sätze verarb.')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 115 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM

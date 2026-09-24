/*    * PROGRAMMNAME.:$INTERFACE                                             */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-DER JOB IST RESTARTFÄHIG                                             */
/*    * $INTERFACE                                                           */
/*    *  CHGDTAARA DTAARA(TVRELWAECO/$INTERFACE *ALL) VALUE('0')              */
/*    *  DSPDTAARA DTAARA(TVRELWAECO/$INTERFACE)                              */
/*    *  0 BEDEUTET NICHT AKTIV 1 BEDEUTET AKTIV                              */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')


             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('$INVOICES ')
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


 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

/*   -AUFRUF ....                                                            */
             IF         COND(&QTIME *GT '190000') THEN(DO)
/*             -PART INVOICES OVER FTP                                       */
                CALL PGM(TVRELWAECO/SC88505_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC40631_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC01887_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC15177_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC62765_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC98264_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC78678_C) PARM('1')
                MONMSG     MSGID(CPF0000)
/*             -AUFRUF INVOICES FÜR MAILS (CSV-DATEI)                        */
/*             -RESTART BEI ABBRUCH IM FORFELD BARENKAMP                     */
/*      1      -CHGDTAARA DTAARA(ABDATUM) VALUE('20120120')BARENKAMP         */
/*      2      -CALL QCMD                                  BARENKAMP         */
/*      3      -PGM'S KOPIEREN OHNE + ZEICHEN              BARENKAMP         */
/*      4      -CHGDTAARA DTAARA(ABDATUM) VALUE('        ')BARENKAMP         */
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('40631' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('54939' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('62765' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('02921' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('01887' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('78146' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('05084' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('88505' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('55278' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('15177' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('42634' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('08138' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 ENDPGM:
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
